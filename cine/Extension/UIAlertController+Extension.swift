//
//  UIAlertController+Extension.swift
//  iPhone
//
//  Created by bstcine on 2017/10/17.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit

extension UIAlertController {
    public convenience init(title:String){
        self.init(title: title, message: nil, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "确定"))
    }
    public convenience init(message:String){
        self.init(title: nil, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "确定"))
    }
    public convenience init(title:String,message:String){
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "确定"))
    }
    public convenience init(title:String?,message:String,sureAction:@escaping ((UIAlertAction)->Void)){
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "确定", handler: sureAction))
        self.addAction(UIAlertAction(cancelTitle: "取消"))
    }
    public convenience init(title:String, message:String, sureText:String, cancelText:String, sureAction:@escaping ((UIAlertAction)->Void)){
        
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: sureText, handler: sureAction))
        self.addAction(UIAlertAction(cancelTitle: cancelText))
    }
    public convenience init(title:String,message:String,cancelAction:@escaping ((UIAlertAction)->Void)){
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(cancelTitle: "取消", cancelHandler: cancelAction))
        self.addAction(UIAlertAction(title: "确定"))
    }
    public convenience init(title:String, message:String, sureText:String, cancelText:String, cancelAction:@escaping ((UIAlertAction)->Void)){
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(cancelTitle: cancelText, cancelHandler: cancelAction))
        self.addAction(UIAlertAction(title: sureText))
    }
    public convenience init(title:String,message:String,sureAction:@escaping ((UIAlertAction)->Void),cancelAction:@escaping ((UIAlertAction)->Void)){
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "确定", handler: sureAction))
        self.addAction(UIAlertAction(cancelTitle: "取消", cancelHandler: cancelAction))
    }
    public convenience init(title:String, message:String, sureText:String, cancelText:String, sureAction:@escaping ((UIAlertAction)->Void), cancelAction:@escaping ((UIAlertAction)->Void)){
        
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: sureText, handler: sureAction))
        self.addAction(UIAlertAction(cancelTitle: cancelText, cancelHandler: cancelAction))
    }
}
extension UIAlertAction {
    public convenience init(title:String){
        self.init(title: title, style: .destructive, handler: nil)
    }
    public convenience init(title:String,handler:@escaping ((UIAlertAction)->Void)){
        self.init(title: title, style: .destructive, handler: handler)
    }
    public convenience init(cancelTitle:String){
        self.init(title: cancelTitle, style: .cancel, handler: nil)
    }
    public convenience init(cancelTitle:String,cancelHandler:@escaping ((UIAlertAction)->Void)){
        self.init(title: cancelTitle, style: .cancel, handler: cancelHandler)
    }
}
