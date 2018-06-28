//
//  NavigationInfoViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol NavigationInfoViewControllerDelegate: class {
    func navigationInfoViewControllerDidTapSetUsername(_ vc: NavigationInfoViewController)
}

class NavigationInfoViewController: UIViewController {

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = """
        This is an example of using StatefulNavigationController to manage a flow. Tap the button below to set a \"username\". The navigation controller will coordinate the back and forth.
        """
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    private let setUsernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set a Username", for: .normal)
        return button
    }()

    weak var delegate: NavigationInfoViewControllerDelegate?

    init(username: String?) {
        super.init(nibName: nil, bundle: nil)
        title = "Navigation"
        titleLabel.text = username ?? "No Username Yet"
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        view.backgroundColor = .white
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(setUsernameButton)
        setUsernameButton.addTarget(self, action: #selector(setUsernamePressed), for: .touchUpInside)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }

    @objc private func setUsernamePressed() {
        delegate?.navigationInfoViewControllerDidTapSetUsername(self)
    }

}
