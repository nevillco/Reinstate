//
//  UIView+ContainsSubview.swift
//  Reinstate
//
//  Created by Connor Neville on 3/2/18.
//

import Foundation

extension UIView {

    func containsInHierarchy(_ subview: UIView) -> Bool {
        if subview == self {
            return true
        }
        for nextSubview in subviews {
            if nextSubview.containsInHierarchy(subview) {
                return true
            }
        }
        return false
    }

}
