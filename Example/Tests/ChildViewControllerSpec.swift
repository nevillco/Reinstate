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
    let animationOptions: StateTransitionAnimationOptions = (0.1, .curveEaseIn)
    override func spec() {
        // MARK: - addChild
        describe("addChild") {
            // MARK: without animations
            context("without animations") {
                it("adds a child view controller") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChild(child, options: nil, completion: nil)
                    expect(parent.childViewControllers).to(contain(child))
                }
                it("calls didMove(toParentViewController:)") {
                    let parent = UIViewController()
                    let child = MockUIViewController()
                    parent.addChild(child, options: nil, completion: nil)
                    expect(child.hasMovedToParentViewController) == true
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    var completionCalled = false
                    parent.addChild(child, options: nil, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChild(child, options: nil, completion: nil)
                    expect(child.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.addChild(child, constrainedTo: container, options: nil, completion: nil)
                    expect(child.view.superview) == container
                }
            }
            // MARK: with animations
            context("with animation") {
                it("adds a child view controller") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChild(child, options: self.animationOptions, completion: nil)
                    expect(parent.childViewControllers).to(contain(child))
                }
                it("calls didMove(toParentViewController:)") {
                    let parent = UIViewController()
                    let child = MockUIViewController()
                    parent.addChild(child, options: self.animationOptions, completion: nil)
                    expect(child.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    var completionCalled = false
                    parent.addChild(child, options: self.animationOptions, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                it("adds child to parent.view by default") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChild(child, options: self.animationOptions, completion: nil)
                    expect(child.view.superview) == parent.view
                }
                it("adds child to container if specified") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    let container = UIView()
                    parent.view.addSubview(container)
                    parent.addChild(child, constrainedTo: container, options: self.animationOptions, completion: nil)
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
                    parent.removeChild(child, options: nil, completion: nil)
                    expect(parent.childViewControllers).to(beEmpty())
                }
                it("calls didMove(toParentViewController:)") {
                    let parent = UIViewController()
                    let child = MockUIViewController()
                    parent.addChildViewController(child)
                    parent.removeChild(child, options: nil, completion: nil)
                    expect(child.hasMovedToParentViewController) == true
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChildViewController(child)
                    var completionCalled = false
                    parent.removeChild(child, options: nil, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                // TODO: re-enable this test when the throwAssertion()
                // predicate in Nimble is no longer broken
                //                it("throws assertion if child is not a child controller") {
                //                    let parent = UIViewController()
                //                    let child = UIViewController()
                //                    expect { parent.removeChild(child, options: nil, completion: nil) }.to(throwAssertion())
                //                }
            }
            // MARK: with animations
            context("with animations") {
                it("removes child view controller") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChildViewController(child)
                    parent.removeChild(child, options: self.animationOptions, completion: nil)
                    expect(parent.childViewControllers).toEventually(beEmpty())
                }
                it("calls didMove(toParentViewController:)") {
                    let parent = UIViewController()
                    let child = MockUIViewController()
                    parent.addChildViewController(child)
                    parent.removeChild(child, options: self.animationOptions, completion: nil)
                    expect(child.hasMovedToParentViewController).toEventually(beTrue())
                }
                it("calls completion") {
                    let parent = UIViewController()
                    let child = UIViewController()
                    parent.addChildViewController(child)
                    var completionCalled = false
                    parent.removeChild(child, options: self.animationOptions, completion: {
                        completionCalled = true
                    })
                    expect(completionCalled).toEventually(beTrue())
                }
                // TODO: re-enable this test when the throwAssertion()
                // predicate in Nimble is no longer broken
                //                it("throws assertion if child is not a child controller") {
                //                    let parent = UIViewController()
                //                    let child = UIViewController()
                //                    expect { parent.removeChild(child, options: self.animationOptions, completion: nil) }.to(throwAssertion())
                //                }
            }
        }
        // MARK: - replaceChild
        describe("replaceChild") {
            // MARK: without animations
            context("without animations") {
                let allAnimations: [StateTransitionAnimation] = [
                    .appearOverPrevious(onAppear: nil),
                    .appearUnderPrevious(onRemove: nil),
                    .appearAndSimultaneouslyRemove(onAppear: nil, onRemove: nil),
                    .removePreviousThenAppear(onRemove: nil, onAppear: nil)
                ]
                it("removes existing child view controller") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(parent.childViewControllers).toNot(contain(oldChild))
                    }
                }
                it("adds new view controller") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(parent.childViewControllers).to(contain(newChild))
                    }
                }
                it("calls didMove(toParentViewController:) for existing") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = MockUIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(oldChild.hasMovedToParentViewController).toEventually(beTrue())
                    }
                }
                it("calls didMove(toParentViewController:) for new") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = MockUIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(newChild.hasMovedToParentViewController).toEventually(beTrue())
                    }
                }
                it("calls completion") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        var completionCalled = false
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: {
                            completionCalled = true
                        })
                        expect(completionCalled).toEventually(beTrue())
                    }
                }
                it("adds child to parent.view by default") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(newChild.view.superview) == parent.view
                    }
                }
                it("adds child to container if specified") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        let container = UIView()
                        parent.view.addSubview(container)
                        parent.replaceChild(oldChild, with: newChild, constrainedTo: container, animation: animation, completion: nil)
                        expect(newChild.view.superview) == container
                    }
                }
                // TODO: re-enable this test when the throwAssertion()
                // predicate in Nimble is no longer broken
//                it("throws assertion if existing is not a child controller") {
//                    for animation in allAnimations {
//                        let parent = UIViewController()
//                        let oldChild = UIViewController()
//                        let newChild = UIViewController()
//                        expect { parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil) }.to(throwAssertion())
//                    }
//                }
            }
            // MARK: appear over previous with animations
            context("appear over previous with animations") {
                let allAnimations: [StateTransitionAnimation] = [
                    .appearOverPrevious(onAppear: self.animationOptions),
                    .appearUnderPrevious(onRemove: self.animationOptions),
                    .appearAndSimultaneouslyRemove(onAppear: self.animationOptions, onRemove: nil),
                    .removePreviousThenAppear(onRemove: self.animationOptions, onAppear: self.animationOptions)
                ]
                it("removes existing child view controller") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(parent.childViewControllers).toEventuallyNot(contain(oldChild))
                    }
                }
                it("adds new view controller") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(parent.childViewControllers).toEventually(contain(newChild))
                    }
                }
                it("calls didMove(toParentViewController:) for existing") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = MockUIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(oldChild.hasMovedToParentViewController).toEventually(beTrue())
                    }
                }
                it("calls didMove(toParentViewController:) for new") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = MockUIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(newChild.hasMovedToParentViewController).toEventually(beTrue())
                    }
                }
                it("calls completion") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        var completionCalled = false
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: {
                            completionCalled = true
                        })
                        expect(completionCalled).toEventually(beTrue())
                    }
                }
                it("adds child to parent.view by default") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil)
                        expect(newChild.view.superview).toEventually(equal(parent.view))
                    }
                }
                it("adds child to container if specified") {
                    for animation in allAnimations {
                        let parent = UIViewController()
                        let oldChild = UIViewController()
                        parent.addChildViewController(oldChild)
                        let newChild = UIViewController()
                        let container = UIView()
                        parent.view.addSubview(container)
                        parent.replaceChild(oldChild, with: newChild, constrainedTo: container, animation: animation, completion: nil)
                        expect(newChild.view.superview).toEventually(equal(container))
                    }
                }
                // TODO: re-enable this test when the throwAssertion()
                // predicate in Nimble is no longer broken
//                it("throws assertion if existing is not a child controller") {
//                    for animation in allAnimations {
//                        let parent = UIViewController()
//                        let oldChild = UIViewController()
//                        let newChild = UIViewController()
//                        expect { parent.replaceChild(oldChild, with: newChild, animation: animation, completion: nil) }.toEventually(throwAssertion())
//                    }
//                }
            }
        }
    }
}

