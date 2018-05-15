//
//  RootViewController.swift
//  Reinstate_Example
//
//  Created by Connor Neville on 03/01/2018.
//  Copyright (c) 2018 nevillco. All rights reserved.
//

import Reinstate

enum RootState {
    case splash
    case onboarding
    case signIn
    case home
}

class RootViewController: StatefulViewController<RootState> {

    var currentChild: UIViewController?

    override func childViewController(for state: RootState) -> UIViewController {
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

    override func transitionAnimation(from oldState: RootState, to newState: RootState) -> StateTransitionAnimation? {
        switch (oldState, newState) {
        case (.splash, _):
            return .appearAndSimultaneouslyRemove(
                onAppear: (0.3, .transitionCrossDissolve),
                onRemove: (0.3, .transitionCrossDissolve)
            )
        case (.onboarding, .signIn), (.signIn, .home):
            return .appearOverPrevious(onAppear:
                (0.3, .transitionFlipFromLeft))
        case (.signIn, .onboarding), (.home, .signIn):
            return .appearUnderPrevious(onRemove:
                (0.3, .transitionFlipFromRight))
        default:
            return nil
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
