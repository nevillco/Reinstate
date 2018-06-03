//
//  StatefulViewController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/14/18.
//

import UIKit

open class StatefulViewController<State: Equatable>: UIViewController {

    /// The current state of the view controller.
    public private(set) var state: State
    /// The current child view controller being managed by the
    /// view controller’s state.
    public private(set) var currentChild: UIViewController?

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
        currentChild = initialChild
        addChild(initialChild)
    }

    open func childViewController(for state: State) -> UIViewController {
        fatalError("Subclasses of StatefulViewController must implement childViewController(for:)")
    }

    open func transitionAnimation(from oldState: State, to newState: State) -> StateTransitionAnimation? {
        return .appearOverPrevious(onAppear: (0.2, [.curveEaseOut, .transitionCrossDissolve]))
    }

	open func transition(to newState: State, animated: Bool, completion: (() -> Void)? = nil) {
        if newState == state {
            print("Encountered a same-state transition to \(newState) - ignoring.")
            completion?()
            return
        }
        guard let currentChild = currentChild else {
            assertionFailure("Missing a currentChild while transitioning states.")
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
