//
//  MockStatefulNavigationController.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate

class MockStatefulNavigationController: StatefulNavigationController<MockState> {

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

}
