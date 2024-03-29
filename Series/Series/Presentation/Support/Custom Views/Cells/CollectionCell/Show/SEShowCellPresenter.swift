//
//  SEShowCellPresenter.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

protocol SEShowCellPresenterInput: AnyObject {
    func getPoster()
}

class SEShowCellPresenter {
    
    private let interactor: SEPosterUseCase
    private let showModel: SEDisplayModel?
    private weak var output: SEShowCollectionViewCellOutput?
    
    init(from interactor: SEPosterUseCase, showModel: SEDisplayModel, output: SEShowCollectionViewCellOutput) {
        self.interactor = interactor
        self.showModel = showModel
        self.output = output
    }
}

extension SEShowCellPresenter: SEShowCellPresenterInput {
    func getPoster() {
        if let imagePath = self.showModel?.poster, imagePath != SEKeys.MessageKeys.emptyText {
            self.interactor.getPoster(fromPath: self.showModel?.poster ?? SEKeys.MessageKeys.emptyText) { [unowned self] imgData in
                self.output?.didRetrievePoster(imageData: imgData, name: self.showModel?.name ?? SEKeys.MessageKeys.emptyText)
            } failure: { [unowned self] _ in
                self.output?.didRetrievePoster(imageData: nil, name: self.showModel?.name ?? SEKeys.MessageKeys.emptyText)
            }
        } else {
            self.output?.didRetrievePoster(imageData: nil, name: self.showModel?.name ?? SEKeys.MessageKeys.emptyText)
        }
    }
}
