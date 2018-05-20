//
//  StatefulTabBarController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/19/18.
//

import UIKit

open class StatefulTabBarController<State: Equatable>: StatefulViewController<State> {

    /// The `UINavigationController` displayed by this view
    /// controller.
    public let childTabBarController = UITabBarController()
    /// The current child view controller being displayed in
    /// this tab bar controller.
    override public var currentChild: UIViewController? {
        return childTabBarController.selectedViewController
    }
    /// A representation of one tab bar item on a
    /// StatefulTabBarController.
    public struct Item {
        let state: State
        let controller: UIViewController
    }

    let allItems: [Item]
    var currentItem: Item

    required public init(allItems: [Item], currentItem: Item) {
        self.allItems = allItems
        self.currentItem = currentItem
        super.init(initialState: currentItem.state)
    }

    open override func configureInitialState() {
        let allControllers = allItems.map { $0.controller }
        childTabBarController.setViewControllers(allControllers, animated: false)
        let currentController = currentItem.controller
        childTabBarController.selectedViewController = currentController
        addChild(childTabBarController)
    }

    open override func childViewController(for state: State) -> UIViewController {
        fatalError("Subclasses of StatefulTabBarController must implement childViewController(for:)")
    }

    @available(*, unavailable) public override final func transition(to newState: State, animated: Bool, completion: (() -> Void)?) {
        print("StatefulTabBarController does not animate transitions - use transition(to:, completion:) instead")
    }

    @available(*, unavailable) public override final func transitionAnimation(
        from oldState: State, to newState: State) -> StateTransitionAnimation? {
        print("transitionAnimation(from:, to:) called from a StatefulTabBarController subclass has no effect")
        return nil
    }

    open func transition(to newState: State, completion: (() -> Void)?) {
        guard let index = allItems.index(where: { $0.state == newState }) else {
            fatalError("Transitioning to state not found in tab bar items: \(newState)")
        }
        childTabBarController.selectedIndex = index
        state = newState
    }

}
