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
    private var lastVC:BCNavigationVC!
    private var tabHeight:CGFloat = 49
    private let tabBar:BCTabBar = BCTabBar(frame: .zero)
    public var hiddenTabBar:Bool {
        set{
            if newValue {
                if tabHeight != 0 {
                    tabHeight = 0
                    tabBar.frame = CGRect(x: 0, y: view.height-tabHeight, width: view.width, height: 0)
                }
            }else {
                if tabHeight == 0 {
                    tabHeight = 49
                    tabBar.frame = CGRect(x: 0, y: view.height-tabHeight, width: view.width, height: 49)
                }
            }
        }
        get{
            return tabHeight == 0
        }
    }
    public weak var loginVC:BCNavigationVC?
    private var studyVC:BCNavigationVC = {
        let vc = BCStudyVC()
        let nav = BCNavigationVC(rootViewController: vc)
        nav.navigationBar.isHidden = true
        return nav
    }()
    private var marketVC:BCNavigationVC = {
        let vc = BCMarketVC()
        let nav = BCNavigationVC(rootViewController: vc)
        nav.navigationBar.isHidden = true
        return nav
    }()
    private var mineVC:BCNavigationVC = {
        let vc = BCMineVC()
        let nav = BCNavigationVC(rootViewController: vc)
        nav.navigationBar.isHidden = true
        return nav
    }()
    private var pwaVC:BCNavigationVC = {
        let vc  = BCPWAVC()
        let nav = BCNavigationVC(rootViewController: vc)
        nav.navigationBar.isHidden = true
        return nav
    }()
    private var highType:BCTabButton.SelectType = .market
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tabBar)
        
        buildHomeUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLogin), name: kNotificationShowLogin, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tabBar.frame = CGRect(x: 0, y: view.height-tabHeight, width: view.width, height: tabHeight)
        let buttonWidth = self.view.width / CGFloat(tabButtons.count)
        for button in tabButtons {
            let index = CGFloat(tabButtons.index(of: button)!)
            button.frame = CGRect(x: index*buttonWidth, y: 0, width: buttonWidth, height: tabHeight)
        }
        studyVC.view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - tabHeight)
        marketVC.view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - tabHeight)
        mineVC.view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - tabHeight)
        pwaVC.view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - tabHeight)
        print(marketVC.view.frame, self.view.frame)
    }
    
    func buildHomeUI() {
        // 创建学习界面导航控制器（带学习控制器）
        let studyButton = self.addTabButton(title: "学习",tabImg: UIImage(named: "xuexi")!,tabImageSel: UIImage(named: "xuexi_blue")!)
        // 创建商城界面导航控制器（带商城控制器）
        let marketButton = self.addTabButton(title: "商城",tabImg: UIImage(named: "shangcheng")!,tabImageSel: UIImage(named: "shangcheng_blue")!)
        // 创建用户信息界面导航控制器（带用户信息控制器）
        let mineButton = self.addTabButton(title: "我的",tabImg: UIImage(named: "wode")!,tabImageSel: UIImage(named: "wode_blue")!)
        let pwaButton = self.addTabButton(title: "cpwa",tabImg: UIImage(named: "wode")!,tabImageSel: UIImage(named: "wode_blue")!)
        
        // 创建优先级最高的控制器
        switch self.highType {
        case .study:
            studyButton.setSelected(true)
            self.lastTabButton = studyButton
            self.lastVC = studyVC
            break
        case .market:
            marketButton.setSelected(true)
            self.lastTabButton = marketButton
            self.lastVC = marketVC
            break
        case .mine:
            mineButton.setSelected(true)
            self.lastTabButton = mineButton
            self.lastVC = mineVC
            break
        case .pwa:
            pwaButton.setSelected(true)
            self.lastTabButton = pwaButton
            self.lastVC = pwaVC
            break
        }
        self.lastVC.navigationBar.isHidden = true
        self.view.addSubview(self.lastVC.view)
        self.addChild(self.lastVC)
    }
    // 创建一个子控制器，（导航控制器）
    func addTabButton(title:String,tabImg:UIImage,tabImageSel:UIImage)-> BCTabButton {
        
        let tabButton = BCTabButton(frame: .zero)
        tabButton.title = title
        tabButton.titleColor = UIColor.gray
        tabButton.selectTitleColor = UIColor.blue
        tabButton.titleImage = tabImg
        tabButton.selectTitleImage = tabImageSel
        tabButton.addTarget(self, action: #selector(clickTabButton(_:)), for: .touchUpInside)
        tabButton.tag = self.tabButtons.count
        let type = BCTabButton.SelectType.init(rawValue: self.tabButtons.count)
        tabButton.selectType = type!
        self.tabButtons.append(tabButton)
        tabBar.addSubview(tabButton)
        return tabButton
    }
    
    @objc func clickTabButton(_ tabButton:BCTabButton) {
        
        if self.lastTabButton == tabButton {
            return
        }
        self.lastTabButton.setSelected(false)
        self.lastVC.view.isHidden = true
        tabButton.setSelected(true)
        self.lastTabButton = tabButton
        
        let type = BCTabButton.SelectType.init(rawValue: tabButton.tag)!
        switch type {
        case .study:
            studyVC.view.isHidden = false
            self.lastVC = studyVC
            if studyVC.parent == nil {
                self.view.addSubview(studyVC.view)
                self.addChild(studyVC)
            }
            break
            
        case .market:
            marketVC.view.isHidden = false
            self.lastVC = marketVC
            if marketVC.parent == nil {
                self.view.addSubview(marketVC.view)
                self.addChild(marketVC)
            }
            break
            
        case .mine:
            mineVC.view.isHidden = false
            self.lastVC = mineVC
            if mineVC.parent == nil {
                self.view.addSubview(mineVC.view)
                self.addChild(mineVC)
            }
            break
        case .pwa:
            pwaVC.view.isHidden = false
            self.lastVC = pwaVC
            if pwaVC.parent == nil {
                self.view.addSubview(pwaVC.view)
                self.addChild(pwaVC)
            }
            break
        }
    }
    
    @objc func showLogin() {
        
        let loginVC = BCLoginVC()
        let loginNav = BCNavigationVC(rootViewController: loginVC)
        self.loginVC = loginNav
        self.present(loginNav, animated: true, completion: nil)
    }
    
}

class BCTabBar: UIView {
    
    private let line:CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        line.frame = CGRect(x: 0, y: 0, width: self.width, height: 1)
    }
    
}

class BCTabButton: UIControl {
    enum SelectType:Int {
        case study = 0
        case market = 1
        case mine = 2
        case pwa = 3
    }
    var selectType:SelectType = .study
    
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
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(titleImageView)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        let imageSize = CGSize(width: 16, height: 16)
        titleImageView.frame = CGRect(origin: CGPoint(x: (self.width-imageSize.width)/2, y: 7), size: imageSize)
        titleLabel.frame = CGRect(x: 0, y: titleImageView.frame.maxY+3, width: self.width, height: self.height - titleImageView.frame.maxY-8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

