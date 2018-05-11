//
//  StatefulViewController.swift
//  Reinstate
//
//  Created by Connor Neville on 3/1/18.
//

// "Redundant layout constraint" warning is the product of a Swift bug.
// Only constraining to Self: UIViewController doesn't provide
// class protocol semantics, so `mutating` functions are necessary,
// and only conforming to `class` leaves non-UIViewControllers eligible
// for conformance. See: https://bugs.swift.org/browse/SR-6265
public protocol StatefulViewController: class where Self: UIViewController {

    associatedtype State: Equatable

    var state: State { get set }
    var currentChild: UIViewController? { get set }

    func transitionBehavior(from oldState: State, to newState: State) -> StateTransitionBehavior

    func childViewController(for state: State) -> UIViewController

}

// MARK: Default Implementations
public extension StatefulViewController {

    func transitionBehavior(from oldState: State, to newState: State) -> StateTransitionBehavior {
        return StateTransitionBehavior(
            order: .addNewChildFirst,
            additionAnimations: nil,
            removalAnimations: nil)
    }

}

// MARK: Convenience Functions
public extension StatefulViewController {

    func configureInitialState() {
        let initialChild = childViewController(for: state)
        currentChild = initialChild
        addChild(initialChild)
    }

    func transition(to newState: State, completion: (() -> Void)? = nil) {
        guard newState != state else {
            assertionFailure("Encountered a transition to the current state: \(newState). No operation.")
            return
        }
        guard let currentChild = currentChild else {
            preconditionFailure("Missing a currentChild while transitioning states.")
        }
        let newChild = childViewController(for: newState)
        let transitionBehavior = self.transitionBehavior(from: state, to: newState)
        replaceChild(currentChild, with: newChild, transitionBehavior: transitionBehavior) {
            self.state = newState
            self.currentChild = newChild
            completion?()
        }
    }

}

