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

    var statesInNavigationStack: [State] = []

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

    /// Whether or not, when transitioning to a new state, the given `oldState`
    /// is an acceptable candidate to pop backwards to in the navigation stack.
    /// The default value is whether oldState and newState are equal.
    ///
    /// - Parameters:
    ///   - oldState: a previous state that exists in the navigation stack.
    ///   - newState: a state being transitioned to.
    /// - Returns: whether this controller should pop back to `oldState`’s
    /// position in the stack rather than pushing to a new controller.
    open func canPop(from oldState: State, to newState: State) -> Bool {
        return oldState == newState
    }

    /// Transitions this `StatefulNavigationController` to a new state. This
    /// transition will either be a push to a new view controller, or a pop backwards
    /// through the navigation stack, depending on a number of conditions:
    ///
    /// * If the new child view controller that corresponds to `newState` already
    /// exists in the stack, pop to it.
    /// * If `canPop` is false, push to the new child view controller.
    /// * If `canPop` is true, search the existing states on the navigation stack for
    /// a candidate according to the `NavigationEquatable` definition. If one is found,
    /// and it is equal to `newState`, pop to it. If it is not equal to `newState`, replace
    /// the existing view controller with the new one first, then pop to it.
    ///
    /// - Parameters:
    ///   - newState: the state to transition to.
    ///   - canPop: whether to allow popping transitions. Defaults to `true`.
    ///   - animated: whether to animate the transition.
    ///   - completion: a completion block.
    open func transition(to newState: State, animated: Bool, canPop: Bool = true, completion: (() -> Void)? = nil) {
        let augmentedCompletion: (() -> Void)? = {
            self.state = newState
            completion?()
        }
        let newChild = childViewController(for: newState)

        let isInitiallyConfigured = !childNavigationController.viewControllers.isEmpty
        let containsNewChild = childNavigationController.viewControllers.contains(newChild)
        let popIndex = canPop ? self.popIndex(for: newState) : nil

        switch (isInitiallyConfigured, containsNewChild, popIndex) {
        case (false, _, _):
            print("Encountered a transition in StatefulNavigationController while the navigation stack was empty. Configuring as the initial state.")
            state = newState
            configureInitialState()
            completion?()
        case (true, true, _):
            print("StatefulNavigationController attempted to transition to a view controller that was already in its stack. Popping back to the previous controller.")
            pop(to: newChild, animated: animated, completion: augmentedCompletion)
        case let (true, false, popIndex?):
            let existingState = statesInNavigationStack[popIndex]
            switch existingState == newState {
            case true:
                let existingChild = childNavigationController.viewControllers[popIndex]
                pop(to: existingChild, animated: animated, completion: augmentedCompletion)
            case false:
                childNavigationController.viewControllers[popIndex] = newChild
                pop(to: newChild, animated: animated, completion: augmentedCompletion)
            }
        case (true, false, nil):
            push(newChild, for: newState, animated: animated, completion: augmentedCompletion)
        }
    }

}

extension StatefulNavigationController {

    func pop(to existingChild: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let augmentedCompletion: (() -> Void)? = {
            let newStackLength = self.childNavigationController.viewControllers.count
            let prefixed = self.statesInNavigationStack.prefix(newStackLength)
            self.statesInNavigationStack = Array(prefixed)
            completion?()
        }
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(augmentedCompletion)
            childNavigationController.popToViewController(existingChild, animated: animated)
            CATransaction.commit()
        }
        else {
            childNavigationController.popToViewController(existingChild, animated: false)
            augmentedCompletion?()
        }
    }

    func push(_ newChild: UIViewController, for newState: State, animated: Bool, completion: (() -> Void)?) {
        let augmentedCompletion: (() -> Void)? = {
            self.statesInNavigationStack.append(newState)
            completion?()
        }
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(augmentedCompletion)
            childNavigationController.pushViewController(newChild, animated: animated)
            CATransaction.commit()
        }
        else {
            childNavigationController.pushViewController(newChild, animated: false)
            augmentedCompletion?()
        }
    }

    func popIndex(for newState: State) -> Int? {
        return statesInNavigationStack.enumerated()
            .filter({ canPop(from: $0.element, to: newState) })
            .last
            .map { $0.offset }
    }

}

extension StatefulNavigationController: ChildNavigationControllerDelegate {

    func childNavigationController(_ vc: ChildNavigationController, didUpdateStackCountTo stackCount: Int) {
        let prefixed = self.statesInNavigationStack.prefix(stackCount)
        self.statesInNavigationStack = Array(prefixed)
    }


}
