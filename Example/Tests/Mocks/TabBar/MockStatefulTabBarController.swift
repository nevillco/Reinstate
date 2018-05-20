//
//  MockStatefulTabBarController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 5/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate

class MockStatefulTabBarController: StatefulTabBarController<MockState> {

    let childForStateA = UIViewController()
    let childForStateB = UIViewController()

    var hasConfiguredInitialState = false

    required init() {
        let currentItem = Item(.stateA, childForStateA)
        let items: [Item] = [
            currentItem
        ]
        super.init(allItems: items, currentItem: currentItem)
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
