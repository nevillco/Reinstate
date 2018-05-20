//
//  StatefulTabBarController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/19/18.
//

import UIKit

open class StatefulTabBarController<State: Equatable>: UIViewController {

    /// The `UINavigationController` displayed by this view
    /// controller.
    public let childTabBarController = UITabBarController()
    /// A representation of one tab bar item on a
    /// StatefulTabBarController.
    public struct Item {
        let state: State
        let controller: UIViewController

        public init(_ state: State, _ controller: UIViewController) {
            self.state = state
            self.controller = controller
        }
    }

    /// All of the tab bar items for this StatefulTabBarController.
    public let allItems: [Item]
    /// The currently selected item for this StatefulTabBarController.
    public private(set) var currentItem: Item

    public init(allItems: [Item], currentItem: Item) {
        self.allItems = allItems
        self.currentItem = currentItem
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialState()
    }

    open func configureInitialState() {
        let allControllers = allItems.map { $0.controller }
        childTabBarController.setViewControllers(allControllers, animated: false)
        let currentController = currentItem.controller
        childTabBarController.selectedViewController = currentController
        addChild(childTabBarController)
    }

    open func transition(to newState: State) {
        guard let index = allItems.index(where: { $0.state == newState }) else {
            fatalError("Transitioning to state not found in tab bar items: \(newState)")
        }
        let newItem = allItems[index]
        childTabBarController.selectedViewController = newItem.controller
        currentItem = newItem
    }

}
