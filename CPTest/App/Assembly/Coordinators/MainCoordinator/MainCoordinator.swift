//
//  MainCoordinator.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import UIKit

protocol MainCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
}

final class MainCoordinator: BaseCoordinator, MainCoordinatorOutput {
    
    var finishFlow: CompletionBlock?

    fileprivate let router: Routable
    
    fileprivate let factory: MainBuilderProtocol
    
    private let coordinatorFactory: CoordinatorFactory

    init(router: Routable, factory: MainBuilderProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = CoordinatorFactory()
        super.init()
        start()
    }
}

extension MainCoordinator: Coordinator {
    
    func start() {
        performFlow()
    }
}

private extension MainCoordinator {
    func performFlow() {
        let view = factory.buildMainScreen()
        router.setRootModule(view, hideBar: true)
    }
}
