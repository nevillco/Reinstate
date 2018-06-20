//
//  MockPoppableState.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate

enum MockNavigationState: NavigationEquatable {

    case stateA(reusableVC: Bool)
    case stateB(reusableVC: Bool)

    static func canPop(to oldState: MockNavigationState, for newState: MockNavigationState) -> Bool {
        switch (oldState, newState) {
        case (.stateA, stateA): return true
        case (.stateB, .stateB): return true
        default: return false
        }
    }

}
