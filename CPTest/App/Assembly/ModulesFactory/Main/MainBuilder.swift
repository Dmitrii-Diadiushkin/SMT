//
//  MainBuilder.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import Foundation

extension ModulesFactory: MainBuilderProtocol {
    func buildMainScreen() -> MainViewController {
        return MainViewController()
    }
}
