//
//  StateTransitionBehavior.swift
//  Nimble
//
//  Created by Connor Neville on 3/2/18.
//

import UIKit

public typealias StateTransitionAnimation = (duration: TimeInterval, options: UIViewAnimationOptions)

public struct StateTransitionBehavior {

    public enum Order {
        case removeExistingChildFirst
        case addNewChildFirst
        case simultaneous
    }
    let order: Order
    let additionAnimations: StateTransitionAnimation?
    let removalAnimations: StateTransitionAnimation?

    public init(order: Order, additionAnimations: StateTransitionAnimation? = nil, removalAnimations: StateTransitionAnimation? = nil) {
        self.order = order
        self.additionAnimations = additionAnimations
        self.removalAnimations = removalAnimations
    }

}

