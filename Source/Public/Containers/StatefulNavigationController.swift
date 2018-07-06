//
//  StatefulNavigationController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/15/18.
//

import UIKit

/// A wrapper around `UINavigationController` that manages itself
/// according to a state variable.
open class StatefulNavigationController<State: Equatable>: UIViewController {

    let internalChild = ChildNavigationController()

    /// The current state of the view controller.
    public private(set) var state: State
    /// The `UINavigationController` displayed by this view controller.
    public var childNavigationController: UINavigationController {
        return internalChild.internalController
    }
    /// The current child view controller being displayed in
    /// this navigation stack.
    public var currentChild: UIViewController? {
        return childNavigationController.visibleViewController
    }

    /// The states that exist in this navigation stack. Cannot be directly set.
    public private(set) var statesInNavigationStack: [State] = []

    /// Initializes a new `StatefulNavigationController` with the specified
    /// initial state, which will determine its first child view controller.
    ///
    /// - Parameter initialState: the initial state of the controller.
    public init(initialState: State) {
        state = initialState
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        internalChild.delegate = self
        super.viewDidLoad()
        configureInitialState()
    }

    /// Configures the initial state of the view controller. Should not be called
    /// directly and usually should not be overridden. If you do override this
    /// function, include a call to the superclass implementation.
    open func configureInitialState() {
        let initialChild = childViewController(for: state)
        childNavigationController.setViewControllers([initialChild], animated: false)
        addChild(childNavigationController)
        statesInNavigationStack = [state]
    }

    /// The child view controller that should be displayed for the given state.
    ///
    /// - Parameter state: the state for which the `StatefulNavigationController`
    /// is requesting a child view controller.
    /// - Returns: a child view controller that reflects the `state`.
    open func childViewController(for state: State) -> UIViewController {
        fatalError("Subclasses of StatefulNavigationController must implement childViewController(for:)")
    }

    /// Determines whether or not the given `oldState` is an acceptable
    /// candidate to pop backwards to in the navigation stack, given a `newState`.
    /// The default value is whether oldState and newState are equal as
    /// defined by Equatable.
    ///
    /// - Parameters:
    ///   - oldState: a previous state that exists in the navigation stack.
    ///   - newState: a state being transitioned to.
    /// - Returns: whether this controller should pop back to `oldState`’s
    /// position in the stack rather than pushing to a new controller.
    open func shouldPopToViewController(from oldState: State, to newState: State) -> Bool {
        return oldState == newState
    }

    /// Transitions this `StatefulNavigationController` to a new state.
    /// This will either be a push transition or a pop transition, depending on if
    /// pop transitions are allowed and if there is an eligible existing
    /// state on the stack to pop to.
    ///
    /// Note that, if the view controller generated for `newState` already exists
    /// in the stack, this will always be a pop transition, even if
    /// `canPopToExistingState` is false.
    ///
    /// - Parameters:
    ///   - newState: the state to transition to.
    ///   - animated: whether to animate the transition.
    ///   - canPopToExistingState: whether to allow popping transitions. Defaults to `true`.
    ///   - completion: a completion block.
    open func transition(to newState: State, animated: Bool, canPopToExistingState: Bool = true, completion: (() -> Void)? = nil) {
        let completion = insert({
            self.state = newState
        }, before: completion)
        let newChild = childViewController(for: newState)

        let isInitiallyConfigured = !childNavigationController.viewControllers.isEmpty
        let containsNewChild = childNavigationController.viewControllers.contains(newChild)
        let popIndex = canPopToExistingState ? self.popIndex(for: newState) : nil

        switch (isInitiallyConfigured, containsNewChild, popIndex) {
        case (false, _, _):
            // Controller has not been configured yet. Treat this as the initial state instead.
            Reinstate.log("Encountered a transition in StatefulNavigationController while the navigation stack was empty. Configuring as the initial state.")
            state = newState
            configureInitialState()
            completion()
        case (true, true, _):
            // The new view controller already exists in the stack. Since it’s not
            // valid to have the same controller in a stack twice, pop transition
            // is necessary.
            Reinstate.log("StatefulNavigationController attempted to transition to a view controller that was already in its stack. Popping back to the previous controller.")
            pop(to: newChild, animated: animated, completion: completion)
        case let (true, false, popIndex?):
            // We have a state in the navigation stack to pop to.
            let existingState = statesInNavigationStack[popIndex]
            switch existingState == newState {
            case true:
                // The state in the navigation stack is equal to the new state.
                // Pop to the existing view controller without changing.
                let existingChild = childNavigationController.viewControllers[popIndex]
                pop(to: existingChild, animated: animated, completion: completion)
            case false:
                // The state in the navigation stack is *not* equal to the new state.
                // Replace the existing view controller with the new one, then pop.
                childNavigationController.viewControllers[popIndex] = newChild
                pop(to: newChild, animated: animated, completion: completion)
            }
        case (true, false, nil):
            // We do not have a state in the navigation stack to pop to,
            // or popping was explicitly disabled. Just push to the new controller.
            push(newChild, for: newState, animated: animated, completion: completion)
        }
    }

}

extension StatefulNavigationController {

    func pop(to existingChild: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let completion = insert({
            let newStackLength = self.childNavigationController.viewControllers.count
            let prefixed = self.statesInNavigationStack.prefix(newStackLength)
            self.statesInNavigationStack = Array(prefixed)
        }, before: completion)
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            childNavigationController.popToViewController(existingChild, animated: animated)
            CATransaction.commit()
        }
        else {
            childNavigationController.popToViewController(existingChild, animated: false)
            completion()
        }
    }

    func push(_ newChild: UIViewController, for newState: State, animated: Bool, completion: (() -> Void)?) {
        let completion = insert({
            self.statesInNavigationStack.append(newState)
        }, before: completion)
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            childNavigationController.pushViewController(newChild, animated: animated)
            CATransaction.commit()
        }
        else {
            childNavigationController.pushViewController(newChild, animated: false)
            completion()
        }
    }

    func popIndex(for newState: State) -> Int? {
        return statesInNavigationStack.enumerated()
            .filter({ shouldPopToViewController(from: $0.element, to: newState) })
            .last
            .map({ $0.offset })
    }

}

extension StatefulNavigationController: ChildNavigationControllerDelegate {

    func childNavigationController(_ vc: ChildNavigationController, didUpdateStackCountTo stackCount: Int) {
        let prefixed = self.statesInNavigationStack.prefix(stackCount)
        self.statesInNavigationStack = Array(prefixed)
    }

}
