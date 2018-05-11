//
//  ChildViewControllerSpec.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 3/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Reinstate

class ChildViewControllerSpec: QuickSpec {
    override func spec() {
        // MARK: - addChild
        describe("addChild") {
            // MARK: without animations
            context("without animations") {
                it("adds a child view controller") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChild(child, animation: nil, completion: nil)
                    expect(parent.childViewControllers).to(contain(child))
                }
                it("calls didMove(toParentViewController:)") {
                    let parent = UIViewController()
                    let child = MockUIViewController()
                    parent.addChild(child, animation: nil, completion: nil)
                    expect(child.hasMovedToParentViewController) == true
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    var completionCalled = false
                    parent.addChild(child, animation: nil, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChild(child, animation: nil, completion: nil)
                    expect(child.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.addChild(child, constrainedTo: container, animation: nil, completion: nil)
                    expect(child.view.superview) == container
                }
            }
            // MARK: with animations
            context("with animation") {
                it("adds a child view controller") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
                    parent.addChild(child, animation: animation, completion: nil)
                    expect(parent.childViewControllers).to(contain(child))
                }
                it("calls didMove(toParentViewController:)") {
                    let parent = UIViewController()
                    let child = MockUIViewController()
                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
                    parent.addChild(child, animation: animation, completion: nil)
                    expect(child.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    var completionCalled = false
                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
                    parent.addChild(child, animation: animation, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
                    parent.addChild(child, animation: animation, completion: nil)
                    expect(child.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    let container = UIView()
                    parent.view.addSubview(container)
                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
                    parent.addChild(child, constrainedTo: container, animation: animation, completion: nil)
                    expect(child.view.superview) == container
                }
            }
        }
        // MARK: - removeChild
        describe("removeChild") {
            // MARK: without animations
            context("without animations") {
                it("removes child view controller") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChildViewController(child)
                    parent.removeChild(child, animation: nil, completion: nil)
                    expect(parent.childViewControllers).to(beEmpty())
                }
                it("calls didMove(toParentViewController:)") {
                    let parent = UIViewController()
                    let child = MockUIViewController()
                    parent.addChildViewController(child)
                    parent.removeChild(child, animation: nil, completion: nil)
                    expect(child.hasMovedToParentViewController) == true
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChildViewController(child)
                    var completionCalled = false
                    parent.removeChild(child, animation: nil, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                // TODO: fix this test
//                it("throws assertion if child is not a child controller") {
//                    let parent = UIViewController()
//                    let child = UIViewController()
//                    expect { parent.removeChild(child, animation: nil, completion: nil) }.to(throwAssertion())
//                }
            }
            // MARK: with animations
            context("with animations") {
                it("removes child view controller") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChildViewController(child)
                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
                    parent.removeChild(child, animation: animation, completion: nil)
                    expect(parent.childViewControllers).toEventually(beEmpty())
                }
                it("calls didMove(toParentViewController:)") {
                    let parent = UIViewController()
                    let child = MockUIViewController()
                    parent.addChildViewController(child)
                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
                    parent.removeChild(child, animation: animation, completion: nil)
                    expect(child.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChildViewController(child)
                    var completionCalled = false
                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
                    parent.removeChild(child, animation: animation, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                // TODO: fix this test
//                it("throws assertion if child is not a child controller") {
//                    let parent = UIViewController()
//                    let child = UIViewController()
//                    let animation: StateTransitionAnimation = (duration: 0.5, options: .curveEaseIn)
//                    expect { parent.removeChild(child, animation: animation, completion: nil) }.to(throwAssertion())
//                }
            }
        }
        // MARK: - replaceChild
        describe("replaceChild") {
            // MARK: without animations - add new first behavior
            context("without animations - add new first behavior") {
                it("removes existing child view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .addNewChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).toNot(contain(oldChild))
                }
                it("adds new view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .addNewChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).to(contain(newChild))
                }
                it("calls didMove(toParentViewController:) for existing") {
                    let parent = UIViewController()
                    let oldChild = MockUIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .addNewChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(oldChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls didMove(toParentViewController:) for new") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = MockUIViewController()
                    let behavior = StateTransitionBehavior(order: .addNewChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .addNewChildFirst)
                    var completionCalled = false
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .addNewChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .addNewChildFirst)
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.replaceChild(oldChild, with: newChild, constrainedTo: container, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == container
                }
                // TODO: fix this test
//                it("throws assertion if existing is not a child controller") {
//                    let parent = UIViewController()
//                    let oldChild = UIViewController()
//                    let newChild = UIViewController()
//                    let behavior = StateTransitionBehavior(order: .addNewChildFirst)
//                    expect { parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil) }.to(throwAssertion())
//                }
            }
            // MARK: without animations - remove existing first behavior
            context("without animations - remove existing first behavior") {
                it("removes existing child view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .removeExistingChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).toNot(contain(oldChild))
                }
                it("adds new view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .removeExistingChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).to(contain(newChild))
                }
                it("calls didMove(toParentViewController:) for existing") {
                    let parent = UIViewController()
                    let oldChild = MockUIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .removeExistingChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(oldChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls didMove(toParentViewController:) for new") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = MockUIViewController()
                    let behavior = StateTransitionBehavior(order: .removeExistingChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .removeExistingChildFirst)
                    var completionCalled = false
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .removeExistingChildFirst)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .removeExistingChildFirst)
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.replaceChild(oldChild, with: newChild, constrainedTo: container, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == container
                }
                // TODO: fix this test
//                it("throws assertion if existing is not a child controller") {
//                    let parent = UIViewController()
//                    let oldChild = UIViewController()
//                    let newChild = UIViewController()
//                    let behavior = StateTransitionBehavior(order: .removeExistingChildFirst)
//                    expect { parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil) }.to(throwAssertion())
//                }
            }
            // MARK: without animations - simultaneous behavior
            context("without animations - simultaneous behavior") {
                it("removes existing child view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .simultaneous)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).toNot(contain(oldChild))
                }
                it("adds new view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .simultaneous)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).to(contain(newChild))
                }
                it("calls didMove(toParentViewController:) for existing") {
                    let parent = UIViewController()
                    let oldChild = MockUIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .simultaneous)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(oldChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls didMove(toParentViewController:) for new") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = MockUIViewController()
                    let behavior = StateTransitionBehavior(order: .simultaneous)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .simultaneous)
                    var completionCalled = false
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .simultaneous)
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(order: .simultaneous)
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.replaceChild(oldChild, with: newChild, constrainedTo: container, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == container
                }
                // TODO: fix this test
//                it("throws assertion if existing is not a child controller") {
//                    let parent = UIViewController()
//                    let oldChild = UIViewController()
//                    let newChild = UIViewController()
//                    let behavior = StateTransitionBehavior(order: .simultaneous)
//                    expect { parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil) }.to(throwAssertion())
//                }
            }
            // MARK: with animations - add new first behavior
            context("with animations - add new first behavior") {
                it("removes existing child view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .addNewChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).toEventuallyNot(contain(oldChild))
                }
                //
                it("adds new view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .addNewChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).to(contain(newChild))
                }
                it("calls didMove(toParentViewController:) for existing") {
                    let parent = UIViewController()
                    let oldChild = MockUIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .addNewChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(oldChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls didMove(toParentViewController:) for new") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = MockUIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .addNewChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .addNewChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    var completionCalled = false
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .addNewChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .addNewChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.replaceChild(oldChild, with: newChild, constrainedTo: container, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == container
                }
                // TODO: Fix this test. Testing an async assertion failure
                // does not seem to work with expect { ... }.toEventually(throwAssertion())
                //                it("throws assertion if existing is not a child controller") {
                //                    let parent = UIViewController()
                //                    let oldChild = UIViewController()
                //                    let newChild = UIViewController()
                //                    let behavior: StateTransitionBehavior =
                //                        .addNewChildFirst(
                //                            additionAnimations: (duration: 0.2, options: .curveEaseIn),
                //                            removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                //                    expect { parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil) }.toEventually(throwAssertion())
                //                }
                //
            }
            // MARK: with animations - remove existing first behavior
            context("with animations - remove existing first behavior") {
                it("removes existing child view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .removeExistingChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).toEventuallyNot(contain(oldChild))
                }
                it("adds new view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .removeExistingChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).toEventually(contain(newChild))
                }
                it("calls didMove(toParentViewController:) for existing") {
                    let parent = UIViewController()
                    let oldChild = MockUIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .removeExistingChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(oldChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls didMove(toParentViewController:) for new") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = MockUIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .removeExistingChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .removeExistingChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    var completionCalled = false
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .removeExistingChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview).toEventually(equal(parent.view))
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .removeExistingChildFirst,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.replaceChild(oldChild, with: newChild, constrainedTo: container, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview).toEventually(equal(container))
                }
                // TODO: fix this test
//                it("throws assertion if existing is not a child controller") {
//                    let parent = UIViewController()
//                    let oldChild = UIViewController()
//                    let newChild = UIViewController()
//                    let behavior = StateTransitionBehavior(
//                        order: .removeExistingChildFirst,
//                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
//                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
//                    expect { parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil) }.toEventually(throwAssertion())
//                }
            }
            // MARK: with animations - simultaneous behavior
            context("with animations - simultaneous behavior") {
                it("removes existing child view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .simultaneous,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).toEventuallyNot(contain(oldChild))
                }
                it("adds new view controller") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .simultaneous,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(parent.childViewControllers).to(contain(newChild))
                }
                it("calls didMove(toParentViewController:) for existing") {
                    let parent = UIViewController()
                    let oldChild = MockUIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .simultaneous,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(oldChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls didMove(toParentViewController:) for new") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = MockUIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .simultaneous,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .simultaneous,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    var completionCalled = false
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .simultaneous,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let oldChild = UIViewController()
                    parent.addChildViewController(oldChild)
                    let newChild = UIViewController()
                    let behavior = StateTransitionBehavior(
                        order: .simultaneous,
                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.replaceChild(oldChild, with: newChild, constrainedTo: container, transitionBehavior: behavior, completion: nil)
                    expect(newChild.view.superview) == container
                }
                // TODO: fix this test
//                it("throws assertion if existing is not a child controller") {
//                    let parent = UIViewController()
//                    let oldChild = UIViewController()
//                    let newChild = UIViewController()
//                    let behavior = StateTransitionBehavior(
//                        order: .simultaneous,
//                        additionAnimations: (duration: 0.2, options: .curveEaseIn),
//                        removalAnimations: (duration: 0.2, options: .transitionFlipFromLeft))
//                    expect { parent.replaceChild(oldChild, with: newChild, transitionBehavior: behavior, completion: nil) }.toEventually(throwAssertion())
//                }
            }
        }
    }
}

