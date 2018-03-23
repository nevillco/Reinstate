//
//  ViewController.swift
//  StatefulViewController
//
//  Created by Connor Neville on 03/01/2018.
//  Copyright (c) 2018 nevillco. All rights reserved.
//

import UIKit
import Reinstate

class RootViewController: UIViewController, StatefulViewController {

    enum State {
        case splash
        case onboarding
        case signIn
        case home
    }
    var state = State.splash

    var currentStateManagedChildren: [UIView: UIViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialState()
    }

}

extension RootViewController {

    func childViewController(for state: RootViewController.State, in view: UIView) -> UIViewController {
        switch state {
        case .splash:
            let vc = SplashViewController()
            vc.delegate = self
            return vc
        case .onboarding:
            let vc = OnboardingViewController()
            vc.delegate = self
            return vc
        case .signIn:
            let vc = SignInViewController()
            vc.delegate = self
            return vc
        case .home:
            let vc = HomeViewController()
            vc.delegate = self
            return vc
        }
    }

    func transitionBehavior(from oldState: RootViewController.State, to newState: RootViewController.State, in view: UIView) -> StateTransitionBehavior {
        switch (oldState, newState) {
        case (.splash, _):
            return StateTransitionBehavior(
                order: .simultaneous,
                additionAnimations: (duration: 0.3, options: .transitionCrossDissolve),
                removalAnimations: (duration: 0.3, options: .transitionCrossDissolve))
        case (.onboarding, .signIn), (.signIn, .home):
            return StateTransitionBehavior(
                order: .addNewChildFirst,
                additionAnimations: (duration: 0.3, options: .transitionFlipFromLeft))
        case (.signIn, .onboarding), (.home, .signIn):
            return StateTransitionBehavior(
                order: .addNewChildFirst,
                additionAnimations: (duration: 0.3, options: .transitionFlipFromRight))
        default:
            fatalError("Unexpected state transition from \(oldState) to \(newState)")
        }
    }

}

extension RootViewController: SplashViewControllerDelegate {

    func splashViewControllerDidComplete(_ controller: SplashViewController) {
        switch (UserDefaults.standard.isAuthenticated, UserDefaults.standard.hasCompletedOnboarding) {
        case (true, _):
            transition(to: .home)
        case (false, true):
            transition(to: .signIn)
        case (false, false):
            transition(to: .onboarding)
        }
    }

}

extension RootViewController: OnboardingViewControllerDelegate {

    func onboardingViewControllerDidComplete(_ controller: OnboardingViewController) {
        UserDefaults.standard.hasCompletedOnboarding = true
        transition(to: .signIn)
    }

}

extension RootViewController: SignInViewControllerDelegate {

    func signInViewControllerDidSignIn(_ controller: SignInViewController) {
        UserDefaults.standard.isAuthenticated = true
        transition(to: .home)
    }

    func signInViewControllerDidRevisitOnboarding(_ controller: SignInViewController) {
        UserDefaults.standard.hasCompletedOnboarding = false
        transition(to: .onboarding)
    }

}

extension RootViewController: HomeViewControllerDelegate {

    func homeViewControllerDidSignOut(_ controller: HomeViewController) {
        UserDefaults.standard.isAuthenticated = false
        transition(to: .signIn)
    }

}
