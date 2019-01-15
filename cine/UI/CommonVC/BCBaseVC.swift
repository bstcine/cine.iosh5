//
//  BCBaseVC.swift
//  iPhone
//
//  Created by bstcine on 2017/10/17.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit
import SnapKit

open class BCBaseVC: UIViewController {
    public var isLandscape:Bool {
        get{
            return self.view.width > self.view.height
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        if self.navigationController?.viewControllers.first != self {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction))
        }
        
    }
    
    @objc public func backAction(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    open override var shouldAutorotate: Bool {
        return true
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        let interfaceOrientationValue = UIInterfaceOrientationMask.portrait.rawValue | UIInterfaceOrientationMask.portraitUpsideDown.rawValue
        
        let interfaceOrientation = UIInterfaceOrientationMask.init(rawValue: interfaceOrientationValue)
        
        return interfaceOrientation
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

