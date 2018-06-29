//
//  NavigationViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reinstate
import UIKit

enum NavigationViewState: Equatable {

    case info(username: String?)
    case usernameEntry

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
