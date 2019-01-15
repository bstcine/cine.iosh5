//
//  BCNavigationVC.swift
//  iPhone
//
//  Created by bstcine on 2017/10/20.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit

class BCNavigationVC: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationBar.isHidden = false
        
        if  self.parent != nil,
            let homeVC = UIApplication.shared.keyWindow?.rootViewController as? BCHomeVC,
            homeVC.loginVC != self {
            
            homeVC.hiddenTabBar = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    override func popViewController(animated: Bool) -> UIViewController? {
        self.navigationBar.isHidden = self.viewControllers.count <= 2
        if self.viewControllers.count <= 2, let homeVC = UIApplication.shared.keyWindow?.rootViewController as? BCHomeVC {
            homeVC.hiddenTabBar = false
        }
        return super.popViewController(animated: animated)
    }
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
    override var shouldAutorotate: Bool{
        return self.topViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? false
    }
}
