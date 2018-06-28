//
//  NavigationSetUsernameViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol NavigationSetUsernameViewControllerDelegate: class {
    func navigationSetUsernameViewController(_ vc: NavigationSetUsernameViewController, didEnterUsername username: String)
}

class NavigationSetUsernameViewController: UIViewController {

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 8
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Set a username below and press save, or go back without saving, and the navigation controller will update its state.
        """
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.font = UIFont.systemFont(ofSize: 20)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        return button
    }()

    weak var delegate: NavigationSetUsernameViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Set Username"
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textField.resignFirstResponder()
    }

    private func configureView() {
        view.backgroundColor = .white
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
            ])
    }

    @objc private func savePressed() {
        let username = textField.text ?? "empty"
        delegate?.navigationSetUsernameViewController(self, didEnterUsername: username)
    }

}
