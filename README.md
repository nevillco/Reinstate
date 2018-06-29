# Reinstate

[![Version](https://img.shields.io/cocoapods/v/Reinstate.svg?style=flat)](http://cocoapods.org/pods/Reinstate)
[![License](https://img.shields.io/cocoapods/l/Reinstate.svg?style=flat)](http://cocoapods.org/pods/Reinstate)
[![Platform](https://img.shields.io/cocoapods/p/Reinstate.svg?style=flat)](http://cocoapods.org/pods/Reinstate)

Reinstate is a toolbox for creating apps using hierarchies of view controllers, helping to dispel the myth that a `UIViewController` needs to correspond to a single screen in your application. Write clean and easy-to-understand app logic using container and child view controllers, keeping each individual component small and much easier to maintain.

`UIKit` comes with a few built-in container view controllers that are meant to coordinate app logic (`UINavigationController`, `UITabBarController`, `UIPageViewController` to name a few). They hold on to one or several child view controllers and handle the necessary app logic to switch between them. Reinstate aims to make it easy to use this pattern in your own `UIViewControllers` to help break your app into composable pieces. What exactly do you get out of this pattern?

* Your view controllers are less dependent on one another. Do your view controllers do things like  `self.navigationController?.pushViewController(...`? It's common, but now this view controller doesn't know how to operate outside of a particular navigation stack.
* This pattern can be extended to single screens. If you have a really complicated UI, rather than a single, massive view controller, you could have a single container view controller that manages a handful of children.
* It is easier to identify bugs, and be more confident that regressions won't occur. Going back to the above example, suppose you have a bug in one of the widgets in your highly complex UI. As a single view controller, it's harder to know if your change will impact the view controller elsewhere, and it's probably harder to even pinpoint the bug. However, with container and child view controllers, you can isolate the particular component and be sure the others are not involved.
* Unlike a screen broken down into several `UIView`s, each child `UIViewController` reaps the benefits of the `UIViewController` lifecycle events. You can supply some special logic to occur on only one component of your screen on `viewWillAppear`. Or you can customize the layout code of a single component when it rotates to landscape mode.

How to get started?

## Installation

Reinstate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Reinstate'
```

## Adding and Removing Child View Controllers

It’s probably second nature adding `UIView` subclasses to your `UIViewController`. But how about adding a child `UIViewController` instead? **Without Reinstate** it looks like this:

```swift
// childController is the new child view controller
self.addChildViewController(childController)
view.addSubview(childController.view)
NSLayoutConstraint.activate([
    childController.view.topAnchor.constraint(equalTo: view.topAnchor),
    childController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    childController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    childController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
])
childController.didMove(toParentViewController: self)
```

And this gets a *lot* more complicated if you want to animate the change. However, **with Reinstate**:

```swift
self.addChild(childController)
// or, an animated version:
self.addChild(childController, animations: (duration: 0.3, options: .transitionCrossDissolve))
// or, add it to a subview instead of self.view:
self.addChild(childController, constrainedTo: containerView, animations: (duration: 0.3, options: .transitionCrossDissolve))
```

You can similarly remove and replace child view controllers this way. But Reinstate goes beyond utilities to add and remove these child view controllers: it provides several clean container view controllers for you to manage the state of your app.

## StatefulViewController

`StatefulViewController` is a `UIViewController` subclass that can manage its contents according to a  `State`. It does so by swapping out child view controllers that you can map to however you model the state of the controller. `StatefulViewController` can greatly cut down on confusing code, and give you an easy, readable API to specify transition animations and settings.

```swift

import Reinstate

enum RootViewState {
    case splash
    case onboarding
    case signIn
    case home
}

class RootViewController: StatefulViewController<RootViewState> {

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

## StatefulNavigationController

`StatefulNavigationController` is a wrapper around `UINavigationController` that manages its navigation stack according to its `NavigationState`. Similar to `StatefulViewController`, you tell it which view controller should be created for which state, and tell it when to transition. The API is meant to mirror that of `StatefulViewController`. See the Example project for usage.

[Flowchart describing whether your transition will push or pop](Resources/NavigationLogic.png)

## StatefulTabBarController

`StatefulNavigationController` is a wrapper around `UITabBarController`, in the same vein as the other stateful controllers. Its API is highly similar to the other two (one difference: a Tab Bar needs to know all possible states when initialized). See the Example project for usage.

## Example

To run the example project, clone the repo, open and run `Example/Reinstate.xcworkspace`.

## Author

Connor Neville, connor.neville16@gmail.com

## License

Reinstate is available under the MIT license. See the LICENSE file for more info.
