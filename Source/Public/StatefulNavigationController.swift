//
//  StatefulNavigationController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/15/18.
//

import UIKit

open class StatefulNavigationController<State: Equatable>: StatefulViewController<State> {

    /// The `UINavigationController` displayed by this view
    /// controller.
    public let childNavigationController = UINavigationController()
    /// If a prior equivalent child view controller exists on the
    /// navigation stack, the navigation stack will pop to that
    /// child if this property is `true`. If false, a new child
    /// controller is always created.
    /// The concept of a prior "equivalent" view controller is
    /// defined in ``.
    /// Default is `true`.
    open var seeksToExistingChild = true
    override public var currentChild: UIViewController? {
        return childNavigationController.visibleViewController
    }

    /// The equality function that defines whether, instead of pushing
    /// a brand new view controller, the navigation controller can
    /// go back to a prior view controller.
    public typealias PopTransitionViewControllerEquality =
        (UIViewController, UIViewController) -> Bool
    /// An enum describing whether a stateful navigation controller
    /// has the option to pop to a previous view controller if it
    /// finds an equal one in the stack, or it should always push to
    /// a newly-created view controller.
    ///
    /// - yes: The stateful navigation controller can search the stack
    /// for an equivalent child based on the associated equality test.
    /// - no: The stateful navigation controller should always push
    /// to the newly created view controller.
    public enum PopTransitionRule {
        case yes(PopTransitionViewControllerEquality)
        case no
    }
    /// Whether this stateful navigation controller
    /// has the option to pop to a previous view controller if it
    /// finds an equal one in the stack, or it should always push to
    /// a newly-created view controller. The search for an equal view
    /// controller in the navigation stack defines equality based
    /// on the associated closure passed in the `yes` case. Default is `.no`.
    public var canPopToPreviousControllerOnTransition = PopTransitionRule.no

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
        let newCompletion: (() -> Void)? = {
            completion?()
            self.state = newState
        }
        let newChild = childViewController(for: newState)
        switch canPopToPreviousControllerOnTransition {
        case .yes(let equality):
            if let existingChild = existingChild(for: newChild, equality: equality) {
                pop(to: existingChild, animated: animated, completion: newCompletion)
            } else {
                push(newChild, animated: animated, completion: newCompletion)
            }
        case .no:
            push(newChild, animated: animated, completion: newCompletion)
        }
    }

    func pop(to existingChild: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        childNavigationController.popToViewController(existingChild, animated: animated)
        CATransaction.commit()
    }

    func push(_ newChild: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        childNavigationController.pushViewController(newChild, animated: animated)
        CATransaction.commit()
    }

    func existingChild(for possibleChild: UIViewController, equality: PopTransitionViewControllerEquality) -> UIViewController? {
        return childNavigationController.viewControllers.first(where: { child in
            return equality(child, possibleChild)
        })
    }

}
