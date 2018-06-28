//
//  NavigationEquatable.swift
//  Reinstate
//
//  Created by Connor Neville on 6/20/18.
//

import Foundation

/// A protocol defining a state variable for a stateful navigation stack.
public protocol NavigationEquatable: Equatable {

    /// A function indicating whether a new state is similar enough to
    /// an existing one that the navigation stack should pop backwards.
    ///
    /// In practice, this function is usually a broader version of `==`.
    /// If two states are fully equal, it is expected that popping to the
    /// existing one would be allowed. There may also be a pair of states
    /// where popping is allowed, though the states are not equal.
    ///
    /// - Parameters:
    ///   - oldState: a previous state found in a navigation stack.
    ///   - newState: a newly proposed state.
    /// - Returns: whether a navigation stack should pop to `oldState`
    /// based on the value of `newState`.
    static func canPop(to oldState: Self, for newState: Self) -> Bool

}

public extension NavigationEquatable {

    static func canPop(to oldState: Self, for newState: Self) -> Bool {
        return oldState == newState
    }

}
