//
//  MockDefaultStatefulViewController.swift
//  StatefulViewController_Example
//
//  Created by Connor Neville on 3/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reinstate

class MockDefaultStatefulViewController: UIViewController, StatefulViewController {

    enum State {
        case stateA
        case stateB
    }
    var state = State.stateA

    var currentStateManagedChildren: [UIView: UIViewController] = [:]

    let childForStateA = UIViewController()
    let childForStateB = UIViewController()

    func childViewController(for state: State, in view: UIView) -> UIViewController {
        switch state {
        case .stateA: return childForStateA
        case .stateB: return childForStateB
        }
    }

}
