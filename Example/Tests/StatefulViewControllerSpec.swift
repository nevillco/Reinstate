//
//  StatefulViewControllerSpec.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 3/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Reinstate

class StatefulViewControllerSpec: QuickSpec {

    override func spec() {
        describe("configureInitialState") {
            it("gets called after loading view") {
                let vc = MockStatefulViewController(animatedTransitions: false)
                vc.loadViewIfNeeded()
                expect(vc.hasConfiguredInitialState) == true
            }
            it("adds correct child controller") {
                let vc = MockStatefulViewController(animatedTransitions: false)
                vc.loadViewIfNeeded()
                expect(vc.childViewControllers).to(contain(vc.childForStateA))
                expect(vc.childViewControllers).toNot(contain(vc.childForStateB))
            }
            it("constrains child controller to its view") {
                let vc = MockStatefulViewController(animatedTransitions: false)
                vc.loadViewIfNeeded()

                let childView = vc.childForStateA.view!
                let view = vc.view!
                for attribute: NSLayoutAttribute in [.top, .leading, .bottom, .trailing] {
                    let predicate: (NSLayoutConstraint) -> Bool = {
                        return $0.isPinning(childView, and: view, to: attribute)
                    }
                    expect(view.constraints).to(containElementSatisfying(predicate))
                }
            }
            it("sets currentChild") {
                let vc = MockStatefulViewController(animatedTransitions: false)
                vc.loadViewIfNeeded()
                expect(vc.currentChild) == vc.childForStateA
            }
        }
        describe("transition") {
            // TODO: fix this test
//            it("throws assertion if transitioning to same state") {
//                let vc = MockCustomStatefulViewController()
//                vc.loadViewIfNeeded()
//                vc.configureInitialState()
//                expect { vc.transition(to: .defaultState) }.to(throwAssertion())
//            }
            context("not animated") {
                // TODO: fix this test
//                it("throws assertion if initial state not set") {
//                    let vc = MockCustomStatefulViewController()
//                    vc.loadViewIfNeeded()
//                    expect { vc.transition(to: .secondStateNotAnimated) }.to(throwAssertion())
//                }
                it("sets correct child controller") {
                    let vc = MockStatefulViewController(animatedTransitions: false)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .stateB)
                    expect(vc.childViewControllers).to(contain(vc.childForStateB))
                }
                it("removes previous child controller") {
                    let vc = MockStatefulViewController(animatedTransitions: false)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .stateB)
                    expect(vc.childViewControllers).toNot(contain(vc.childForStateA))
                }
                it("constrains child controller to its view") {
                    let vc = MockStatefulViewController(animatedTransitions: false)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .stateB)

                    let childView = vc.childForStateB.view!
                    let view = vc.view!
                    for attribute: NSLayoutAttribute in [.top, .leading, .bottom, .trailing] {
                        let predicate: (NSLayoutConstraint) -> Bool = {
                            return $0.isPinning(childView, and: view, to: attribute)
                        }
                        expect(view.constraints).to(containElementSatisfying(predicate))
                    }
                }
                it("sets currentChild") {
                    let vc = MockStatefulViewController(animatedTransitions: false)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .stateB)
                    expect(vc.currentChild) == vc.childForStateB
                }
                it("calls completion") {
                    let vc = MockStatefulViewController(animatedTransitions: false)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    var completionCalled = false
                    vc.transition(to: .stateB, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
            }
            context("animated") {
                // TODO: fix this test
//                it("throws assertion if initial state not set") {
//                    let vc = MockCustomStatefulViewController()
//                    vc.loadViewIfNeeded()
//                    expect { vc.transition(to: .secondStateAnimated) }.to(throwAssertion())
//                }
                it("sets correct child controller") {
                    let vc = MockStatefulViewController(animatedTransitions: true)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .stateB)
                    expect(vc.childViewControllers).to(contain(vc.childForStateB))
                }
                it("removes previous child controller") {
                    let vc = MockStatefulViewController(animatedTransitions: true)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .stateB)
                    expect(vc.childViewControllers).toEventuallyNot(contain(vc.childForStateA))
                }
                it("constrains child controller to its view") {
                    let vc = MockStatefulViewController(animatedTransitions: true)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .stateB)

                    let childView = vc.childForStateB.view!
                    let view = vc.view!
                    for attribute: NSLayoutAttribute in [.top, .leading, .bottom, .trailing] {
                        let predicate: (NSLayoutConstraint) -> Bool = {
                            return $0.isPinning(childView, and: view, to: attribute)
                        }
                        expect(view.constraints).to(containElementSatisfying(predicate))
                    }
                }
                it("sets currentChild") {
                    let vc = MockStatefulViewController(animatedTransitions: true)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .stateB)
                    expect(vc.currentChild).toEventually(equal(vc.childForStateB))
                }
                it("calls completion") {
                    let vc = MockStatefulViewController(animatedTransitions: true)
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    var completionCalled = false
                    vc.transition(to: .stateB, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
            }
        }
    }

}

fileprivate extension NSLayoutConstraint {

    func isPinning(_ view1: UIView, and view2: UIView, to attribute: NSLayoutAttribute) -> Bool {
        let isCorrectAttribute = firstAttribute == attribute && secondAttribute == attribute
        let containsFirstView = (firstItem as? UIView) == view1 || (secondItem as? UIView) == view1
        let containsSecondView = (firstItem as? UIView) == view2 || (secondItem as? UIView) == view2
        return isCorrectAttribute && containsFirstView && containsSecondView
    }

}
