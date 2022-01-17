//
//  SEPeopleDetailRouter.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import UIKit

protocol SEPeopleDetailRouterInput: AnyObject {
    func routeToShowDetail(from id: String)
    func routeToPeopleList()
    func routeToActivity()
    func routeToStopActivity()
    func routeToError(model: SEError?)
}

class SEPeopleDetailRouter {
    /// Home view controller property
    private unowned var viewController: SEPeopleDetailViewController
    
    init(from viewController: SEPeopleDetailViewController) {
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

// MARK: - SEPeopleDetailRouterInput's implementation
extension SEPeopleDetailRouter: SEPeopleDetailRouterInput {
    func routeToShowDetail(from id: String) {
        let destinationVC = SEShowDetailViewController()
        destinationVC.configurator.set(showId: id)
        self.viewController.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToActivity() {
        
    }
    
    func routeToPeopleList() {
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    func routeToStopActivity() {
        
    }
    
    func routeToError(model: SEError?) {
        self.viewController.present(self.getAlert(title: NSLocalizedString(SEKeys.MessageKeys.listErrorTitle, comment: SEKeys.MessageKeys.emptyText), message: model?.message), animated: true, completion: nil)
    }
}
