//
//  StatefulNavigationController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/15/18.
//

import UIKit

open class StatefulNavigationController<State: Equatable>: StatefulViewController<State> {

    internal let childNavigationController = UINavigationController()
    open var seeksToExistingChild = true

    open override func configureInitialState() {
        let initialChild = childViewController(for: state)
        currentChild = initialChild
        childNavigationController.setViewControllers([initialChild], animated: false)
        addChild(childNavigationController)
    }

    open override func childViewController(for state: State) -> UIViewController {
        fatalError("Subclasses of StatefulNavigationController must implement childViewController(for:)")
    }

    open override func transition(to newState: State, completion: (() -> Void)? = nil) {
        if ignoresSameStateChanges, newState == state {
            print("Encountered a same-state transition to \(newState) - ignoring.")
            return
        }
        let newChild = childViewController(for: newState)
        if seeksToExistingChild, let existingChild = existingChild(
            ofType: type(of: newChild)) {
            childNavigationController.popToViewController(existingChild, animated: true)
        }
        else {
            childNavigationController.pushViewController(newChild, animated: true)
        }
        // TODO: complete after the animation actually finishes
        completion?()
    }

    func existingChild(ofType controllerType: UIViewController.Type) -> UIViewController? {
        return nil
    }

}
