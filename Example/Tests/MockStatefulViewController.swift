//
//  MockStatefulViewController.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 3/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reinstate

enum MockState {
    case stateA
    case stateB
}

class MockStatefulViewController: StatefulViewController<MockState> {

    let childForStateA = UIViewController()
    let childForStateB = UIViewController()

    var hasConfiguredInitialState = false
    var useSuperclassTransitionAnimation = false

	required init() {
		super.init(initialState: .stateA)
	}

    override func configureInitialState() {
        super.configureInitialState()
        hasConfiguredInitialState = true
    }

    override func childViewController(for state: MockState) -> UIViewController {
        switch state {
        case .stateA: return childForStateA
        case .stateB: return childForStateB
        }
    }

    override func transitionAnimation(from oldState: MockState, to newState: MockState) -> StateTransitionAnimation? {
        switch useSuperclassTransitionAnimation {
        case true:
            return super.transitionAnimation(from: oldState, to: newState)
        case false:
            let options: StateTransitionAnimationOptions = (0.3, .transitionCrossDissolve)
            return .appearOverPrevious(onAppear: options)
        }
    }

}
