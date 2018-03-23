//
//  OnboardingViewController.swift
//  StatefulViewController_Example
//
//  Created by Connor Neville on 3/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func onboardingViewControllerDidComplete(_ controller: OnboardingViewController)
}

final class OnboardingViewController: UIViewController, Gesturable {

    weak var delegate: OnboardingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        configureGesturableInfoView(in: view, title: "Onboarding")
        configureTapGesture(in: view, target: self, action: #selector(gestureTapped))
    }

}

private extension OnboardingViewController {

    @objc func gestureTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let completeAction = UIAlertAction(title: "Complete Onboarding", style: .default) { _ in
            self.delegate?.onboardingViewControllerDidComplete(self)
        }
        actionSheet.addAction(completeAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }

}
