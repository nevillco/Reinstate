//
//  MockStatefulViewController.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 3/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reinstate

class MockStatefulViewController: UIViewController, StatefulViewController {

    enum State {
        case stateA
        case stateB
    }
    var state = State.stateA
    var currentChild: UIViewController?

    let childForStateA = UIViewController()
    let childForStateB = UIViewController()

    let animatedTransitions: Bool

    init(animatedTransitions: Bool) {
        self.animatedTransitions = animatedTransitions
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func childViewController(for state: State) -> UIViewController {
        switch state {
        case .stateA: return childForStateA
        case .stateB: return childForStateB
        }
    }

    func transitionBehavior(from oldState: MockStatefulViewController.State, to newState: MockStatefulViewController.State) -> StateTransitionBehavior {
        switch animatedTransitions {
        case true:
            return StateTransitionBehavior(
                order: .addNewChildFirst,
                additionAnimations: (duration: 0.3, options: .transitionCrossDissolve),
                removalAnimations: (duration: 0.3, options: .transitionCrossDissolve))
        case false:
            return StateTransitionBehavior(
                order: .addNewChildFirst,
                additionAnimations: nil,
                removalAnimations: nil)
            
        }
    }

}
