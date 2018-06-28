//
//  StateTransitionAnimation.swift
//  Reinstate
//
//  Created by Connor Neville on 3/2/18.
//

import UIKit

/// A tuple representing the duration and animation options for a state transition.
public typealias StateTransitionAnimationOptions = (TimeInterval, UIViewAnimationOptions)

/// An enum representing the various visual behaviors of a state transition.
///
/// - appearOverPrevious: the new controller appears over the old one,
/// with optional animations as the new one appears.
/// - appearUnderPrevious: the new controller appears under the old one,
/// with optional animations as the old one disappears.
/// - appearAndSimultaneouslyRemove: the new controller appears while
/// the old one disappears, with optional animations for both.
/// - removePreviousThenAppear: the old controller first disappears
/// with optional animations, then the new controller appears with optional
/// animations.
public enum StateTransitionAnimation {

    case appearOverPrevious(onAppear: StateTransitionAnimationOptions?)
    case appearUnderPrevious(onRemove: StateTransitionAnimationOptions?)
    case appearAndSimultaneouslyRemove(onAppear: StateTransitionAnimationOptions?, onRemove: StateTransitionAnimationOptions?)
    case removePreviousThenAppear(onRemove: StateTransitionAnimationOptions?, onAppear: StateTransitionAnimationOptions?)

}

