# Reinstate

[![Version](https://img.shields.io/cocoapods/v/Reinstate.svg?style=flat)](http://cocoapods.org/pods/Reinstate)
[![License](https://img.shields.io/cocoapods/l/Reinstate.svg?style=flat)](http://cocoapods.org/pods/Reinstate)
[![Platform](https://img.shields.io/cocoapods/p/Reinstate.svg?style=flat)](http://cocoapods.org/pods/Reinstate)

Reinstate helps you leverage child view controllers in your iOS application to make the code cleaner, easier to maintain, and less bug-prone.

## Adding and Removing Child View Controllers

Perhaps one of the most common beginner hurdles in the iOS world is the _massive view controller_ - UIKit heavily leans the developer towards an MVC pattern, and in reality that turns into putting everything that is neither a model nor a view inside the controller. There are lots of good ways to alleviate this problem, and one of those ways is to leverage __child view controllers__.

So let's look at adding a child view controller to a particular view. **Without Reinstate**:

```swift
// containerView is a subview of self.view,
// controller is the new child view controller
self.addChildViewController(controller)
containerView.addSubview(controller.view)
containerView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
    controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
    controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
    controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
])
controller.didMove(toParentViewController: self)
```

And this is without any animation code. The version with animation code is substantially longer. However, **with Reinstate**:

```swift
self.addChild(controller, constrainedTo: containerView)
// or, an animated version:
self.addChild(controller, constrainedTo: containerView, animations: (duration: 0.3, options: .transitionCrossDissolve))
```

You can similarly remove and replace child view controllers this way. But Reinstate goes beyond utilities to add and remove these child view controllers: it provides an interface for integrating them with the state of your parent controller.

## StatefulViewController

`StatefulViewController` is a `UIViewController` subclass that can manage its contents according to a  `State`. It does so by swapping out child view controllers that you can map to however you model the state of the controller. `StatefulViewController` can greatly cut down on boilerplate, confusing code, and give you an easy, readable API to specify transition animations and settings.

```swift

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
			transition(to: .home, animated: true)
        case (false, true):
			transition(to: .signIn, animated: true)
        case (false, false):
			transition(to: .onboarding, animated: true)
        }
    }

}

extension RootViewController: OnboardingViewControllerDelegate {

    func onboardingViewControllerDidComplete(_ controller: OnboardingViewController) {
        UserDefaults.standard.hasCompletedOnboarding = true
		transition(to: .signIn, animated: true)
    }

}

// Other delegate implementations omitted for brevity
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![Demo GIF](Resources/demo.gif)

The example demonstrates how you might use `StatefulViewController` to make a `RootViewController`, as described in the code above.

## Installation

Reinstate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Reinstate'
```

## Author

Connor Neville, connor.neville16@gmail.com

## License

Reinstate is available under the MIT license. See the LICENSE file for more info.
