//
//  RootViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 03/01/2018.
//  Copyright (c) 2018 nevillco. All rights reserved.
//

import Reinstate

enum RootViewState {

    case delegation
    case containment
    case navigation

}

class RootViewController: StatefulTabBarController<RootViewState> {

    init() {
        let delegationVC = DelegationViewController()
        let containmentVC = ContainmentViewController()
        let navigationVC = NavigationViewController()
        let delegationItem: Item = (.delegation, delegationVC)
        let containmentItem: Item = (.containment, containmentVC)
        let navigationItem: Item = (.navigation, navigationVC)
        let allItems = [delegationItem, containmentItem, navigationItem]
        super.init(allItems: allItems, initialItem: delegationItem)
        delegationVC.delegate = self
    }

}

extension RootViewController: DelegationViewControllerDelegate {

    func delegationViewControllerDidSwitchTabs(_ vc: DelegationViewController) {
        transition(to: .containment)
    }

}
