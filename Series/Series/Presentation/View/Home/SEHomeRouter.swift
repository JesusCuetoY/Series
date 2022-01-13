//
//  SEHomeRouter.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import UIKit

protocol SEHomeRouterInput: AnyObject {
    func routeToShowDetail(fromID id: String)
    func routeToActivity()
    func routeToStopActivity()
    func routeToError(model: SEError?)
}

class SEHomeRouter {
    /// Home view controller property
    private unowned var viewController: SEHomeViewController
    
    init(from viewController: SEHomeViewController) {
        self.viewController = viewController
    }
    
    private func getAlert(title: String?, message: String?) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = SEStylesApp.Color.SE_PrimaryColor
        return alertController
    }
}

extension SEHomeRouter: SEHomeRouterInput {
    func routeToShowDetail(fromID id: String) {
        
    }
    
    func routeToActivity() {
        
    }
    
    func routeToStopActivity() {
        
    }
    
    func routeToError(model: SEError?) {
        self.viewController.present(self.getAlert(title: NSLocalizedString(SEKeys.MessageKeys.listErrorTitle, comment: SEKeys.MessageKeys.emptyText), message: model?.message), animated: true, completion: nil)
    }
}
