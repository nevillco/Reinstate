//
//  LayoutConstraint+isPinning.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

    func isPinning(_ view1: UIView, and view2: UIView, to attribute: NSLayoutAttribute) -> Bool {
        let isCorrectAttribute = firstAttribute == attribute && secondAttribute == attribute
        let containsFirstView = (firstItem as? UIView) == view1 || (secondItem as? UIView) == view1
        let containsSecondView = (firstItem as? UIView) == view2 || (secondItem as? UIView) == view2
        return isCorrectAttribute && containsFirstView && containsSecondView
    }

}
