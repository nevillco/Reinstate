//
//  UIView+ConstrainToEdges.swift
//  Reinstate
//
//  Created by Connor Neville on 3/15/18.
//

import Foundation

extension UIView {

    func constrainToEdges(_ child: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: topAnchor),
            child.leadingAnchor.constraint(equalTo: leadingAnchor),
            child.trailingAnchor.constraint(equalTo: trailingAnchor),
            child.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
