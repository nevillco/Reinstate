//
//  UIViewController+ChildViewControllers.swift
//  Reinstate
//
//  Created by Connor Neville on 3/1/18.
//

import Foundation


import UIKit

// MARK: Add Child Controller
public extension UIViewController {

    public func addChild(_ controller: UIViewController,
                  animation: StateTransitionAnimation? = nil,
                  completion: (() -> Void)? = nil) {
        addChild(controller, constrainedTo: view, animation: animation, completion: completion)
    }

    public func addChild(_ controller: UIViewController,
                  constrainedTo containerView: UIView,
                  animation: StateTransitionAnimation? = nil,
                  completion: (() -> Void)? = nil) {
        addChildViewController(controller)
        switch animation {
        case .none:
            containerView.addSubview(controller.view)
            containerView.constrainToEdges(controller.view)
            controller.didMove(toParentViewController: self)
            completion?()
        case let .some(settings):
            UIView.transition(with: containerView, duration: settings.duration, options: settings.options, animations: {
                containerView.addSubview(controller.view)
                containerView.constrainToEdges(controller.view)
            }, completion: { _ in
                controller.didMove(toParentViewController: self)
                completion?()
            })
        }
    }

}

// MARK: Remove Child Controller
public extension UIViewController {

    public func removeChild(_ controller: UIViewController,
                     animation: StateTransitionAnimation? = nil,
                     completion: (() -> Void)? = nil) {
        removeChild(controller, constrainedTo: view, animation: animation, completion: completion)
    }

    public func removeChild(_ controller: UIViewController,
                     constrainedTo containerView: UIView,
                     animation: StateTransitionAnimation? = nil,
                     completion: (() -> Void)? = nil) {
        assert(childViewControllers.contains(controller),
               "removeChild requires that the controller is in self.childViewControllers")
        controller.willMove(toParentViewController: nil)
        switch animation {
        case .none:
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
            completion?()
        case let .some(settings):
            UIView.transition(with: containerView, duration: settings.duration, options: settings.options, animations: {
                controller.view.removeFromSuperview()
            }, completion: { _ in
                controller.removeFromParentViewController()
                completion?()
            })
        }
    }

}

// MARK: Replace Child Controller
public extension UIViewController {

    public func replaceChild(_ oldController: UIViewController,
                      with newController: UIViewController,
                      transitionBehavior: StateTransitionBehavior,
                      completion: (() -> Void)? = nil) {
        replaceChild(oldController, with: newController, constrainedTo: view, transitionBehavior: transitionBehavior, completion: completion)
    }

    public func replaceChild(_ oldController: UIViewController,
                      with newController: UIViewController,
                      constrainedTo containerView: UIView,
                      transitionBehavior: StateTransitionBehavior,
                      completion: (() -> Void)? = nil) {
        let additionAnimations = transitionBehavior.additionAnimations
        let removalAnimations = transitionBehavior.removalAnimations
        switch transitionBehavior.order {
        case .addNewChildFirst:
            addChild(newController, constrainedTo: containerView, animation: additionAnimations, completion: {
                self.removeChild(oldController, constrainedTo: containerView, animation: removalAnimations, completion: completion)
            })
        case .removeExistingChildFirst:
            removeChild(oldController, constrainedTo: containerView, animation: removalAnimations, completion: {
                self.addChild(newController, constrainedTo: containerView, animation: additionAnimations, completion: completion)
            })
        case .simultaneous:
            let group = DispatchGroup()
            group.enter()
            addChild(newController, constrainedTo: containerView, animation: additionAnimations, completion: {
                group.leave()
            })
            group.enter()
            removeChild(oldController, constrainedTo: containerView, animation: removalAnimations, completion: {
                group.leave()
            })
            group.notify(queue: .main, execute: {
                completion?()
            })
        }
    }

}
