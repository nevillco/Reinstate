//
//  MockState.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate

enum MockState: NavigationEquatable {

    case stateA
    case stateB

    static func canPop(to oldState: MockState, for newState: MockState) -> Bool {
        switch (oldState, newState) {
        case (.stateA, stateA): return true
        case (.stateB, .stateB): return true
        default: return false
        }
    }

}
