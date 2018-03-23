//
//  GesturingViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 3/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol Gesturable { }

extension Gesturable {

    func configureTapGesture(in view: UIView, target: Any, action: Selector) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        gesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(gesture)
    }

    func configureGesturableInfoView(in view: UIView, title: String) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)

        let bodyLabel = UILabel()
        bodyLabel.text = "Double tap for actions."
        bodyLabel.font = UIFont.systemFont(ofSize: 16)
        bodyLabel.textAlignment = .center
        stackView.addArrangedSubview(bodyLabel)

        view.addSubview(stackView)

        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
