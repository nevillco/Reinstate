//
//  StatefulViewControllerSpec.swift
//  StatefulViewController_Tests
//
//  Created by Connor Neville on 3/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Reinstate

class StatefulViewControllerSpec: QuickSpec {

    override func spec() {
        it("defaults to managing self.view") {
            let vc = MockDefaultStatefulViewController()
            expect(vc.stateManagedViews) == [vc.view]
        }
        it("defaults to non-animated transition") {
            let vc = MockDefaultStatefulViewController()
            let behavior = vc.transitionBehavior(from: .stateA, to: .stateB, in: vc.view)
            expect(behavior.additionAnimations).to(beNil())
            expect(behavior.removalAnimations).to(beNil())
        }
        describe("configureInitialState") {
            it("adds correct child controllers") {
                let vc = MockCustomStatefulViewController()
                vc.loadViewIfNeeded()
                vc.configureInitialState()
                expect(vc.childViewControllers).to(contain(vc.defaultChildForSubviewA))
                expect(vc.childViewControllers).to(contain(vc.defaultChildForSubviewB))
            }
            it("constrains child controllers to their views") {
                let vc = MockCustomStatefulViewController()
                vc.loadViewIfNeeded()
                vc.configureInitialState()

                let childViewA = vc.defaultChildForSubviewA.view!
                let subviewA = vc.subviewA
                let childViewB = vc.defaultChildForSubviewB.view!
                let subviewB = vc.subviewB

                for attribute: NSLayoutAttribute in [.top, .leading, .bottom, .trailing] {
                    expect(subviewA.constraints).to(containElementSatisfying({ constraint -> Bool in
                        return constraint.isPinning(childViewA, subviewA, attribute)
                    }))
                    expect(subviewB.constraints).to(containElementSatisfying({ constraint -> Bool in
                        return constraint.isPinning(childViewB, subviewB, attribute)
                    }))
                }
            }
            it("sets currentStateManagedChildren") {
                let vc = MockCustomStatefulViewController()
                vc.loadViewIfNeeded()
                vc.configureInitialState()
                expect(vc.currentStateManagedChildren[vc.subviewA]) == vc.defaultChildForSubviewA
                expect(vc.currentStateManagedChildren[vc.subviewB]) == vc.defaultChildForSubviewB
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
                it("sets correct child controllers") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .secondStateNotAnimated)
                    expect(vc.childViewControllers).to(contain(vc.secondChildForSubviewA))
                    expect(vc.childViewControllers).to(contain(vc.secondChildForSubviewB))
                }
                it("removes previous child controllers") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .secondStateNotAnimated)
                    expect(vc.childViewControllers).toNot(contain(vc.defaultChildForSubviewA))
                    expect(vc.childViewControllers).toNot(contain(vc.defaultChildForSubviewB))
                }
                it("constrains child controllers to their views") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .secondStateNotAnimated)

                    let childViewA = vc.secondChildForSubviewA.view!
                    let subviewA = vc.subviewA
                    let childViewB = vc.secondChildForSubviewB.view!
                    let subviewB = vc.subviewB

                    for attribute: NSLayoutAttribute in [.top, .leading, .bottom, .trailing] {
                        expect(subviewA.constraints).to(containElementSatisfying({ constraint -> Bool in
                            return constraint.isPinning(childViewA, subviewA, attribute)
                        }))
                        expect(subviewB.constraints).to(containElementSatisfying({ constraint -> Bool in
                            return constraint.isPinning(childViewB, subviewB, attribute)
                        }))
                    }
                }
                it("sets currentStateManagedChildren") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .secondStateNotAnimated)
                    expect(vc.currentStateManagedChildren[vc.subviewA]) == vc.secondChildForSubviewA
                    expect(vc.currentStateManagedChildren[vc.subviewB]) == vc.secondChildForSubviewB
                }
                it("calls completion") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    var completionCalled = false
                    vc.transition(to: .secondStateNotAnimated, completion: {
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
                it("sets correct child controllers") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .secondStateAnimated)
                    expect(vc.childViewControllers).to(contain(vc.secondChildForSubviewA))
                    expect(vc.childViewControllers).to(contain(vc.secondChildForSubviewB))
                }
                it("removes previous child controllers") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .secondStateAnimated)
                    expect(vc.childViewControllers).toNot(contain(vc.defaultChildForSubviewA))
                    expect(vc.childViewControllers).toNot(contain(vc.defaultChildForSubviewB))
                }
                it("constrains child controllers to their views") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .secondStateAnimated)

                    let childViewA = vc.secondChildForSubviewA.view!
                    let subviewA = vc.subviewA
                    let childViewB = vc.secondChildForSubviewB.view!
                    let subviewB = vc.subviewB

                    for attribute: NSLayoutAttribute in [.top, .leading, .bottom, .trailing] {
                        expect(subviewA.constraints).to(containElementSatisfying({ constraint -> Bool in
                            return constraint.isPinning(childViewA, subviewA, attribute)
                        }))
                        expect(subviewB.constraints).to(containElementSatisfying({ constraint -> Bool in
                            return constraint.isPinning(childViewB, subviewB, attribute)
                        }))
                    }
                }
                it("sets currentStateManagedChildren") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    vc.transition(to: .secondStateAnimated)
                    expect(vc.currentStateManagedChildren[vc.subviewA]) == vc.secondChildForSubviewA
                    expect(vc.currentStateManagedChildren[vc.subviewB]) == vc.secondChildForSubviewB
                }
                it("calls completion") {
                    let vc = MockCustomStatefulViewController()
                    vc.loadViewIfNeeded()
                    vc.configureInitialState()
                    var completionCalled = false
                    vc.transition(to: .secondStateAnimated, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
            }
        }
    }

}

fileprivate extension NSLayoutConstraint {

    func isPinning(_ view1: UIView, _ view2: UIView, _ attribute: NSLayoutAttribute) -> Bool {
        let isCorrectAttribute = firstAttribute == attribute && secondAttribute == attribute
        let containsFirstView = (firstItem as? UIView) == view1 || (secondItem as? UIView) == view1
        let containsSecondView = (firstItem as? UIView) == view2 || (secondItem as? UIView) == view2
        return isCorrectAttribute && containsFirstView && containsSecondView
    }

}
