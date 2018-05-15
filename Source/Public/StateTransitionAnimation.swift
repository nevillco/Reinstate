//
//  StateTransitionAnimation.swift
//  Reinstate
//
//  Created by Connor Neville on 3/2/18.
//

import UIKit

public typealias StateTransitionAnimationOptions = (TimeInterval, UIViewAnimationOptions)
public enum StateTransitionAnimation {

    case appearOverPrevious(onAppear: StateTransitionAnimationOptions?)
    case appearUnderPrevious(onRemove: StateTransitionAnimationOptions?)
    case appearAndSimultaneouslyRemove(onAppear: StateTransitionAnimationOptions?, onRemove: StateTransitionAnimationOptions?)
    case removePreviousThenAppear(onRemove: StateTransitionAnimationOptions?, onAppear: StateTransitionAnimationOptions?)

    var additionOptions: StateTransitionAnimationOptions? {
        switch self {
        case .appearOverPrevious(let onAppear): return onAppear
        case .appearUnderPrevious: return nil
        case .appearAndSimultaneouslyRemove(let onAppear, _): return onAppear
        case .removePreviousThenAppear(_, let onAppear): return onAppear
        }
    }

    var removalOptions: StateTransitionAnimationOptions? {
        switch self {
        case .appearOverPrevious: return nil
        case .appearUnderPrevious(let onRemove): return onRemove
        case .appearAndSimultaneouslyRemove(_, let onRemove): return onRemove
        case .removePreviousThenAppear(let onRemove, _): return onRemove
        }
    }

}

