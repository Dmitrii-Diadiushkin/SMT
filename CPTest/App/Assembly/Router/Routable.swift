//
//  Routable.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import UIKit

typealias CompletionBlock = (() -> Void)

protocol Routable: AnyObject {
    func setRootModule(_ module: UIViewController, hideBar: Bool)
    func push(_ module: UIViewController, animated: Bool)
}
