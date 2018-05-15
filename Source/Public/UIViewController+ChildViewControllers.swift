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
                  options: StateTransitionAnimationOptions? = nil,
                  completion: (() -> Void)? = nil) {
        addChild(controller, constrainedTo: view, options: options, completion: completion)
    }

    public func addChild(_ controller: UIViewController,
                  constrainedTo containerView: UIView,
                  options: StateTransitionAnimationOptions? = nil,
                  completion: (() -> Void)? = nil) {
        addChildViewController(controller)
        switch options {
        case .none:
            containerView.addSubview(controller.view)
            containerView.constrainToEdges(controller.view)
            controller.didMove(toParentViewController: self)
            completion?()
        case let .some(options):
            UIView.transition(with: containerView, duration: options.0, options: options.1, animations: {
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
                     options: StateTransitionAnimationOptions? = nil,
                     completion: (() -> Void)? = nil) {
        removeChild(controller, constrainedTo: view, options: options, completion: completion)
    }

    public func removeChild(_ controller: UIViewController,
                     constrainedTo containerView: UIView,
                     options: StateTransitionAnimationOptions? = nil,
                     completion: (() -> Void)? = nil) {
        assert(childViewControllers.contains(controller),
               "removeChild requires that the controller is in self.childViewControllers")
        controller.willMove(toParentViewController: nil)
        switch options {
        case .none:
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
            completion?()
        case let .some(options):
            UIView.transition(with: containerView, duration: options.0, options: options.1, animations: {
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
                      animation: StateTransitionAnimation? = nil,
                      completion: (() -> Void)? = nil) {
        replaceChild(oldController, with: newController, constrainedTo: view, animation: animation, completion: completion)
    }

    public func replaceChild(_ oldController: UIViewController,
                      with newController: UIViewController,
                      constrainedTo containerView: UIView,
                      animation: StateTransitionAnimation? = nil,
                      completion: (() -> Void)? = nil) {
        switch animation {
        case .none:
            removeChild(oldController, constrainedTo: containerView)
            addChild(newController, constrainedTo: containerView)
            completion?()
        case let .some(.appearOverPrevious(onAppear)):
            addChild(newController, constrainedTo: containerView, options: onAppear) {
                self.removeChild(oldController, constrainedTo: containerView, options: nil, completion: completion)
            }
        case let .some(.appearUnderPrevious(onRemove)):
            newController.view.isHidden = true
            addChild(newController, constrainedTo: containerView, options: nil) {
                containerView.sendSubview(toBack: newController.view)
                newController.view.isHidden = false
                self.removeChild(oldController, constrainedTo: containerView, options: onRemove, completion: completion)
            }
            break
        case let .some(.appearAndSimultaneouslyRemove(onAppear, onRemove)):
            let completionGroup = DispatchGroup()
            completionGroup.enter()
            addChild(newController, constrainedTo: containerView, options: onAppear) {
                completionGroup.leave()
            }
            completionGroup.enter()
            removeChild(oldController, constrainedTo: containerView, options: onRemove) {
                completionGroup.leave()
            }
            completionGroup.notify(queue: .main) {
                completion?()
            }
        case let .some(.removePreviousThenAppear(onRemove, onAppear)):
            removeChild(oldController, constrainedTo: containerView, options: onRemove) {
                self.addChild(newController, constrainedTo: containerView, options: onAppear, completion: completion)
            }
        }
    }

}
