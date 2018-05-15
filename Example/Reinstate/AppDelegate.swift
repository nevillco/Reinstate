//
//  AppDelegate.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 03/01/2018.
//  Copyright (c) 2018 nevillco. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureWindow()
        return true
    }

}

private extension AppDelegate {

    func configureWindow() {
        let window = UIWindow()
        window.backgroundColor = .white
        window.rootViewController = RootViewController(initialState: .splash)
        window.makeKeyAndVisible()
        self.window = window
    }

}

