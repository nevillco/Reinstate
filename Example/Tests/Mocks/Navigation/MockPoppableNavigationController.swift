//
//  MockPoppableNavigationController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate

class MockPoppableNavigationController: StatefulNavigationController<MockNavigationState> {

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

    override func childViewController(for state: MockNavigationState) -> UIViewController {
        switch state {
        case .stateA(let reusableVC):
            return reusableVC ? childForStateA : UIViewController()
        case .stateB(let reusableVC):
            return reusableVC ? childForStateB : UIViewController()
        }
    }

}
