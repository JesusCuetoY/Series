//
//  SEShowDetailRouter.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import UIKit

protocol SEShowDetailRouterInput: AnyObject {
    func routeToShowEpisodeDetail(from episode: SEShowEpisodeModel)
    func routeToShowList()
    func routeToActivity()
    func routeToStopActivity()
    func routeToError(model: SEError?)
}

class SEShowDetailRouter {
    /// Home view controller property
    private unowned var viewController: SEShowDetailViewController
    
    init(from viewController: SEShowDetailViewController) {
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
extension SEShowDetailRouter: SEShowDetailRouterInput {
    func routeToShowEpisodeDetail(from episode: SEShowEpisodeModel) {
        let destinationVC = SEEpisodeDetailViewController()
        destinationVC.configurator.set(episodeInfo: episode)
        self.viewController.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToActivity() {
        
    }
    
    func routeToShowList() {
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    func routeToStopActivity() {
        
    }
    
    func routeToError(model: SEError?) {
        self.viewController.present(self.getAlert(title: NSLocalizedString(SEKeys.MessageKeys.listErrorTitle, comment: SEKeys.MessageKeys.emptyText), message: model?.message), animated: true, completion: nil)
    }
}
