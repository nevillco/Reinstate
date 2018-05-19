//
//  MockStateIdentifiedNavigationController.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate

class MockStateIdentifiedNavigationController: StatefulNavigationController<MockState> {

    required init() {
        super.init(initialState: .stateA)
    }

    override func childViewController(for state: MockState) -> UIViewController {
        switch state {
        case .stateA: return StateAViewController()
        case .stateB: return StateBViewController()
        }
    }

}
