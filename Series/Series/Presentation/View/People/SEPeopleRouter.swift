//
//  SEPeopleRouter.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import UIKit

protocol SEPeopleRouterInput: AnyObject {
    func routeToPersonDetail(fromID id: String)
    func routeToActivity()
    func routeToStopActivity()
    func routeToError(model: SEError?)
    func routeToEmptyResultError(message: String)
    func routeToHideError()
}

class SEPeopleRouter {
    /// Home view controller property
    private unowned var viewController: SEPeopleViewController
    
    init(from viewController: SEPeopleViewController) {
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

// MARK: - SEHomeRouterInput's implementation
extension SEPeopleRouter: SEPeopleRouterInput {
    func routeToPersonDetail(fromID id: String) {
//        let destinationVC = SEShowDetailViewController()
//        destinationVC.configurator.set(showId: id)
//        self.viewController.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToActivity() {
        
    }
    
    func routeToStopActivity() {
        
    }
    
    func routeToError(model: SEError?) {
        self.viewController.present(self.getAlert(title: NSLocalizedString(SEKeys.MessageKeys.listErrorTitle, comment: SEKeys.MessageKeys.emptyText), message: model?.message), animated: true, completion: nil)
    }
    
    func routeToEmptyResultError(message: String) {
        self.viewController.searchResultErrorLabel.text = message
        self.viewController.showCollectionView.isHidden = true
        self.viewController.searchResultErrorLabel.isHidden = false
    }
    
    func routeToHideError() {
        self.viewController.searchResultErrorLabel.isHidden = true
        self.viewController.showCollectionView.isHidden = false
    }
}
