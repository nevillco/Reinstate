//
//  SplashViewController.swift
//  StatefulViewController_Example
//
//  Created by Connor Neville on 3/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol SplashViewControllerDelegate: class {
    func splashViewControllerDidComplete(_ controller: SplashViewController)
}

final class SplashViewController: UIViewController {

    weak var delegate: SplashViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        configureInfoView()
        configureDelayedCompletion()
    }

}

private extension SplashViewController {

    func configureInfoView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Splash Screen"
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)

        let bodyLabel = UILabel()
        bodyLabel.text = "Automatically advancing after 3 seconds."
        bodyLabel.font = UIFont.systemFont(ofSize: 16)
        bodyLabel.textAlignment = .center
        stackView.addArrangedSubview(bodyLabel)

        view.addSubview(stackView)

        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func configureDelayedCompletion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.delegate?.splashViewControllerDidComplete(self)
        }
    }

}

