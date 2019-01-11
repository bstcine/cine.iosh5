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
        super.pushViewController(viewController, animated: animated)
    }
    override func popViewController(animated: Bool) -> UIViewController? {
        self.navigationBar.isHidden = self.viewControllers.count <= 2
        return super.popViewController(animated: animated)
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
