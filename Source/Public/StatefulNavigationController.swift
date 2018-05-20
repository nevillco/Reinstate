//
//  StatefulNavigationController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/15/18.
//

import UIKit

open class StatefulNavigationController<State: Equatable>: UIViewController {

    /// The current state of the view controller.
    public internal(set) var state: State
    /// The `UINavigationController` displayed by this view controller.
    public let childNavigationController = UINavigationController()
    /// The current child view controller being displayed in
    /// this navigation stack.
    public var currentChild: UIViewController? {
        return childNavigationController.visibleViewController
    }

    var statesInNavigationStack: [State] = []

    public init(initialState: State) {
        state = initialState
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialState()
    }

    open func configureInitialState() {
        let initialChild = childViewController(for: state)
        childNavigationController.setViewControllers([initialChild], animated: false)
        addChild(childNavigationController)
        statesInNavigationStack = [state]
    }

    open func childViewController(for state: State) -> UIViewController {
        fatalError("Subclasses of StatefulNavigationController must implement childViewController(for:)")
    }

    open func transition(to newState: State, canPop: Bool = false, animated: Bool, completion: (() -> Void)? = nil) {
        if childNavigationController.viewControllers.isEmpty {
            print("Encountered a transition in StatefulNavigationController while the navigation stack was empty. Configuring as the initial state.")
            state = newState
            configureInitialState()
            completion?()
            return
        }
        let augmentedCompletion: (() -> Void)? = {
            self.state = newState
            completion?()
        }
        let newChild = childViewController(for: newState)
        if childNavigationController.viewControllers.contains(newChild) {
            print("StatefulNavigationController attempted to transition to a view controller that was already in its stack. Popping back to the previous controller.")
            pop(to: newChild, animated: animated, completion: augmentedCompletion)
            return
        }
        switch (canPop, existingChild(for: newState)) {
        case let (true, .some(existingChild)):
            pop(to: existingChild, animated: animated, completion: augmentedCompletion)
        default:
            push(newChild, for: newState, animated: animated, completion: augmentedCompletion)
        }
    }

}

extension StatefulNavigationController {

    func pop(to existingChild: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let augmentedCompletion: (() -> Void)? = {
            let newStackLength = self.childNavigationController.viewControllers.count
            self.statesInNavigationStack = Array(self.statesInNavigationStack.prefix(newStackLength))
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

    func existingChild(for newState: State) -> UIViewController? {
        return statesInNavigationStack.enumerated()
            .filter { $0.element == newState }
            .last
            .map { $0.offset }
            .map { self.childNavigationController.viewControllers[$0] }
    }

}
