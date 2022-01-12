//
//  WebServicesManager.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

// MARK: - Enums

/**
 Data type that represents the state for the response from the web service. The constants are:
   - success: Constant that represents the success in the response of the web service.
   - failure: Constant that represents any error that may have occurred before, during or after the request of the web services.
   - canceled: Constant that indicates that the request of web services was canceled.
   - timeout: Constant that indicates that the timeout for the request of web services was exceeded.
 */
internal enum WebServicesResponseState: Int {
    /// The success in the response of the web service.
    case success = 0
    /// Any error that could occur before, during or after the request of the web services.
    case failure
    /// The request of web services was canceled.
    case canceled
    /// Timeout for request of web services has been exceeded.
    case timeout
    /// The login token has expired.
    case tokenBlacklisted
    /// Without connection
    case offline
    /// No connection to the server
    case server
}

/**
 Data type that represents the nature of the parameters sent in the body of the request. The constants are:
   - None: Constant that indicates that it is not specified how the parameters are sent.
   - FormData: Constant that indicates that the parameters will be sent via form-data.
   - Raw: Constant that indicates that the parameters will be sent via raw.
 */
internal enum WebServicesContentType: String {
    /// It is not specified how the parameters are sent.
    case None = ""
    /// Parameters sent via form-data.
    case FormData = "multipart/form-data"
    /// Parameters sent via raw.
    case Raw = "application/json"
}

/**
  Data type that represents the possible error messages that are handled directly from the server.
  The constants are:
  - General: The general error message. This message will appear when there is an error on the server.
  - Timeout: The error message that will appear when the timeout has expired. The time is defined by the `timeoutInterval` property.
  */
private enum WebServicesErrorMessage: String {
    /// The general error message.
    case General = "Sorry, an error occurred.\nPlease contact the provider"
    /// The error message for being offline.
    case Offline = "Internet connection seems to be offline"
    /// The timeout error message.
    case Timeout = "Timeout has expired"
    /// The message from the inactive server
    case Server = "Service not available"
}


// MARK: - WebServicesManager classes

/**
 Class that represents the response of the web service.
 All the methods to consume web services of the `WebServicesManager` class return an object of this type.
 At a minimum, for an instance of this class to be valid for further operation, the value of the `error` variable must be` nil`; and the value of `response`, different from` nil`.
 */
internal class WebServicesResponse: NSObject {
    
    // MARK: Properties
    
    /// The response from the web service in JSON format.
    /// - Note: The response can be an `Array`,` Dictionary` or `nil` if an error occurred.
    internal var response: Any? = nil
    
    /// The response of the web service in binary.
    /// - Note: Parsing this object results in the value for the `response` variable. `nil` if an error occurred in the web service.
    internal var data: Data? = nil
    
    /// The status of the response.
    internal var state: WebServicesResponseState = WebServicesResponseState.success
    
    /// The message related to the response status.
    /// - Note: This value is `nil` for the` Success` and `Canceled` states.
    internal var message: String?
    
    /// The HTTP status code of the response.
    internal var statusCode: Int = 0
    
    /// The header of the response.
    internal var headers: [String: Any]?
}

/**
 Clase que maneja la conexión entre la aplicación y los servicios web.
 Esta clase expone métodos que permiten consumir servicios web en POST, GET y PUT. Además, expone propiedades para manejar las credenciales de autorización, si es necesario, y de tiempo de espera.
 */
@objc internal class WebServicesManager: NSObject {
    
    // MARK: Properties
    
    /// La naturaleza de los datos envíados como parámetros en el cuerpo de la petición.
    /// - Note: El valor por defecto no especifica la naturaleza de los datos.
    internal static var contentType: WebServicesContentType = WebServicesContentType.None
    
    /// Variable que permite saber si el consumo de los servicios web necesitan autorización.
    /// - Note: El valor por defecto de la autorización es `false`.
    internal static var needsAuthorization = false
    
    /// Variable que permite saber si se desea guardar el "token" de inicio de sesión automaticamente.
    /// - Note: El valor por defecto de esta variable es `false`.
    internal static var saveLoginTokenIfFound = false
    
    /// El tiempo máximo de espera para el consumo de los servicios web en segundos.
    /// - Note: El valor por defecto del tiempo de espera es de 60 segundos.
    internal static var timeoutInterval = 30.0
    
    /// El nombre de usuario para la authorizacíon del consumo de los servicios web.
    internal static var user = "user"
    
    /// El contraseña para la authorizacíon del consumo de los servicios web.
    internal static var password = "password"
    
    /// El nombre para obtener el "token" de inicio de sesión desde el `NSUserDefaults`.
    @objc internal static var loginTokenKey = "WebServicesManagerLoginTokenKey"
    
    // MARK: - Setup methods
    
    /**
    Method in charge of creating the "header" of the request with or without credentials.
    - Returns: The "header" of the request.
    */
    private class func additionalHeaders () -> [String: Any]? {
        var headers = [String: Any] ()
                    
        /*
        Remember that the value of the Content-Type will depend on how the data is going to be sent.
        For more details, see the comments for the WebServicesContentType data type above.
        */
        if self.contentType != .None {/* If it is not specified how the data is sent, then the Content-Type is not added to the additional headers. */
            headers ["Content-Type"] = self.contentType.rawValue as Any?
        }
        
        if self.needsAuthorization == true {/* If consumption of web services needs authorization ... */
            var authorization: String?
            
            if let token = (UserDefaults.standard.string (forKey: self.loginTokenKey)) {
                authorization = token
            }
            else if let credentialData = "\(self.user): \(self.password)".data(using: String.Encoding.utf8) {
                let credentials = credentialData.base64EncodedString (options: NSData.Base64EncodingOptions (rawValue: 0))
                authorization = "Basic \(credentials)"
            }
            else {
                print ("\(self) - \(#function) / Error trying to create credentials to consume web services.")
            }
            
            headers ["auth_token"] = authorization as Any?
        }
        return headers
    }
    
    /**
     Method in charge of saving the user's session "token" if the configuration allows it.
    In case there is no session "token", the method does not execute code.
    - Parameters headers:
    */
    private class func saveLoginTokenFromHeaders (_ headers: [String: Any]) -> Bool {
        let userDefaults = UserDefaults.standard
        let headerToken = headers ["_token"] as? String
        userDefaults.set (headerToken, forKey: self.loginTokenKey)
        let headerTokenSaved = userDefaults.synchronize ()
        return headerTokenSaved
    }
    
    /**
     Method that allows obtaining an `NSData` object with the parameters sent. This method is useful for sending parameters using "POST" method and when the server expects to receive them in "form-data".
    - Parameter parameters: The parameters sent. If the parameters are not in a dictionary, then the conversion cannot be done.
    - Returns: The `NSData` object with the parameters sent or` nil` if they are not in a dictionary.
    */
    private class func formDataWithParameters (_ parameters: Any) -> Data? {
        var formData: Data? = nil
        if parameters as? [String: Any] != nil {
            let parametersToParse = parameters as! [String: Any]
            var arrayWithParameters = [String] ()
            for (key, value) in parametersToParse {
                arrayWithParameters.append ("\(key) = \(value)")
            }
            let stringWithParameters = arrayWithParameters.joined (separator: "&")
            formData = stringWithParameters.data(using: String.Encoding.utf8)
        }
        return formData
    }
    
    /**
    Method that allows converting the code of an error `NSError` of the web services into a tuple whose values ​​are the state and its respective message if necessary.
    - Parameter error: The error of the web service or `nil` if there was none.
    - Returns: A tuple whose values ​​are: the constant of the type `WebServicesResponseState` and the respective message if necessary. Possible return constants are `Success` (default value),` Failure`, `Canceled`,` Timeout`. Only for the case `Success` and` Canceled` there will be no message.
    */
    private class func webServicesResponseStateAndMessageForError (_ error: Error?) -> (WebServicesResponseState, String?) {
        var stateAndMessage: (state: WebServicesResponseState, message: String?) = (.success, nil) // By default, the state is successful and there is no message.
        if let error = error as NSError? {
            print ("\(self) - \(#function) / Error: \(error)")
            switch error.code {
            case -999: stateAndMessage.state = WebServicesResponseState.canceled; stateAndMessage.message = nil
            case -1001: stateAndMessage.state = WebServicesResponseState.timeout; stateAndMessage.message = WebServicesErrorMessage.Timeout.rawValue
            case -1009: stateAndMessage.state = WebServicesResponseState.offline; stateAndMessage.message = WebServicesErrorMessage.Offline.rawValue
            case -1004: stateAndMessage.state = WebServicesResponseState.server; stateAndMessage.message = WebServicesErrorMessage.Server.rawValue
            default: stateAndMessage.state = WebServicesResponseState.failure; stateAndMessage.message = WebServicesErrorMessage.General.rawValue
            }
        }
        return stateAndMessage
    }

    // MARK: - WebServicesManager's methods
    
    /**
    Method that is responsible for consuming a POST type service. This method receives an `NSURLSessionUploadTask` object, which will allow the request to be canceled or paused at any time outside of this class.
    - Parameter URL: The URL of the service.
    - Parameter uploadTask: The `NSURLSessionUploadTask` that will allow to start the request.
    - Parameter completionHandler: Block of code that receives a `WebServicesResponse` object, which contains the data of the service response.
    */
    internal class func postWithURL(_ URL: Foundation.URL?, parameters: Any?, uploadTask: UnsafeMutablePointer<URLSessionUploadTask?>, completionHandler: @escaping (_ webServicesResponse: WebServicesResponse) -> Void) {
        
        var data: Data? = nil /* By default, the value is `nil` if there are no parameters or the JSON object was not converted to binary, but remember that the operation is automatically canceled when, when creating the` URLSessionUploadTask` instance, the parameters are `nil`. */
        if let parameters = parameters {
            if self.contentType == .Raw {
                do { /* Convert JSON object to binary. */
                    data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                }
                catch { /* Print the exeption in case of conversion failure. */
                    print("\(self) - \(#function) / Error trying to convert the parameters to a JSON object.")
                }
            }
            else if self.contentType == .FormData || self.contentType == .None {
                data = self.formDataWithParameters(parameters)
            }
        }
        else { /* The operation is automatically canceled when the parameters to create an instance of `URLSessionUploadTask` are` nil`; therefore, an instance is created. */
            data = Data()
        }
        
        //Print send
        print(URL as Any)
        print(parameters as Any)
        
        var request = URLRequest(url: URL!)
        request.httpMethod = "POST"
        request.httpBody = data
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.additionalHeaders()
        sessionConfiguration.timeoutIntervalForRequest = self.timeoutInterval
        
        let session = URLSession(configuration: sessionConfiguration)
        uploadTask.pointee = session.uploadTask(with: request, from: data, completionHandler: { (data: Data?, URLResponse: URLResponse?, error: Error?) -> Void in
            var response: Any? = nil /* The response from the web service. `nil` if an error occurred or the parsing was not possible. */
            if error == nil { /* If there is no error in the response, there is data... */
                do {
                    response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(response!)
                }
                catch {/* Print the exeption in case of conversion failure. */
                    print("\(self) - \(#function) / Error trying to convert the parameters to a JSON object.")
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let stateAndMessage: (state: WebServicesResponseState, message: String?) = self.webServicesResponseStateAndMessageForError(error)
                
                // Create the response entity.
                let webServicesResponse = WebServicesResponse()
                webServicesResponse.state = stateAndMessage.state  /* `.success` if there is no error. */
                webServicesResponse.message = stateAndMessage.message /* Message related to the response. */
                webServicesResponse.response = response /* `nil` whether there is an error or the parse couldn't be made. */
                webServicesResponse.data = data /* `nil` if there is an error. */
                
                // Obtain the status code and headers.
                if let HTTPURLResponse = URLResponse as? HTTPURLResponse, let headers = HTTPURLResponse.allHeaderFields as? [String: Any] {
                    webServicesResponse.statusCode = HTTPURLResponse.statusCode
                    webServicesResponse.response = (webServicesResponse.statusCode == 403) ? nil : webServicesResponse.response
                    webServicesResponse.state = (webServicesResponse.statusCode == 403) ? .tokenBlacklisted : stateAndMessage.state
                    webServicesResponse.headers = headers
                    
                    // If the user has configured the session "token" to be saved automatically, the operation is performed.
                    if self.saveLoginTokenIfFound == true {
                        let headerTokenSaved = self.saveLoginTokenFromHeaders(headers)
                        webServicesResponse.response = (headerTokenSaved == false) ? nil : webServicesResponse.response
                        webServicesResponse.state = (headerTokenSaved == false) ? .failure : stateAndMessage.state
                        
                        print("\(type(of: self)) - \(#function) / The sesion token \((headerTokenSaved == true) ? "Did" : "Didn't") save correctly.")
                        self.saveLoginTokenIfFound = false /* After the operation has been carried out, the value of the variable returns to the initial one. This way, the developer will not have to watch for this variable unless he intends to do this again. */
                    }
                }
                
                completionHandler(webServicesResponse)
            })
        })
        
        uploadTask.pointee?.resume()
    }
    
    /**
    Method that is responsible for consuming a service of type GET. This method receives an `NSURLSessionDataTask` object, which will allow the request to be canceled or paused at any time outside of this class.
    - Parameter URL: The URL of the service.
    - Parameter dataTask: The `NSURLSessionDataTask` that will allow to start the request.
    - Parameter completionHandler: Block of code that receives a `WebServicesResponse` object, which contains the data of the service response.
    */
    internal class func getWithURL(_ URL: Foundation.URL?, parameters: Any?, dataTask: UnsafeMutablePointer<URLSessionDataTask?>, completionHandler: @escaping (_ webServicesResponse: WebServicesResponse) -> Void) {
        var data: Data? = nil
        if let parameters = parameters {
            do {
                data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            }
            catch {
                print("\(self) - \(#function) / Error trying to convert the parameters to a JSON object.")
            }
        }
        
        //Print send
        print(URL as Any)
        print(parameters as Any)
        
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        request.httpBody = data
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.additionalHeaders()
        sessionConfiguration.timeoutIntervalForRequest = self.timeoutInterval
        
        let session = URLSession(configuration: sessionConfiguration)
        dataTask.pointee = session.dataTask(with: request, completionHandler: { (data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> Void in
            var response: Any? = nil
            if error == nil {
                do {
                    response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                }
                catch {
                    print("\(self) - \(#function) / Error trying to parse the web service's response.")
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let stateAndMessage: (state: WebServicesResponseState, message: String?) = self.webServicesResponseStateAndMessageForError(error)
                
                let webServicesResponse = WebServicesResponse()
                webServicesResponse.state = stateAndMessage.state
                webServicesResponse.message = stateAndMessage.message
                webServicesResponse.response = response
                webServicesResponse.data = data
                
                if let HTTPURLResponse = URLResponse as? HTTPURLResponse, let headers = HTTPURLResponse.allHeaderFields as? [String: Any] {
                    webServicesResponse.statusCode = HTTPURLResponse.statusCode
                    webServicesResponse.state = (webServicesResponse.statusCode == 403) ? .tokenBlacklisted : stateAndMessage.state
                    webServicesResponse.headers = headers
                }
                
                completionHandler(webServicesResponse)
            })
        })
        
        dataTask.pointee?.resume()
    }
    
    /**
    Method that is responsible for consuming a PUT type service. This method receives an `NSURLSessionUploadTask` object, which will allow the request to be canceled or paused at any time outside of this class.
    - Parameter URL: The URL of the service.
    - Parameter uploadTask: The `NSURLSessionUploadTask` that will allow to start the request.
    - Parameter completionHandler: Block of code that receives a `WebServicesResponse` object, which contains the data of the service response.
    */
    internal class func putWithURL(_ URL: Foundation.URL?, parameters: Any?, uploadTask: UnsafeMutablePointer<URLSessionUploadTask?>, completionHandler: @escaping (_ webServicesResponse: WebServicesResponse) -> Void) {
        var data: Data? = nil
        if let parameters = parameters {
            if self.contentType == .Raw {
                do {
                    data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                }
                catch {
                    print("\(self) - \(#function) / Error trying to convert the parameters to a JSON object.")
                }
            }
            else if self.contentType == .FormData || self.contentType == .None {
                data = self.formDataWithParameters(parameters)
            }
        }
        
        var request = URLRequest(url: URL!)
        request.httpMethod = "PUT"
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.additionalHeaders()
        sessionConfiguration.timeoutIntervalForRequest = self.timeoutInterval
        
        let session = URLSession(configuration: sessionConfiguration)
        uploadTask.pointee = session.uploadTask(with: request, from: data, completionHandler: { (data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> Void in
            var response: Any? = nil
            if error == nil {
                do {
                    response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                }
                catch {
                    print("\(self) - \(#function) / Error trying to parse the web service's response")
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let stateAndMessage: (state: WebServicesResponseState, message: String?) = self.webServicesResponseStateAndMessageForError(error)
                
                // Crear la entidad respuesta.
                let webServicesResponse = WebServicesResponse()
                webServicesResponse.state = stateAndMessage.state
                webServicesResponse.message = stateAndMessage.message
                webServicesResponse.response = response
                webServicesResponse.data = data
                
                // Obtener el status code y las cabeceras..
                if let HTTPURLResponse = URLResponse as? HTTPURLResponse, let headers = HTTPURLResponse.allHeaderFields as? [String: Any] {
                    webServicesResponse.statusCode = HTTPURLResponse.statusCode
                    webServicesResponse.state = (webServicesResponse.statusCode == 403) ? .tokenBlacklisted : stateAndMessage.state
                    webServicesResponse.headers = headers
                }
                
                completionHandler(webServicesResponse)
            })
        })
        
        uploadTask.pointee?.resume()
    }
    
    /**
    Method that is responsible for consuming a DELETE type service. This method receives an `NSURLSessionDataTask` object, which will allow the request to be canceled or paused at any time outside of this class.
    - Parameter URL: The URL of the service.
    - Parameter dataTask: The `NSURLSessionDataTask` that will allow to start the request.
    - Parameter completionHandler: Block of code that receives a `WebServicesResponse` object, which contains the data of the service response.
    */
    internal class func deleteWithURL(_ URL: Foundation.URL?, parameters: Any?, dataTask: UnsafeMutablePointer<URLSessionDataTask?>, completionHandler: @escaping (_ webServicesResponse: WebServicesResponse) -> Void) {
        var data: Data? = nil
        if let parameters = parameters {
            if self.contentType == .Raw {
                do {
                    data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                }
                catch {
                    print("\(self) - \(#function) / Error trying to convert the parameters to a JSON object.")
                }
            }
            else if self.contentType == .FormData || self.contentType == .None {
                data = self.formDataWithParameters(parameters)
            }
        }
        
        var request = URLRequest(url: URL!)
        request.httpMethod = "DELETE"
        request.httpBody = data
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.additionalHeaders()
        sessionConfiguration.timeoutIntervalForRequest = self.timeoutInterval
        
        let session = URLSession(configuration: sessionConfiguration)
        dataTask.pointee = session.dataTask(with: request, completionHandler: { (data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> Void in
            var response: Any? = nil
            if error == nil {
                do {
                    response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                }
                catch {
                    print("\(self) - \(#function) / Error trying to parse the web service's response")
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let stateAndMessage: (state: WebServicesResponseState, message: String?) = self.webServicesResponseStateAndMessageForError(error)
                
                // Crear la entidad respuesta.
                let webServicesResponse = WebServicesResponse()
                webServicesResponse.state = stateAndMessage.state
                webServicesResponse.message = stateAndMessage.message
                webServicesResponse.response = response
                webServicesResponse.data = data
                
                // Obtener el status code y las cabeceras..
                if let HTTPURLResponse = URLResponse as? HTTPURLResponse, let headers = HTTPURLResponse.allHeaderFields as? [String: Any] {
                    webServicesResponse.statusCode = HTTPURLResponse.statusCode
                    webServicesResponse.state = (webServicesResponse.statusCode == 403) ? .tokenBlacklisted : stateAndMessage.state
                    webServicesResponse.headers = headers
                }
                
                completionHandler(webServicesResponse)
            })
        })
        
        dataTask.pointee?.resume()
    }
}
