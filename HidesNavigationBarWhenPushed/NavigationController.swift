/*
 The MIT License (MIT)
 Copyright (c) 2018 Danil Gontovnik
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

class NavigationController: UINavigationController {
    
    // MARK: - Types
    
    private typealias TransitionCompletion = (() -> Void)
    
    // MARK: - Vars
    
    private var _navigationBar: NavigationBar {
        return navigationBar as! NavigationBar
    }
    
    private var transitionCompletions = [UIViewController: TransitionCompletion]()
    
    // MARK: - Constructors
    
    init() {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: -
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        viewControllers = [rootViewController]
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        delegate = self
        if let viewController = viewControllers.first as? ViewController, viewController.hidesNavigationBarWhenPushed {
            forceHideNavigationBar()
        }
    }
    
    // MARK: - Methods
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let currentViewController = viewControllers.last
        
        if let currentViewController = currentViewController as? ViewController,
            let viewController = viewController as? ViewController,
            isNavigationBarHidden == false {
            if currentViewController.hidesNavigationBarWhenPushed == false && viewController.hidesNavigationBarWhenPushed == true {
                let fakeNavigationBar = addFakeNavigationBar(to: currentViewController)
                currentViewController.fakeNavigationBar = fakeNavigationBar
                _navigationBar.isBackgroundViewHidden = true
            } else if currentViewController.hidesNavigationBarWhenPushed == true && viewController.hidesNavigationBarWhenPushed == false {
                let fakeNavigationBar = _navigationBar.copyNavigationBar()
                
                viewController.viewWillAppearNavigationBarUpdatesBlock = { [weak self] in
                    guard let strongSelf = self else { return }
                    viewController.view.addSubview(fakeNavigationBar)
                    strongSelf.layout(fakeNavigationBar: fakeNavigationBar, within: viewController)
                }
                
                setTransitionCompletion(for: viewController) { [weak self] in
                    fakeNavigationBar.removeFromSuperview()
                    self?._navigationBar.isBackgroundViewHidden = false
                }
            }
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @discardableResult override func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count > 1 {
            if let currentViewController = viewControllers.last as? ViewController,
                let previousViewController = viewControllers[viewControllers.count - 2] as? ViewController {
                return pop(from: currentViewController, to: previousViewController, animated: animated)
            }
        }
        return super.popViewController(animated: animated)
    }
    
    @discardableResult override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if viewControllers.count > 1 {
            if let currentViewController = viewControllers.last as? ViewController,
                let previousViewController = viewControllers.first as? ViewController {
                return [pop(from: currentViewController, to: previousViewController, animated: animated)]
            }
        }
        return super.popToRootViewController(animated: animated)
    }
    
    fileprivate func pop(from currentViewController: ViewController, to previousViewController: ViewController, animated: Bool) -> UIViewController {
        if currentViewController.hidesNavigationBarWhenPushed == true && previousViewController.hidesNavigationBarWhenPushed == false {
            setTransitionCompletion(for: previousViewController) { [weak self] in
                previousViewController.fakeNavigationBar?.removeFromSuperview()
                previousViewController.fakeNavigationBar = nil
                self?._navigationBar.isBackgroundViewHidden = false
            }
        } else if currentViewController.hidesNavigationBarWhenPushed == false && previousViewController.hidesNavigationBarWhenPushed == true {
            let fakeNavigationBar = addFakeNavigationBar(to: currentViewController)
            _navigationBar.isBackgroundViewHidden = true
            currentViewController.viewWillAppearNavigationBarUpdatesBlock = { [weak self] in
                self?._navigationBar.isBackgroundViewHidden = false
                fakeNavigationBar.removeFromSuperview()
            }
        }
        super.popToViewController(previousViewController, animated: animated)
        return currentViewController
    }
    
    // MARK: -
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        if let viewController = visibleViewController as? ViewController, viewController.hidesNavigationBarWhenPushed && hidden == false {
            forceHideNavigationBar()
        }
    }
    
    private func setTransitionCompletion(for viewController: UIViewController, completion: @escaping TransitionCompletion) {
        transitionCompletions[viewController] = completion
    }
    
    private func forceHideNavigationBar() {
        _navigationBar.isBackgroundViewHidden = true
    }
    
    private func addFakeNavigationBar(to viewController: ViewController) -> NavigationBar {
        let fakeNavigationBar = _navigationBar.copyNavigationBar()
        viewController.view.addSubview(fakeNavigationBar)
        layout(fakeNavigationBar: fakeNavigationBar, within: viewController)
        return fakeNavigationBar
    }
    
    private func layout(fakeNavigationBar: NavigationBar, within viewController: UIViewController) {
        var rect = navigationBar.frame
        rect = navigationBar.superview?.convert(rect, to: viewController.view) ?? rect
        fakeNavigationBar.frame = rect
        fakeNavigationBar.height = rect.origin.y + rect.height
    }
}

// MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let transitionCompletion = transitionCompletions[viewController] {
            transitionCompletion()
            transitionCompletions.removeValue(forKey: viewController)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
}
