//
//  BCHomeVC.swift
//  iPhone
//
//  Created by bstcine on 2017/10/19.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit
import cine

class BCHomeVC: BCBaseVC {
    
    var showInfo:Bool = false
    var tabButtons:[BCTabButton] = [BCTabButton]()
    private var lastTabButton:BCTabButton!
    private var lastVC:UIViewController!
    let tabHeight:CGFloat = 49
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildHomeUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let buttonWidth = self.view.width / CGFloat(tabButtons.count)
        for button in tabButtons {
            let index = CGFloat(tabButtons.index(of: button)!)
            button.frame = CGRect(x: index*buttonWidth, y: view.height-tabHeight, width: buttonWidth, height: tabHeight)
        }
        for childVC in children {
            childVC.view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - tabHeight)
        }
    }
    
    func buildHomeUI() {
        // 创建学习界面导航控制器（带学习控制器）
        self.creatChildVC(title: "学习",tabImg: UIImage(named: "xuexi")!,tabImageSel: UIImage(named: "xuexi_blue")!, h5Type: H5_URL_PATH.market)
        // 创建商城界面导航控制器（带商城控制器）
        self.creatChildVC(title: "商城",tabImg: UIImage(named: "shangcheng")!,tabImageSel: UIImage(named: "shangcheng_blue")!, h5Type: .market)
        // 创建用户信息界面导航控制器（带用户信息控制器）
        self.creatChildVC(title: "我的",tabImg: UIImage(named: "wode")!,tabImageSel: UIImage(named: "wode_blue")!, h5Type: .market)
        self.creatChildVC(title: "csub",tabImg: UIImage(named: "wode")!,tabImageSel: UIImage(named: "wode_blue")!, h5Type: .csub)
    }
    // 创建一个子控制器，（导航控制器）
    func creatChildVC(title:String,tabImg:UIImage,tabImageSel:UIImage, h5Type:H5_URL_PATH) {
        let rootVC = BCWebVC()
        rootVC.urlString = H5_URL_STRING(path: h5Type)
//        rootVC.tabBarItem.title = title
//        rootVC.tabBarItem.image = tabImg.withRenderingMode(.alwaysOriginal)
//        rootVC.tabBarItem.selectedImage = tabImageSel.withRenderingMode(.alwaysOriginal)
        let childVC = BCNavigationVC(rootViewController: rootVC)
        childVC.navigationBar.isHidden = true
        
        self.view.addSubview(childVC.view)
        self.addChild(childVC)
        
        let tabButton = BCTabButton(frame: .zero)
        tabButton.title = title
        tabButton.titleColor = UIColor.gray
        tabButton.selectTitleColor = UIColor.blue
        tabButton.titleImage = tabImg
        tabButton.selectTitleImage = tabImageSel
        tabButton.addTarget(self, action: #selector(clickTabButton(_:)), for: .touchUpInside)
        tabButton.tag = self.tabButtons.count
        if self.tabButtons.count == 0 {
            self.lastTabButton = tabButton
            self.lastVC = childVC
            tabButton.setSelected(true)
            childVC.view.isHidden = false
        }else {
            tabButton.setSelected(false)
            childVC.view.isHidden = true
        }
        self.tabButtons.append(tabButton)
        view.addSubview(tabButton)
    }
    
    @objc func clickTabButton(_ tabButton:BCTabButton) {
        
        if self.lastTabButton == tabButton {
            return
        }
        
        self.lastTabButton.setSelected(false)
        self.lastVC.view.isHidden = true
        
        tabButton.setSelected(true)
        
        let index = tabButton.tag
        
        let vc = self.children[index]
        vc.view.isHidden = false
        
        self.lastTabButton = tabButton
        self.lastVC = vc
        
    }
    
    func login(){
        
        self.login(nil)
    }
    
    func login(_ complete:((Bool)->Void)?) {
        
//        let loginVC = BCLoginVC()
//
//        loginVC.loginComplete = {(status) in
//            switch status {
//            case .success:
//                complete?(true)
//                break
//            default:
//                complete?(false)
//                break
//            }
//        }
//
//        let loginNav = BCNavigationVC(rootViewController: loginVC)
//
//        self.present(loginNav, animated: true, completion: nil)
    }
    
}

class BCTabButton: UIControl {
    
    private let titleImageView:UIImageView = UIImageView(frame: .zero)
    private let titleLabel:UILabel = UILabel(frame: .zero)
    var titleImage:UIImage? {
        set{
            titleImageView.image = newValue
        }
        get{
            return titleImageView.image
        }
    }
    var selectTitleImage:UIImage? {
        get{
            return titleImageView.highlightedImage
        }
        set{
            titleImageView.highlightedImage = newValue
        }
    }
    
    var title:String? {
        set{
            titleLabel.text = newValue
        }
        get{
            return titleLabel.text
        }
    }
    var titleColor:UIColor? {
        get{
            return titleLabel.textColor
        }
        set{
            titleLabel.textColor = newValue
        }
    }
    var selectTitleColor:UIColor?{
        get{
            return titleLabel.highlightedTextColor
        }
        set{
            titleLabel.highlightedTextColor = newValue
        }
    }
    
    func setSelected(_ isSelected:Bool) {
        self.titleImageView.isHighlighted = isSelected
        self.titleLabel.isHighlighted = isSelected
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        addSubview(titleImageView)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        let imageSize = titleImageView.image!.size
        titleImageView.frame = CGRect(origin: CGPoint(x: (self.width-imageSize.width)/2, y: 3), size: imageSize)
        titleLabel.frame = CGRect(x: 0, y: titleImageView.frame.maxY+3, width: self.width, height: self.height - titleImageView.frame.maxY-8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

