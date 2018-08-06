//
//  StatefulTabBarController.swift
//  Reinstate
//
//  Created by Connor Neville on 5/19/18.
//

import UIKit

/// A wrapper around `UITabBarController` that manages itself
/// according to a state variable.
open class StatefulTabBarController<State: Equatable>: UIViewController {

    /// The `UITabBarController` displayed by this view
    /// controller.
    public let childTabBarController = UITabBarController()
    /// A representation of one tab bar item on a
    /// StatefulTabBarController.
    public typealias Item = (State, UIViewController)

    /// All of the tab bar items for this StatefulTabBarController.
    public let allItems: [Item]
    /// The currently selected item for this StatefulTabBarController.
    public var currentItem: Item

    /// Initializes a new `StatefulTabBarController` with the given
    /// set of possible states and initial state.
    ///
    /// - Parameters:
    ///   - allItems: all of the items to be displayed on the tab bar.
    ///   - initialItem: the intitially selected item.
    public init(allItems: [Item], initialItem: Item) {
        self.allItems = allItems
        self.currentItem = initialItem
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialState()
    }

    /// Configures the initial state of the view controller. Should not be called
    /// directly and usually should not be overridden. If you do override this
    /// function, include a call to the superclass implementation.
    open func configureInitialState() {
        let allControllers = allItems.map { $0.1 }
        childTabBarController.setViewControllers(allControllers, animated: false)
        let currentController = currentItem.1
        childTabBarController.selectedViewController = currentController
        addChild(childTabBarController)
    }

    /// Transitions the tab bar to a new state.
    ///
    /// - Parameter newState: the state to transition to.
    open func transition(to newState: State) {
        guard let index = allItems.index(where: { $0.0 == newState }) else {
            fatalError("StatefulTabBarController found an unexpected state: \(newState)")
        }
        let newItem = allItems[index]
        childTabBarController.selectedViewController = newItem.1
        currentItem = newItem
    }

}
