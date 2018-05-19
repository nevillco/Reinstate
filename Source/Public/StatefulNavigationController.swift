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

    var statesInNavigationStack: [State] = []

    public override init(initialState: State) {
        super.init(initialState: initialState)
    }

    open override func configureInitialState() {
        let initialChild = childViewController(for: state)
        childNavigationController.setViewControllers([initialChild], animated: false)
        addChild(childNavigationController)
        statesInNavigationStack = [state]
    }

    open override func childViewController(for state: State) -> UIViewController {
        fatalError("Subclasses of StatefulNavigationController must implement childViewController(for:)")
    }

	@available(*, unavailable) open override func transitionAnimation(from oldState: State, to newState: State) -> StateTransitionAnimation? {
		print("transitionAnimation(from:, to:) called from a StatefulNavigationController subclass has no effect")
		return nil
	}

    open override func transition(to newState: State, animated: Bool, completion: (() -> Void)? = nil) {
        transition(to: newState, canPop: false, animated: true, completion: nil)
    }

    open func transition(to newState: State, canPop: Bool, animated: Bool, completion: (() -> Void)? = nil) {
        if childNavigationController.viewControllers.isEmpty {
            print("Encountered a transition in StatefulNavigationController while the navigation stack was empty. Configuring as the initial state.")
            state = newState
            configureInitialState()
            completion?()
            return
        }
        if ignoresSameStateChanges, newState == state {
            print("Encountered a same-state transition to \(newState) - ignoring.")
            return
        }
        let augmentedCompletion: (() -> Void)? = {
            completion?()
            self.state = newState
        }
        let newChild = childViewController(for: newState)
        switch (canPop, existingChild(for: newState)) {
        case let (true, .some(existingChild)):
            pop(to: existingChild, animated: animated, completion: augmentedCompletion)
        default:
            push(newChild, animated: animated, completion: augmentedCompletion)
        }
    }

    func pop(to existingChild: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let augmentedCompletion: (() -> Void)? = {
            completion?()
            let newStackLength = self.childNavigationController.viewControllers.count
            self.statesInNavigationStack = Array(self.statesInNavigationStack.prefix(newStackLength))
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(augmentedCompletion)
        childNavigationController.popToViewController(existingChild, animated: animated)
        CATransaction.commit()
    }

    func push(_ newChild: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let augmentedCompletion: (() -> Void)? = {
            completion?()
            self.statesInNavigationStack.append(self.state)
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(augmentedCompletion)
        childNavigationController.pushViewController(newChild, animated: animated)
        CATransaction.commit()
    }

    func existingChild(for newState: State) -> UIViewController? {
        return statesInNavigationStack.index(of: newState)
            .map { self.childNavigationController.viewControllers[$0] }
    }

}
