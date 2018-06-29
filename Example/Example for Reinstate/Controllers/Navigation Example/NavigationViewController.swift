//
//  NavigationViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate
import UIKit

enum NavigationViewState: NavigationEquatable {

    case info(username: String?)
    case usernameEntry

    static func canPop(to oldState: NavigationViewState, for newState: NavigationViewState) -> Bool {
        switch (oldState, newState) {
        case (.info, .info): return true
        case (.usernameEntry, .usernameEntry): return true
        default: return false
        }
    }

}

class NavigationViewController: StatefulNavigationController<NavigationViewState> {

    init() {
        super.init(initialState: .info(username: nil))
        title = "Navigation"
    }

    override func childViewController(for state: NavigationViewState) -> UIViewController {
        switch state {
        case .info(let username):
            let vc = NavigationInfoViewController(username: username)
            vc.delegate = self
            return vc
        case .usernameEntry:
            let vc = NavigationSetUsernameViewController()
            vc.delegate = self
            return vc
        }
    }

}

extension NavigationViewController: NavigationInfoViewControllerDelegate {

    func navigationInfoViewControllerDidTapSetUsername(_ vc: NavigationInfoViewController) {
        transition(to: .usernameEntry, animated: true)
    }

}

extension NavigationViewController: NavigationSetUsernameViewControllerDelegate {

    func navigationSetUsernameViewController(_ vc: NavigationSetUsernameViewController, didEnterUsername username: String) {
        transition(to: .info(username: username), animated: true)
    }

}
