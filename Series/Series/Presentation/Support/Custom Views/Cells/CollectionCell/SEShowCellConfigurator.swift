//
//  SEShowCellConfigurator.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

/**
 Class that configurates the cell presenter.
 */
class SEShowCellConfigurator {
    // MARK: - Properties
    private unowned var view: SEShowCollectionViewCell
    private var showInfo: SEShowModel
    
    init(from view: SEShowCollectionViewCell, showInfo: SEShowModel) {
        self.view = view
        self.showInfo = showInfo
    }
    
    func configure() -> SEShowCellPresenterInput {
        let request = NetworkManager()
        
        let repository = SEPosterRepository(from: request)
        let interactor = SEPosterInteractor(from: repository)
    
        return SEShowCellPresenter(from: interactor, showModel: self.showInfo, output: self.view)
    }
}
