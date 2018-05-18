//
//  StatefulNavigationControllerSpec.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Reinstate

class StatefulNavigationControllerSpec: QuickSpec {

    override func spec() {
        // MARK: configureInitialState
        describe("configureInitialState") {
            it("gets called after loading view") {
                let vc = MockStatefulNavigationController()
                vc.loadViewIfNeeded()
                expect(vc.hasConfiguredInitialState) == true
            }
            it("constrains navigation controller to its view") {
                let vc = MockStatefulNavigationController()
                vc.loadViewIfNeeded()
                let navigationControllerView = vc.childNavigationController.view!
                let view = vc.view!
                for attribute: NSLayoutAttribute in [.top, .leading, .bottom, .trailing] {
                    let predicate: (NSLayoutConstraint) -> Bool = {
                        return $0.isPinning(navigationControllerView, and: view, to: attribute)
                    }
                    expect(view.constraints).to(containElementSatisfying(predicate))
                }
            }
        }
    }

}
