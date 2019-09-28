//
//  AlertWindow.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import UIKit

protocol AlertWindowDelegate: class {
    func alertWindow(_ alertWindow: AlertWindow, didDismissAlert viewController: UIViewController)
}

class AlertWindow: UIWindow, HoldingDelegate {
    var alertViewController: UIViewController {
        return holdingViewController.containerViewController.childViewController
    }
    weak var delegate: AlertWindowDelegate?
    
    private let holdingViewController: HoldingViewController
    
    // MARK: - Init
    
    init(withAlertViewController alertViewController: UIViewController) {
        holdingViewController = HoldingViewController(withAlertViewController: alertViewController)
        super.init(frame: UIScreen.main.bounds)
        
        holdingViewController.delegate = self
        rootViewController = holdingViewController
        
        windowLevel = .normal
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unavailable")
    }
    
    // MARK: - HoldingDelegate
    
    fileprivate func viewController(_ viewController: HoldingViewController, didDismissAlert alertViewController: UIViewController) {
        resignKeyAndHide()
        delegate?.alertWindow(self, didDismissAlert: alertViewController)
    }
    
    // MARK: - Present
    
    func present() {
        makeKeyAndVisible()
    }
    
    func dismiss() {
        holdingViewController.dismissAlert()
    }

    // MARK: - Resign
    
    private func resignKeyAndHide() {
        resignKey()
        isHidden = true
    }
}

fileprivate protocol HoldingDelegate: class {
    func viewController(_ viewController: HoldingViewController, didDismissAlert alertViewController: UIViewController)
}

fileprivate class HoldingViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let containerViewController: AlertContainerViewController
    
    weak var delegate: HoldingDelegate?
    
    // MARK: - Init
    
    init(withAlertViewController alertViewController: UIViewController) {
        containerViewController = AlertContainerViewController(withChildViewController: alertViewController)
        super.init(nibName: nil, bundle: nil)
        
        containerViewController.modalPresentationStyle = .overCurrentContext
        containerViewController.modalTransitionStyle = .crossDissolve
        containerViewController.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present(containerViewController, animated: true, completion: nil)
    }

    // MARK: - Dismiss
    
    func dismissAlert() {
        containerViewController.dismiss(animated: true, completion: {
            self.delegate?.viewController(self, didDismissAlert: self.containerViewController.childViewController)
        })
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAlertPresentAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAlertDismissAnimationController()
    }
}

fileprivate class AlertContainerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let childViewController: UIViewController
    
    // MARK: - Init
    
    init(withChildViewController childViewController: UIViewController) {
        self.childViewController = childViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(childViewController)
        
        NSLayoutConstraint.activate([
            childViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            childViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            childViewController.view.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1),
            childViewController.view.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1),
            
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

fileprivate class CustomAlertPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        snapshot.frame = finalFrame
        snapshot.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        snapshot.alpha = 0.0
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshot)
        toViewController.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            snapshot.alpha = 1.0
            snapshot.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { _ in
            toViewController.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

fileprivate class CustomAlertDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: fromViewController)
        
        snapshot.frame = finalFrame
        
        containerView.addSubview(snapshot)
        fromViewController.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            snapshot.alpha = 0.0
        }) { _ in
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
