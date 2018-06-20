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
        // MARK: - configureInitialState
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
            it("sets navigation stack") {
                let vc = MockStatefulNavigationController()
                vc.loadViewIfNeeded()
                let navStack = vc.childNavigationController.viewControllers
                expect(navStack) == [vc.childForStateA]
            }
            it("sets currentChild") {
                let vc = MockStatefulNavigationController()
                vc.loadViewIfNeeded()
                expect(vc.currentChild) == vc.childForStateA
            }
            it("sets state") {
                let vc = MockStatefulNavigationController()
                vc.loadViewIfNeeded()
                expect(vc.state) == .stateA
            }
            it("sets statesInNavigationStack") {
                let vc = MockStatefulNavigationController()
                vc.loadViewIfNeeded()
                expect(vc.statesInNavigationStack) == [.stateA]
            }
        }
        // MARK: - transition
        describe("transition") {
            // MARK: not animated
            context("not animated") {
                it("calls configureInitialState if state not yet set") {
                    let vc = MockStatefulNavigationController()
                    expect(vc.hasConfiguredInitialState) == false
                    vc.transition(to: .stateB, animated: false)
                    expect(vc.hasConfiguredInitialState) == true
                }
                it("sets navigation stack") {
                    let vc = MockStatefulNavigationController()
                    vc.loadViewIfNeeded()
                    vc.transition(to: .stateB, animated: false)
                    expect(vc.childNavigationController.viewControllers)
                        .toEventually(equal([vc.childForStateA, vc.childForStateB]))
                }
                it("sets currentChild") {
                    let vc = MockStatefulNavigationController()
                    vc.loadViewIfNeeded()
                    vc.transition(to: .stateB, animated: false)
                    expect(vc.currentChild).toEventually(equal(vc.childForStateB))
                }
                it("sets state") {
                    let vc = MockStatefulNavigationController()
                    vc.loadViewIfNeeded()
                    vc.transition(to: .stateB, animated: false)
                    expect(vc.state).toEventually(equal(.stateB))
                }
                it("sets statesInNavigationStack") {
                    let vc = MockStatefulNavigationController()
                    vc.loadViewIfNeeded()
                    vc.transition(to: .stateB, animated: false)
                    expect(vc.statesInNavigationStack).toEventually(
                        equal([.stateA, .stateB]))
                }
            }
            // MARK: animated
            context("animated") {
                it("calls configureInitialState if state not yet set") {
                    let vc = MockStatefulNavigationController()
                    expect(vc.hasConfiguredInitialState) == false
                    vc.transition(to: .stateB, animated: true)
                    expect(vc.hasConfiguredInitialState) == true
                }
                it("sets navigation stack") {
                    let vc = MockStatefulNavigationController()
                    vc.loadViewIfNeeded()
                    vc.transition(to: .stateB, animated: true)
                    expect(vc.childNavigationController.viewControllers)
                        .toEventually(equal([vc.childForStateA, vc.childForStateB]))
                }
                it("sets currentChild") {
                    let vc = MockStatefulNavigationController()
                    vc.loadViewIfNeeded()
                    vc.transition(to: .stateB, animated: true)
                    expect(vc.currentChild).toEventually(equal(vc.childForStateB))
                }
                it("sets state") {
                    let vc = MockStatefulNavigationController()
                    vc.loadViewIfNeeded()
                    vc.transition(to: .stateB, animated: true)
                    expect(vc.state).toEventually(equal(.stateB))
                }
                it("sets statesInNavigationStack") {
                    let vc = MockStatefulNavigationController()
                    vc.loadViewIfNeeded()
                    vc.transition(to: .stateB, animated: true)
                    expect(vc.statesInNavigationStack).toEventually(
                        equal([.stateA, .stateB]))
                }
            }
        }
        // MARK: - pop transitions
        describe("pop transitions") {
            // MARK: not animated
            context("not animated") {
                it("pops automatically if the same view controller exists in the stack") {
                    let vc = MockPoppableNavigationController()
                    vc.loadViewIfNeeded()
                    waitUntil { done in
                        vc.transition(to: .stateB(reusableVC: true), animated: false) {
                            vc.transition(to: .stateA(reusableVC: true), animated: false) {
                                expect(vc.statesInNavigationStack.count) == 1
                                done()
                            }
                        }
                    }
                }
                it("won't pop automatically if told not to, and controllers are unique") {
                    let vc = MockPoppableNavigationController()
                    vc.loadViewIfNeeded()
                    waitUntil { done in
                        vc.transition(to: .stateA(reusableVC: false), canPop: false, animated: false) {
                            expect(vc.statesInNavigationStack.count) == 2
                            done()
                        }
                    }
                }
                it("will pop if allowed to, and a child from same state exists") {
                    let vc = MockPoppableNavigationController()
                    vc.loadViewIfNeeded()
                    waitUntil { done in
                        vc.transition(to: .stateB(reusableVC: false), animated: false) {
                            vc.transition(to: .stateA(reusableVC: false), animated: false) {
                                expect(vc.statesInNavigationStack.count) == 1
                                done()
                            }
                        }
                    }
                }
                it("will pop to the nearest option if multiple are eligible") {
                    let vc = MockPoppableNavigationController()
                    vc.loadViewIfNeeded()
                    waitUntil { done in
                        vc.transition(to: .stateA(reusableVC: false), canPop: false, animated: false) {
                            vc.transition(to: .stateA(reusableVC: false), animated: false) {
                                expect(vc.statesInNavigationStack.count) == 2
                                done()
                            }
                        }
                    }
                }
            }
            // MARK: animated
            context("animated") {
                it("pops automatically if the same view controller exists in the stack") {
                    let vc = MockPoppableNavigationController()
                    vc.loadViewIfNeeded()
                    waitUntil { done in
                        vc.transition(to: .stateB(reusableVC: true), animated: true) {
                            vc.transition(to: .stateA(reusableVC: true), animated: true) {
                                expect(vc.statesInNavigationStack.count) == 1
                                done()
                            }
                        }
                    }
                }
                it("won't pop automatically if allowed to, and controllers are unique") {
                    let vc = MockPoppableNavigationController()
                    vc.loadViewIfNeeded()
                    waitUntil { done in
                        vc.transition(to: .stateA(reusableVC: false), canPop: false, animated: true) {
                            expect(vc.statesInNavigationStack.count) == 2
                            done()
                        }
                    }
                }
                it("will pop if allowed to, and a child from same state exists") {
                    let vc = MockPoppableNavigationController()
                    vc.loadViewIfNeeded()
                    waitUntil { done in
                        vc.transition(to: .stateB(reusableVC: false), animated: true) {
                            vc.transition(to: .stateA(reusableVC: false), animated: true) {
                                expect(vc.statesInNavigationStack.count) == 1
                                done()
                            }
                        }
                    }
                }
                it("will pop to the nearest option if multiple are eligible") {
                    let vc = MockPoppableNavigationController()
                    vc.loadViewIfNeeded()
                    waitUntil { done in
                        vc.transition(to: .stateA(reusableVC: false), canPop: false, animated: true) {
                            vc.transition(to: .stateA(reusableVC: false), animated: true) {
                                expect(vc.statesInNavigationStack.count) == 2
                                done()
                            }
                        }
                    }
                }
            }
        }
    }

}
