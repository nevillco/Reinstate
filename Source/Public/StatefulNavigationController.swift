//
//  StatefulNavigationController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/15/18.
//

import UIKit

open class StatefulNavigationController<State: Equatable>: StatefulViewController<State> {

    public let childNavigationController = UINavigationController()
    open var seeksToExistingChild = true
    override public var currentChild: UIViewController? {
        return childNavigationController.visibleViewController
    }

    open override func configureInitialState() {
        let initialChild = childViewController(for: state)
        childNavigationController.setViewControllers([initialChild], animated: false)
        addChild(childNavigationController)
    }

    open override func childViewController(for state: State) -> UIViewController {
        fatalError("Subclasses of StatefulNavigationController must implement childViewController(for:)")
    }

	@available(*, unavailable) open override func transitionAnimation(from oldState: State, to newState: State) -> StateTransitionAnimation? {
		print("transitionAnimation(from:, to:) called from a StatefulNavigationController subclass has no effect")
		return nil
	}

	open override func transition(to newState: State, animated: Bool, completion: (() -> Void)? = nil) {
        if ignoresSameStateChanges, newState == state {
            print("Encountered a same-state transition to \(newState) - ignoring.")
            return
        }
        let newChild = childViewController(for: newState)
        if seeksToExistingChild, let existingChild = existingChild(
            ofType: type(of: newChild)) {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.state = newState
                completion?()
            }
            childNavigationController.popToViewController(existingChild, animated: animated)
            CATransaction.commit()
        }
        else {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.state = newState
                completion?()
            }
            childNavigationController.pushViewController(newChild, animated: animated)
            CATransaction.commit()
        }
    }

    func existingChild(ofType controllerType: UIViewController.Type) -> UIViewController? {
        return childNavigationController.viewControllers.first(where: { child in
            return type(of: child) == controllerType
        })
    }

}
