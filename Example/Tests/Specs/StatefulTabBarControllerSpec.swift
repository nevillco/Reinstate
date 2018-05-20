//
//  StatefulTabBarControllerSpec.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 5/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Reinstate

class StatefulTabBarControllerSpec: QuickSpec {

    override func spec() {
        // MARK: - configureInitialState
        describe("configureInitialState") {
            it("gets called after loading view") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                expect(vc.hasConfiguredInitialState) == true
            }
            it("constrains tab bar controller to its view") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                let tabBarControllerView = vc.childTabBarController.view!
                let view = vc.view!
                for attribute: NSLayoutAttribute in [.top, .leading, .bottom, .trailing] {
                    let predicate: (NSLayoutConstraint) -> Bool = {
                        return $0.isPinning(tabBarControllerView, and: view, to: attribute)
                    }
                    expect(view.constraints).to(containElementSatisfying(predicate))
                }
            }
            it("sets tab bar controllers") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                let expectedControllers = [vc.childForStateA, vc.childForStateB]
                let tabBarControllers = vc.childTabBarController.viewControllers
                expect(expectedControllers) == tabBarControllers
            }
            it("sets selectedViewController") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                expect(vc.childTabBarController.selectedViewController) == vc.childForStateA
            }
            it("sets selectedIndex") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                expect(vc.childTabBarController.selectedIndex) == 0
            }
            it("sets currentItem") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                expect(vc.currentItem.0) == .stateA
                expect(vc.currentItem.1) == vc.childForStateA
            }
        }
        // MARK: - transition
        describe("transition") {
            it("sets selectedViewController") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                vc.transition(to: .stateB)
                expect(vc.childTabBarController.selectedViewController) == vc.childForStateB
            }
            it("sets selectedIndex") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                vc.transition(to: .stateB)
                expect(vc.childTabBarController.selectedIndex) == 1
            }
            it("sets currentItem") {
                let vc = MockStatefulTabBarController()
                vc.loadViewIfNeeded()
                vc.transition(to: .stateB)
                expect(vc.currentItem.0) == .stateB
                expect(vc.currentItem.1) == vc.childForStateB
            }
        }
    }

}
