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

open class NavigationBar: UINavigationBar {
    
    // MARK: - Vars
    
    var height: CGFloat?
    
    private var barBackgroundView: UIView? {
        return subviews.first(where: { view -> Bool in
            return NSStringFromClass(type(of: view)) == "_UIBarBackground"
        })
    }
    
    private var backgroundView: UIView? {
        return value(forKey: "_backgroundView") as? UIView
    }
    
    var isBackgroundViewHidden = false {
        didSet {
            backgroundView?.isHidden = isBackgroundViewHidden
        }
    }
    
    // MARK: - Constructors
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundView?.addObserver(self, forKeyPath: "hidden", options: .new, context: nil)
    }
    
    // MARK: -
    
    deinit {
        backgroundView?.removeObserver(self, forKeyPath: "hidden")
    }
    
    // MARK: - Methods
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if backgroundView?.isHidden != isBackgroundViewHidden {
            backgroundView?.isHidden = isBackgroundViewHidden
        }
    }
    
    func copyNavigationBar() -> NavigationBar {
        let navigationBar = NavigationBar()
        navigationBar.barStyle = barStyle
        navigationBar.isTranslucent = isTranslucent
        navigationBar.tintColor = tintColor
        navigationBar.barTintColor = barTintColor
        navigationBar.setBackgroundImage(backgroundImage(for: .default), for: .default)
        navigationBar.setBackgroundImage(backgroundImage(for: .compact), for: .compact)
        navigationBar.setBackgroundImage(backgroundImage(for: .defaultPrompt), for: .defaultPrompt)
        navigationBar.setBackgroundImage(backgroundImage(for: .compactPrompt), for: .compactPrompt)
        navigationBar.shadowImage = shadowImage?.copy() as? UIImage
        navigationBar.prefersLargeTitles = prefersLargeTitles
        return navigationBar
    }
    
    // MARK: - Layout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let height = height {
            barBackgroundView?.frame.origin.y = bounds.height - height
            barBackgroundView?.frame.size.height = height
        }
    }
}
