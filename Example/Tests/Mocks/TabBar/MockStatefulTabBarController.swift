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
        let initialItem: Item = (.stateA, childForStateA)
        let items: [Item] = [
            initialItem,
            (.stateB, childForStateB)
        ]
        super.init(allItems: items, initialItem: initialItem)
    }

    override func configureInitialState() {
        super.configureInitialState()
        hasConfiguredInitialState = true
    }

}
