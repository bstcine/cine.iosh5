//
//  BCTextField.swift
//  BestcineEducation
//
//  Created by bstcine on 2017/7/19.
//  Copyright © 2017年 bstcine. All rights reserved.
//

import UIKit

class BCTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .none
        background = UIImage(named: "bg_input")!
        keyboardType = .numbersAndPunctuation
    }
    // 自定义构造方法，默认文字
    convenience init(frame:CGRect,placeHolder:String){
        self.init(frame: frame)
        let placeString = NSMutableAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        attributedPlaceholder = placeString
        font = UIFont.systemFont(ofSize: 14)
    }
    // 自定义构造方案（左视图）
    convenience init(frame:CGRect,placeHolder:String,leftIcon:UIImage) {
        self.init(frame: frame, placeHolder: placeHolder)
        // 创建输入框左显示图标
        self.addLeftView(leftIcon: leftIcon, leftText: nil)
        let cancelButton = UIButton(frame: .zero)
        cancelButton.setImage(UIImage(named: "ico_input_cancel")!, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelText(sender:)), for: .touchUpInside)
        cancelButton.isHidden = true
        self.rightView = cancelButton
        self.rightViewMode = .always
    }
    // 自定义构造方案（右视图）
    convenience init(frame:CGRect,placeHolder:String,rightIcon:UIImage){
        self.init(frame: frame, placeHolder: placeHolder)
        self.addRightView(rightIcon: rightIcon, rightText: nil)
    }
    // 自定义构造方案（左右视图）
    convenience init(frame:CGRect,placeHolder:String,leftIcon:UIImage,rightIcon:UIImage) {
        self.init(frame: frame, placeHolder: placeHolder, leftIcon: leftIcon)
        self.addLeftView(leftIcon: leftIcon, leftText: nil)
        self.addRightView(rightIcon: rightIcon, rightText: nil)
    }
    // 添加左视图
    func addRightView(rightIcon:UIImage?,rightText:String?){
        if rightIcon != nil {
            let accountTypeImg = UIImageView(frame: CGRect(origin: .zero, size: rightIcon!.size))
            accountTypeImg.image = rightIcon!
            self.rightView = accountTypeImg
            self.rightViewMode = .always
        }
        if rightText != nil {
            let rightLabel = UILabel()
            rightLabel.text = rightText!
            rightLabel.font = UIFont.systemFont(ofSize: 14)
            rightLabel.textColor = UIColor.RGB(RGBValue: 0xc2c3c5)
            rightLabel.sizeToFit()
            self.leftView = rightLabel
            self.leftViewMode = .always
        }
    }
    public var leftImage:UIImage? {
        get{
            return (self.leftView as? UIImageView)?.image
        }
        set{
            if newValue == nil {
                return
            }
            guard let leftImageView = self.leftView as? UIImageView else {
                return
            }
            let scale = newValue!.size.width / newValue!.size.height
            var newSize:CGSize
            if scale > 1 {
                newSize = CGSize(width: 20, height: 20/scale)
            }else{
                newSize = CGSize(width: 20*scale, height: 20)
            }
            leftImageView.image = newValue!
            leftImageView.size = newSize
        }
    }
    // 添加左视图
    func addLeftView(leftIcon:UIImage?,leftText:String?){
        if leftIcon != nil {
            let scale = leftIcon!.size.width / leftIcon!.size.height
            var newSize:CGSize
            if scale > 1 {
                newSize = CGSize(width: 20, height: 20/scale)
            }else{
                newSize = CGSize(width: 20*scale, height: 20)
            }
            let accountTypeImg = UIImageView(frame: CGRect(origin: .zero, size: newSize))
            accountTypeImg.image = leftIcon!
            self.leftView = accountTypeImg
            self.leftViewMode = .always
            return
        }
        if leftText != nil {
            let leftLabel = UILabel()
            leftLabel.text = leftText!
            leftLabel.font = UIFont.systemFont(ofSize: 14)
            leftLabel.textColor = UIColor.blue
            leftLabel.sizeToFit()
            self.leftView = leftLabel
            self.leftViewMode = .always
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 左图右偏31
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        iconRect.origin.x = iconRect.origin.x + 15
        return iconRect
    }
    // 右图左偏31
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.rightViewRect(forBounds: bounds)
        iconRect.origin.x = iconRect.origin.x - 15
        return iconRect
    }
    // 文本右偏15
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.textRect(forBounds: bounds)
        iconRect.origin.x = iconRect.origin.x + 10
        return iconRect
    }
    // 编辑文本右偏15
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.textRect(forBounds: bounds)
        iconRect.origin.x = iconRect.origin.x + 10
        return iconRect
    }
    @objc func cancelText(sender:UIButton){
        self.text = nil
        self.rightView?.isHidden = true
    }
}
