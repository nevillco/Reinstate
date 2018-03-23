//
//  SignInViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 3/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol SignInViewControllerDelegate: class {
    func signInViewControllerDidSignIn(_ controller: SignInViewController)
    func signInViewControllerDidRevisitOnboarding(_ controller: SignInViewController)
}

final class SignInViewController: UIViewController, Gesturable {

    weak var delegate: SignInViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        configureGesturableInfoView(in: view, title: "Sign In")
        configureTapGesture(in: view, target: self, action: #selector(gestureTapped))
    }

}

private extension SignInViewController {

    @objc func gestureTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { _ in
            self.delegate?.signInViewControllerDidSignIn(self)
        }
        actionSheet.addAction(signInAction)
        let resetOnboardingAction = UIAlertAction(title: "Revisit Onboarding", style: .default) { _ in
            self.delegate?.signInViewControllerDidRevisitOnboarding(self)
        }
        actionSheet.addAction(resetOnboardingAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }

}
