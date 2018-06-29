//
//  StatefulNavigationController+Delegation.swift
//  Reinstate
//
//  Created by Connor Neville on 5/31/18.
//

import Foundation

protocol ChildNavigationControllerDelegate: class {

    func childNavigationController(_ vc: ChildNavigationController, didUpdateStackCountTo stackCount: Int)

}

final class ChildNavigationController: NSObject {

    let internalController = UINavigationController()
    weak var delegate: ChildNavigationControllerDelegate?

    override init() {
        super.init()
        internalController.delegate = self
    }

}

extension ChildNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let stackCount = navigationController.viewControllers.count
        delegate?.childNavigationController(self, didUpdateStackCountTo: stackCount)
    }

}
