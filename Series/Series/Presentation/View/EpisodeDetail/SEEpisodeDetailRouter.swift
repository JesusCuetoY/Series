//
//  SEEpisodeDetailRouter.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import UIKit

protocol SEEpisodeDetailRouterInput: AnyObject {
    func routeToShow()
    func routeToActivity()
    func routeToStopActivity()
    func routeToError(model: SEError?)
}

class SEEpisodeDetailRouter {
    /// Home view controller property
    private unowned var viewController: SEEpisodeDetailViewController
    
    init(from viewController: SEEpisodeDetailViewController) {
        self.viewController = viewController
    }
    
    private func getAlert(title: String?, message: String?) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = SEStylesApp.Color.SE_PrimaryColor
        let doneAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(doneAction)
        return alertController
    }
}

// MARK: - SEShowDetailRouterInput's implementation
extension SEEpisodeDetailRouter: SEEpisodeDetailRouterInput {
    func routeToShow() {
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    func routeToActivity() {
        
    }
    
    func routeToStopActivity() {
        
    }
    
    func routeToError(model: SEError?) {
        self.viewController.present(self.getAlert(title: NSLocalizedString(SEKeys.MessageKeys.listErrorTitle, comment: SEKeys.MessageKeys.emptyText), message: model?.message), animated: true, completion: nil)
    }
}
