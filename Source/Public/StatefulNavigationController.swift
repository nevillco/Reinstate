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

    open func shouldAnimateTransition(from oldState: State, to newState: State) -> Bool {
        return isViewLoaded
    }

    open override func transition(to newState: State, completion: (() -> Void)?) {
        if ignoresSameStateChanges, newState == state {
            print("Encountered a same-state transition to \(newState) - ignoring.")
            return
        }
        let newChild = childViewController(for: newState)
        let animated = shouldAnimateTransition(from: state, to: newState)
        if seeksToExistingChild, let existingChild = existingChild(
            ofType: type(of: newChild)) {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            childNavigationController.popToViewController(existingChild, animated: animated)
            CATransaction.commit()
        }
        else {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            childNavigationController.pushViewController(newChild, animated: animated)
            CATransaction.commit()
        }
    }

    func existingChild(ofType controllerType: UIViewController.Type) -> UIViewController? {
        return nil
    }

}
