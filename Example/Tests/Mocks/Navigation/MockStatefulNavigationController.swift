//
//  MockStatefulNavigationController.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate

class MockStatefulNavigationController: StatefulNavigationController<MockNavigationState> {

    let childForStateA = UIViewController()
    let childForStateB = UIViewController()

    var hasConfiguredInitialState = false

    required init() {
        super.init(initialState: .stateA(reusableVC: true))
    }

    override func configureInitialState() {
        super.configureInitialState()
        hasConfiguredInitialState = true
    }

    override func canPop(from oldState: MockNavigationState, to newState: MockNavigationState) -> Bool {
        switch (oldState, newState) {
        case (.stateA, .stateA): return true
        case (.stateB, .stateB): return true
        default: return false
        }
    }

    override func childViewController(for state: MockNavigationState) -> UIViewController {
        switch state {
        case .stateA(let reusableVC):
            return reusableVC ? childForStateA : UIViewController()
        case .stateB(let reusableVC):
            return reusableVC ? childForStateB : UIViewController()
        }
    }

}
