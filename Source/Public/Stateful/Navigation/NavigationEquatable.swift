//
//  NavigationEquatable.swift
//  Reinstate
//
//  Created by Connor Neville on 6/20/18.
//

import Foundation

public protocol NavigationEquatable: Equatable {

    static func canPop(to oldState: Self, for newState: Self) -> Bool

}

public extension NavigationEquatable {

    static func canPop(to oldState: Self, for newState: Self) -> Bool {
        return oldState == newState
    }

}
