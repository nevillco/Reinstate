//
//  UserDefaults+Utility.swift
//  StatefulViewController_Example
//
//  Created by Connor Neville on 3/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension UserDefaults {

    var hasCompletedOnboarding: Bool {
        get {
            return bool(forKey: "hasCompletedOnboarding")
        }
        set {
            set(newValue, forKey: "hasCompletedOnboarding")
        }
    }

    var isAuthenticated: Bool {
        get {
            return bool(forKey: "isAuthenticated")
        }
        set {
            set(newValue, forKey: "isAuthenticated")
        }
    }

}
