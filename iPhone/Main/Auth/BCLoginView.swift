//
//  BCLoginView.swift
//  iPhone
//
//  Created by bstcine on 2017/10/23.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit
import cine

class BCLoginView: UIScrollView {
    
    private let logoView = UIImageView(image: UIImage(named: "logo_about")!)   // logo 视图
    let accountTF:BCTextField = {
        let accountTF = BCTextField(frame: .zero, placeHolder: "请输入手机号或用户名", leftIcon: UIImage(named: "ico_user")!)
        accountTF.text = BCUserModel.shared.userName
        
        accountTF.rightView?.isHidden = BCUserModel.shared.userName == ""
        
        accountTF.returnKeyType = .next
        return accountTF
    }()
    let passwordTF:BCTextField = {
        let passwordTF = BCTextField(frame: .zero, placeHolder: "请输入密码", leftIcon: UIImage(named: "ico_password")!)
        passwordTF.isSecureTextEntry = true
        passwordTF.returnKeyType = .go
        return passwordTF
    }()
    let nextButton = UIButton(title: "登录")
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoView)
        addSubview(accountTF)
        addSubview(passwordTF)
        addSubview(nextButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        logoView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(30)
            make.centerX.equalTo(self)
            make.size.equalTo(logoView)
        }
        accountTF.snp.makeConstraints { (make) in
            make.centerX.equalTo(logoView)
            make.top.equalTo(logoView.snp.bottom).offset(36)
            make.left.equalTo(self).offset(35)
            make.height.equalTo(42.5)
        }
        passwordTF.snp.makeConstraints { (make) in
            make.top.equalTo(accountTF.snp.bottom).offset(20)
            make.width.height.centerX.equalTo(accountTF)
        }
        nextButton.snp.makeConstraints({ (make) in
            make.top.equalTo(
                passwordTF.snp.bottom).offset(28)
            make.width.height.centerX.equalTo(passwordTF)
        })
    }
}

extension BCLoginView {
    func addLogin(target:Any,action:Selector){
        nextButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension UIButton {
    convenience init(title:String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 500, height: 60))
        backgroundColor = UIColor.RGB(RGBValue: 0x014292)
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.darkGray, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
}
