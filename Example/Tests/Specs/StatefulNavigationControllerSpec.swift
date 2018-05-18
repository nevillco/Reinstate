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
        }
    }

}
