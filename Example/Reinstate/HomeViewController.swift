//
//  HomeViewController.swift
//  StatefulViewController_Example
//
//  Created by Connor Neville on 3/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate: class {
    func homeViewControllerDidSignOut(_ controller: HomeViewController)
}

final class HomeViewController: UIViewController, Gesturable {

    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.magenta
        configureGesturableInfoView(in: view, title: "Home")
        configureTapGesture(in: view, target: self, action: #selector(gestureTapped))
    }

}

private extension HomeViewController {

    @objc func gestureTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
            self.delegate?.homeViewControllerDidSignOut(self)
        }
        actionSheet.addAction(signOutAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }

}
