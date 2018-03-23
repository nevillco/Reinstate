//
//  MockCustomStatefulViewController.swift
//  StatefulViewController_Tests
//
//  Created by Connor Neville on 3/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reinstate

class MockCustomStatefulViewController: UIViewController, StatefulViewController {

    enum State {
        case defaultState
        case secondStateNotAnimated
        case secondStateAnimated
    }
    var state = State.defaultState

    var currentStateManagedChildren: [UIView: UIViewController] = [:]

    let defaultChildForSubviewA: UIViewController = {
        let vc = UIViewController()
        vc.view.accessibilityIdentifier = "defaultChildForSubviewA.view"
        return vc
    }()
    let secondChildForSubviewA: UIViewController = {
        let vc = UIViewController()
        vc.view.accessibilityIdentifier = "secondChildForSubviewA.view"
        return vc
    }()
    let defaultChildForSubviewB: UIViewController = {
        let vc = UIViewController()
        vc.view.accessibilityIdentifier = "defaultChildForSubviewB.view"
        return vc
    }()
    let secondChildForSubviewB: UIViewController = {
        let vc = UIViewController()
        vc.view.accessibilityIdentifier = "secondChildForSubviewA.view"
        return vc
    }()

    let subviewA: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "subviewA"
        return view
    }()
    let subviewB: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "subviewB"
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "mainView"
        view.addSubview(subviewA)
        view.addSubview(subviewB)

        subviewA.translatesAutoresizingMaskIntoConstraints = false
        subviewB.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subviewA.topAnchor.constraint(equalTo: view.topAnchor),
            subviewA.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subviewA.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subviewA.bottomAnchor.constraint(equalTo: view.centerYAnchor),

            subviewB.topAnchor.constraint(equalTo: view.centerYAnchor),
            subviewB.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subviewB.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subviewB.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    func childViewController(for state: State, in view: UIView) -> UIViewController {
        let vc: UIViewController
        switch view {
        case subviewA:
            switch state {
            case .defaultState:
                vc = defaultChildForSubviewA
            case .secondStateNotAnimated, .secondStateAnimated:
                vc = secondChildForSubviewA
            }
        case subviewB:
            switch state {
            case .defaultState:
                vc = defaultChildForSubviewB
            case .secondStateNotAnimated, .secondStateAnimated:
                vc = secondChildForSubviewB
            }
        default:
            fatalError()
        }
        return vc
    }

    var stateManagedViews: [UIView] {
        return [subviewA, subviewB]
    }

}
