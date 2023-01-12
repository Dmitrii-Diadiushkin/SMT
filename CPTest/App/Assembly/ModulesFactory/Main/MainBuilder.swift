//
//  MainBuilder.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import Foundation

extension ModulesFactory: MainBuilderProtocol {
    func buildMainScreen(with viewModel: MainScreenViewModelProtocol) -> MainViewController {
        return MainViewController(viewModel: viewModel)
    }
    
    func buildMainViewModel() -> MainScreenViewModelProtocol {
        return MainScreenViewModel()
    }
    
    func buildDetailsScreenViewModel(for hotelID: Int) -> DetailsScreenViewModelProtocol {
        return DetailsScreenViewModel(hotelID: hotelID)
    }
    
    func buildDetailsScreen(with viewModel: DetailsScreenViewModelProtocol) -> DetailsViewController {
        return DetailsViewController(viewModel: viewModel)
    }
}
