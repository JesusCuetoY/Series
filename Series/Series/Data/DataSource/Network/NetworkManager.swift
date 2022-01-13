//
//  NetworkManager.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    /**
     Method that perform a request of type GET and return an expected value depending of the especified mode and reponse status.
     - Parameter url: The service's `URL`.
     - Parameter returningClass: Expected success value of `Codable` type.
     - Parameter returningError: Bloque de código que recibe un objeto `WebServicesResponse`, el cual contiene los datos de la respuesta del servicio.
     - Parameter parameters: Body of the request.
     - Parameter success: Success closure that containts an expected value of `Codable`type.
     - Parameter failure: Failure closure that containts an expected value of `Codable`type.
     */
    func getRequest<T, U>(_ url: URL, returningClass: T.Type?, returningError: U.Type?, parameters: Any?, success: @escaping(T) -> Void, failure: @escaping(U) -> Void) where T: Codable, U: Codable
    /**
     Method that perform a request of type POST and return an expected value depending of the especified mode and reponse status.
     - Parameter url: The service's `URL`.
     - Parameter returningClass: Expected success value of `Codable` type.
     - Parameter returningError: Bloque de código que recibe un objeto `WebServicesResponse`, el cual contiene los datos de la respuesta del servicio.
     - Parameter parameters: Body of the request.
     - Parameter success: Success closure that containts an expected value of `Codable`type.
     - Parameter failure: Failure closure that containts an expected value of `Codable`type.
     */
    func postRequest<T, U>(_ url: URL, returningClass: T.Type?, returningError: U.Type?, parameters: Any?, success: @escaping(T) -> Void, failure: @escaping(U) -> Void) where T: Codable, U: Codable
    /**
     Method that perform a request of type DELETE and return an expected value depending of the especified mode and reponse status.
     - Parameter url: The service's `URL`.
     - Parameter returningClass: Expected success value of `Codable` type.
     - Parameter returningError: Bloque de código que recibe un objeto `WebServicesResponse`, el cual contiene los datos de la respuesta del servicio.
     - Parameter parameters: Body of the request.
     - Parameter success: Success closure that containts an expected value of `Codable`type.
     - Parameter failure: Failure closure that containts an expected value of `Codable`type.
     */
    func deleteRequest<T, U>(_ url: URL, returningClass: T.Type?, returningError: U.Type?, parameters: Any?, success: @escaping(T) -> Void, failure: @escaping(U) -> Void) where T: Codable, U: Codable
}

class NetworkManager {
    
    init() {}
    
    deinit {
        print("NetworkManager deallocated")
    }
    
    @inline(__always) private func validateResponse<T, U>(response: WebServicesResponse, modelToMap: T.Type?, errorToMap: U.Type?) -> (Any?, Any?) where T: Codable, U: Codable {
        switch response.state {
        case .timeout:
            return (nil, SEError(code: 11, message: NSLocalizedString(SEKeys.MessageKeys.networkTimeOutError, comment: SEKeys.MessageKeys.emptyText), messageDetail: NSLocalizedString(SEKeys.MessageKeys.networkTimeOutError, comment: SEKeys.MessageKeys.emptyText)))
        case .offline:
            return (nil, SEError(code: 11, message: NSLocalizedString(SEKeys.MessageKeys.networkOfflineError, comment: SEKeys.MessageKeys.emptyText), messageDetail: NSLocalizedString(SEKeys.MessageKeys.networkOfflineError, comment: SEKeys.MessageKeys.emptyText)))
        case .server, .canceled, .failure, .tokenBlacklisted:
            return (nil, SEError(code: 11, message: NSLocalizedString(SEKeys.MessageKeys.networkServerError, comment: SEKeys.MessageKeys.emptyText), messageDetail: NSLocalizedString(SEKeys.MessageKeys.networkServerError, comment: SEKeys.MessageKeys.emptyText)))
        case .success:
            do {
                let statusCode = response.statusCode
                switch statusCode {
                case 200 ..< 205:
                    //Success
                    if modelToMap.self == Data.self {
                        return (response.data ?? Data(), nil)
                    }
                    let model = try JSONDecoder().decode(modelToMap!.self, from: response.data ?? Data())
                    return (model, nil)
                case 400 ..< 405:
                    //Failure
                    let error = try JSONDecoder().decode(errorToMap!.self, from: response.data ?? Data())
                    return (nil, error)
                default:
                    return (nil, SEError(code: 11, message: NSLocalizedString(SEKeys.MessageKeys.networkParserErrorTitle, comment: SEKeys.MessageKeys.emptyText), messageDetail: response.message ?? NSLocalizedString(SEKeys.MessageKeys.networkParserErrorMessage, comment: SEKeys.MessageKeys.emptyText)))
                }
            } catch {
                return (nil, SEError(code: 11, message: NSLocalizedString(SEKeys.MessageKeys.networkParserErrorTitle, comment: SEKeys.MessageKeys.emptyText), messageDetail: response.message ?? NSLocalizedString(SEKeys.MessageKeys.networkParserErrorMessage, comment: SEKeys.MessageKeys.emptyText)))
            }
        }
    }
    
    private func manage<T, U>(response webServiceResponse: WebServicesResponse, returningClass: T.Type?, returningError: U.Type?, success: @escaping (T) -> Void, failure: @escaping (U) -> Void) where T: Codable, U: Codable {
        let (response, error) = self.validateResponse(response: webServiceResponse, modelToMap: returningClass, errorToMap: returningError)
        if let res = response as? T {
            success(res)
        } else {
            failure(error as! U)
        }
    }
}

// MARK: - NetworkManagerProtocol's functions
extension NetworkManager: NetworkManagerProtocol {
    func getRequest<T, U>(_ url: URL, returningClass: T.Type?, returningError: U.Type?, parameters: Any?, success: @escaping (T) -> Void, failure: @escaping (U) -> Void) where T : Decodable, T : Encodable, U : Decodable, U : Encodable {
        var dataTask: URLSessionDataTask?
        WebServicesManager.contentType = .Raw
        WebServicesManager.getWithURL(url, parameters: parameters, dataTask: &dataTask) { [weak self] (webServiceResponse) in
            self?.manage(response: webServiceResponse, returningClass: returningClass, returningError: returningError, success: success, failure: failure)
        }
    }
    
    func postRequest<T, U>(_ url: URL, returningClass: T.Type?, returningError: U.Type?, parameters: Any?, success: @escaping (T) -> Void, failure: @escaping (U) -> Void) where T : Decodable, T : Encodable, U : Decodable, U : Encodable {
        var uploadTask: URLSessionUploadTask?
        WebServicesManager.contentType = .Raw
        WebServicesManager.postWithURL(url, parameters: parameters, uploadTask: &uploadTask) { [unowned self] (webServiceResponse) in
            self.manage(response: webServiceResponse, returningClass: returningClass, returningError: returningError, success: success, failure: failure)
        }
    }
    
    func deleteRequest<T, U>(_ url: URL, returningClass: T.Type?, returningError: U.Type?, parameters: Any?, success: @escaping (T) -> Void, failure: @escaping (U) -> Void) where T : Decodable, T : Encodable, U : Decodable, U : Encodable {
        var dataTask: URLSessionDataTask?
        WebServicesManager.contentType = .Raw
        WebServicesManager.deleteWithURL(url, parameters: parameters, dataTask: &dataTask) { [unowned self] (webServicesResponse) in
            self.manage(response: webServicesResponse, returningClass: returningClass, returningError: returningError, success: success, failure: failure)
        }
    }
}
