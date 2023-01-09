//
//  Router.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import UIKit

final class Router: NSObject {
    fileprivate weak var rootController: UINavigationController?

    init(rootController: UINavigationController) {
        self.rootController = rootController
    }
}

extension Router: Routable {
    func setRootModule(_ module: UIViewController, hideBar: Bool) {
        rootController?.setViewControllers([module], animated: false)
        rootController?.isNavigationBarHidden = hideBar
        rootController?.modalPresentationStyle = .fullScreen
    }
}
