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

}

