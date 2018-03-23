//
//  MockUIViewController.swift
//  Reinstate_Tests
//
//  Created by Connor Neville on 3/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reinstate

class MockUIViewController: UIViewController {

    var hasMovedToParentViewController = false

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        hasMovedToParentViewController = true
    }

}
