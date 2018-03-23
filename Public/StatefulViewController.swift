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
    var currentStateManagedChildren: [UIView: UIViewController] { get set }

    var stateManagedViews: [UIView] { get }
    func transitionBehavior(from oldState: State, to newState: State, in view: UIView) -> StateTransitionBehavior

    func childViewController(for state: State, in view: UIView) -> UIViewController

}

// MARK: Default Implementations
public extension StatefulViewController {

    var stateManagedViews: [UIView] {
        return [view]
    }

    func transitionBehavior(from oldState: State, to newState: State, in view: UIView) -> StateTransitionBehavior {
        return StateTransitionBehavior(
            order: .addNewChildFirst,
            additionAnimations: nil,
            removalAnimations: nil)
    }

}

// MARK: Convenience Functions
public extension StatefulViewController {

    func configureInitialState() {
        for stateManagedView in stateManagedViews {
            let initialChild = childViewController(for: state, in: stateManagedView)
            currentStateManagedChildren[stateManagedView] = initialChild
            addChild(initialChild, constrainedTo: stateManagedView)
        }
    }

    func transition(to newState: State, completion: (() -> Void)? = nil) {
        guard newState != state else {
            assertionFailure("Encountered a transition to the current state: \(newState). No operation")
            return
        }
        let group = DispatchGroup()
        for stateManagedView in stateManagedViews {
            guard let currentChild = currentStateManagedChildren[stateManagedView] else {
                preconditionFailure("Missing an initial child before transitioning states in view: \(stateManagedView)")
            }
            let newChild = childViewController(for: newState, in: stateManagedView)
            let transitionBehavior = self.transitionBehavior(from: state, to: newState, in: stateManagedView)
            currentStateManagedChildren[stateManagedView] = newChild
            group.enter()
            replaceChild(currentChild, with: newChild, constrainedTo: stateManagedView, transitionBehavior: transitionBehavior, completion: {
                group.leave()
            })
        }
        group.notify(queue: .main) {
            self.state = newState
            completion?()
        }
    }

}

