//
//  StatefulViewController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/14/18.
//

import UIKit

/// A `UIViewController` that manages a child view controller
/// according to a state variable.
open class StatefulViewController<State: Equatable>: UIViewController {

    /// The current state of the view controller.
    public private(set) var state: State
    /// The current child view controller being managed by the
    /// view controller’s state.
    public private(set) var currentChild: UIViewController?

    /// Initializes a new `StatefulViewController` with the specified
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
        super.viewDidLoad()
        configureInitialState()
    }

    /// Configures the initial state of the view controller. Should not be called
    /// directly and usually should not be overridden. If you do override this
    /// function, include a call to the superclass implementation.
    open func configureInitialState() {
        guard currentChild == nil else {
            Reinstate.log("Tried to configure the initial state of StatefulViewController multiple times - ignoring.")
            return
        }
        let initialChild = childViewController(for: state)
        currentChild = initialChild
        addChild(initialChild)
    }

    /// The child view controller that should be displayed for the given state.
    ///
    /// - Parameter state: the state for which the `StatefulViewController`
    /// is requesting a child view controller.
    /// - Returns: a child view controller that reflects the `state`.
    open func childViewController(for state: State) -> UIViewController {
        fatalError("Subclasses of StatefulViewController must implement childViewController(for:)")
    }

    /// Supplies preferred animation options for a state transition.
    ///
    /// - Parameters:
    ///   - oldState: the state being transitioned away.
    ///   - newState: the state being transitioned in.
    /// - Returns: the preferred animation options for the given transition.
    open func transitionAnimation(from oldState: State, to newState: State) -> StateTransitionAnimation? {
        return .appearOverPrevious(onAppear: (0.2, [.curveEaseOut, .transitionCrossDissolve]))
    }

    /// Transitions this `StatefulViewController` to a new state. Should not be
    /// called until after an initial state has been configured. If `animated`, the
    /// animation options are selected from `func transitionAnimation(from:, to:)`.
    ///
    /// - Parameters:
    ///   - newState: the state to transition to.
    ///   - animated: whether to animate the transition.
    ///   - completion: a completion block.
	open func transition(to newState: State, animated: Bool, completion: (() -> Void)? = nil) {
        if newState == state {
            Reinstate.log("StatefulViewController ignored a same-state transition: \(state)")
            completion?()
            return
        }
        guard let currentChild = currentChild else {
            Reinstate.log("Encountered a transition in StatefulViewController before the initial state was configured. Treating it as the initial state.")
            state = newState
            configureInitialState()
            completion?()
            return
        }
        let newChild = childViewController(for: newState)
		let animation = animated ? transitionAnimation(from: state, to: newState) : nil
        replaceChild(currentChild, with: newChild, animation: animation) {
            self.state = newState
            self.currentChild = newChild
            completion?()
        }
    }

}
