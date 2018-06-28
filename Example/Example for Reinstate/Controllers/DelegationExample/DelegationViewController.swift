//
//  DelegationViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 6/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol DelegationViewControllerDelegate: class {
    func delegationViewControllerDidSwitchTabs(_ vc: DelegationViewController)
}

class DelegationViewController: UIViewController {

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
        label.text = "Delegation Example"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = """
        This view controller demonstrates how you can use the delegation pattern to send messages to your parent view controller. Tap on the button below to programmatically switch tabs.
        """
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    private let switchTabsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Switch to the middle tab", for: .normal)
        return button
    }()

    weak var delegate: DelegationViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Delegation"
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
        stackView.addArrangedSubview(switchTabsButton)
        switchTabsButton.addTarget(self, action: #selector(switchTabsPressed), for: .touchUpInside)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }

    @objc private func switchTabsPressed() {
        delegate?.delegationViewControllerDidSwitchTabs(self)
    }

}
