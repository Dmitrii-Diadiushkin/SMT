//
//  MainBuilderProtocol.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import UIKit

protocol MainBuilderProtocol {
    func buildMainScreen(with viewModel: MainScreenViewModelProtocol) -> MainViewController
    func buildMainViewModel() -> MainScreenViewModelProtocol
    func buildDetailsScreenViewModel(for hotelID: Int) -> DetailsScreenViewModelProtocol
    func buildDetailsScreen(with viewModel: DetailsScreenViewModelProtocol) -> DetailsViewController
}
