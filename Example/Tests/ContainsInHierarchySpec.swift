//
//  ContainsInHierarchySpec.swift
//  StatefulViewController_Tests
//
//  Created by Connor Neville on 3/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Reinstate

class ContainsInHierarchySpec: QuickSpec {
    override func spec() {
        describe("containsInHierarchy") {
            it("matches if parent == child") {
                let parent = UIView()
                let child = parent
                expect(parent.containsInHierarchy(child)) == true
            }
            it("matches if child is a subview of parent") {
                let parent = UIView()
                let child = UIView()
                parent.addSubview(child)
                expect(parent.containsInHierarchy(child)) == true
            }
            it("matches if child is a nested subview of parent") {
                let parent = UIView()
                let child1 = UIView()
                parent.addSubview(child1)
                let child2 = UIView()
                child1.addSubview(child2)
                expect(parent.containsInHierarchy(child2)) == true
            }
            it("does not match if not in hierarchy") {
                let view1 = UIView()
                let view2 = UIView()
                expect(view1.containsInHierarchy(view2)) == false
            }
        }
    }
}
