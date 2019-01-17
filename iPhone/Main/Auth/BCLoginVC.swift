//
//  BCLoginVC.swift
//  iPhone
//
//  Created by 曾政桦 on 2017/10/11.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit
import cine

enum BCAccountType {
    case phone
    case email
}

class BCLoginVC: BCBaseVC {
    let content = BCLoginView()
    var accountType:BCAccountType = .phone
    
    public var loginComplete:((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(content)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico_login_close")!, style: .plain, target: self, action: #selector(back))
        navigationController?.navigationBar.backgroundColor = view.backgroundColor
        
        content.delegate = self
        content.accountTF.delegate = self
        content.passwordTF.delegate = self
        
        if content.accountTF.text == nil || content.accountTF.text == "" {
            content.accountTF.becomeFirstResponder()
        }
        
        content.addLogin(target: self, action: #selector(login))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(resignAllResponder))
        content.addGestureRecognizer(panGesture)
    }
    
    @objc func login(){
        
        weak var weakSelf:BCLoginVC? = self
        
        BCAuthLogic.login(account: content.accountTF.text!, password: content.passwordTF.text!, success: { (isSuccess) in
            
            if weakSelf == nil {
                return
            }
            
            if isSuccess {
                
                BCAuthLogic.getUserModel().userName = weakSelf!.content.accountTF.text!
                weakSelf?.content.passwordTF.resignFirstResponder()
                
                weakSelf?.loginComplete?(true)
                
                weakSelf?.loginComplete = nil
                
                weakSelf?.back()
                
            }
            
        }) { (error) in
            
        }
    }
    
    @objc func back(){
        
        self.loginComplete?(false)
        self.loginComplete = nil
        
        self.resignAllResponder()
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        content.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        resignAllResponder()
    }
    @objc func resignAllResponder(){
        
        if content.accountTF.isFirstResponder {
            
            content.accountTF.resignFirstResponder()
            
        }else if content.passwordTF.isFirstResponder {
            
            content.passwordTF.resignFirstResponder()
        }
    }
    deinit {
    }
}

extension BCLoginVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == content.accountTF {
            content.passwordTF.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
            self.login()
        }
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let tf:BCTextField = textField as? BCTextField else {
            return true
        }
        
        guard let rightButton = tf.rightView as? UIButton else {
            return true
        }
        
        if string != "" {
            
            rightButton.isHidden = false
            
        }else{
            
            if range.location == 0 {
                
                rightButton.isHidden = true
            }
            
        }
        
        return true
    }
    
}

extension BCLoginVC:UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.resignAllResponder()
    }
}

