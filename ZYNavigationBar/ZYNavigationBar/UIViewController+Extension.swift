//
//  UIViewController+Extension.swift
//  ZYNavigationBar
//
//  Created by yu zhou on 11/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

extension UIViewController {
    fileprivate struct ZYAssociatedKeys{
        static var zy_barStyleKey = "zy_barStyleKey"
        static var zy_barTintColorKey = "zy_barTintColorKey"
        static var zy_barImageKey = "zy_barImageKey"
        static var zy_tintColorKey = "zy_tintColorKey"
        static var zy_titleTextAttributesKey = "zy_titleTextAttributesKey"
        static var zy_barAlphaKey = "zy_barAlphaKey"
        static var zy_barIsHiddenKey = "zy_barIsHiddenKey"
        static var zy_barShadowIsHiddenKey = "zy_barShadowIsHiddenKey"
        static var zy_backInteractiveKey = "zy_backInteractiveKey"
        static var zy_swipeBackEnabledKey = "zy_swipeBackEnabledKey"
    }
    var zy_barStyle: UIBarStyle {
        get{
            guard let style = objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_barStyleKey) as? UIBarStyle else {
                return UINavigationBar.appearance().barStyle
            }
            return style
        }set{
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_barStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_barTintColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_barTintColorKey) as? UIColor
        }set {
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_barTintColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.zy_needsUpdateNavigationBarColorOrImage()
//            guard let bar = self.navigationController?.navigationBar as? ZYNavigationBar else { return }
//            bar.backgroundImageView?.backgroundColor = newValue
        }
    }
    
    var zy_barImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_barImageKey) as? UIImage
        }set {
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_barImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_tintColor: UIColor {
        get{
            guard let color = objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_tintColorKey) as? UIColor else {
                return UIColor.red
            }
            return color
        }set {
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_tintColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_titleTextAttributes: [NSAttributedStringKey : Any] {
        get{
            guard let attr = objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_titleTextAttributesKey) as? [NSAttributedStringKey : Any] else {
                return UINavigationBar.appearance().titleTextAttributes  ?? [NSAttributedStringKey : Any]()
            }
            return attr
        }set {
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_titleTextAttributesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_barAlpha: CGFloat {
        get{
            if self.zy_barIsHidden {
                return 0
            }
            guard let alpha = objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_barAlphaKey) as? CGFloat else {
                return 1
            }
            return alpha
        }set {
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_barAlphaKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_barIsHidden: Bool {
        get{
            return objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_barIsHiddenKey) as? Bool ?? false
        }set {
            if newValue {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem()
                self.navigationItem.titleView = UIView()
            }else{
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.titleView = nil
            }
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_barIsHiddenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_barShadowIsHidden: Bool {
        get{
            return zy_barIsHidden ? zy_barIsHidden : objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_barShadowIsHiddenKey) as? Bool ?? false
        }set {
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_barShadowIsHiddenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_backInteractive: Bool {
        get{
            return objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_backInteractiveKey) as? Bool ?? true
        }set {
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_backInteractiveKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_swipeBackEnabled: Bool {
        get{
            return objc_getAssociatedObject(self, &ZYAssociatedKeys.zy_swipeBackEnabledKey) as? Bool ?? true
        }set {
            objc_setAssociatedObject(self, &ZYAssociatedKeys.zy_swipeBackEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var zy_computedBarShadowAlpha: CGFloat {
        return self.zy_barShadowIsHidden ? 0 : self.zy_barAlpha
    }
    
    var zy_computedBarImage: UIImage? {
        let image = self.zy_barImage
        guard image == nil else { return image }
        guard self.zy_barTintColor == nil else { return nil }
        return UINavigationBar.appearance().backgroundImage(for: .default)
    }
    
    var zy_computedBarTintColor: UIColor? {
        guard self.zy_barImage == nil else { return nil }
        let color = self.zy_barTintColor
        guard color == nil else { return color }
        guard UINavigationBar.appearance().backgroundImage(for: .default) == nil else { return nil }
        guard UINavigationBar.appearance().barTintColor == nil else { return UINavigationBar.appearance().barTintColor }
        return UINavigationBar.appearance().barStyle == .default ? UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 0.8) : UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.729)
    }
    
    
    func zy_needsUpdateNavigationBar() {
        guard let nav = self.navigationController as? ZYNavigationController else { return }
        nav.updateNavigationBarForViewController(controller: self)
    }
    
    func zy_needsUpdateNavigationBarAlpha() {
        guard let nav = self.navigationController as? ZYNavigationController else { return }
        nav.updateNavigationBarAlphaForViewController(self)
    }
    
    func zy_needsUpdateNavigationBarColorOrImage() {
        guard let nav = self.navigationController as? ZYNavigationController else { return }
        nav.updateNavigationBarColorOrImageForViewController(self)
    }
    
    func zy_needsUpdateNavigationBarShadowAlpha() {
        guard let nav = self.navigationController as? ZYNavigationController else { return }
        nav.updateNavigationBarShadowAlphaForViewController(self)
    }
    
}
