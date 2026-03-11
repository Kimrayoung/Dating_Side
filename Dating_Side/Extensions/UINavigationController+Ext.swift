//
//  UINavigationController+Ext.swift
//  Dating_Side
//
//  Created by Codex on 3/10/26.
//

import UIKit
import ObjectiveC.runtime

extension UINavigationController: UIGestureRecognizerDelegate {
    /// Enables interactive pop gesture globally even when custom back buttons are used.
    static func enableGlobalSwipeBack() {
        _ = swizzlePushViewController
        _ = swizzleSetViewControllers
    }
    
    private static let swizzlePushViewController: Void = {
        guard
            let originalMethod = class_getInstanceMethod(UINavigationController.self, #selector(UINavigationController.pushViewController(_:animated:))),
            let swizzledMethod = class_getInstanceMethod(UINavigationController.self, #selector(UINavigationController.ds_pushViewController(_:animated:)))
        else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    private static let swizzleSetViewControllers: Void = {
        guard
            let originalMethod = class_getInstanceMethod(UINavigationController.self, #selector(UINavigationController.setViewControllers(_:animated:))),
            let swizzledMethod = class_getInstanceMethod(UINavigationController.self, #selector(UINavigationController.ds_setViewControllers(_:animated:)))
        else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc private func ds_pushViewController(_ viewController: UIViewController, animated: Bool) {
        ds_pushViewController(viewController, animated: animated)
        enableSwipeBackGesture()
    }
    
    @objc private func ds_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        ds_setViewControllers(viewControllers, animated: animated)
        enableSwipeBackGesture()
    }
    
    private func enableSwipeBackGesture() {
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === interactivePopGestureRecognizer else { return true }
        
        let canPop = viewControllers.count > 1
        let notTransitioning = transitionCoordinator == nil
        return canPop && notTransitioning
    }
}
