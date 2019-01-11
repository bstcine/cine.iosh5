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
    public var currentInputView:UIView?
    
    let progressView:BCProgressView = BCProgressView.createProgressView()
    
//    public var canLoadH5:Bool {
//        get{
//            if BCUtilLogic.notNetwork() {
//
//                BCShowHUD.showMessage(CCMessage.withoutNetwork)
//                return false
//            }
//            return true
//        }
//    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
//        if pageName == nil {
//            pageName = NSStringFromClass(type(of: self))
//        }
//
//        if isIPad {
//            view.backgroundColor = UIColor.IPad.bgColorSecondary
//        }else {
//            view.backgroundColor = UIColor.iPhoneBgColorPrimary
//        }
        view.backgroundColor = UIColor.white
        if self.navigationController?.viewControllers.first != self {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction))
        }
        
    }
    public var isLoading:Bool = false
    public func showLoading () {
        if isLoading {
            return
        }
        isLoading = true
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.progressView.size)
        }
    }
    
    public func dismissLoading() {
        isLoading = false
        self.progressView.removeFromSuperview()
    }
//
//    public override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        BCBaseLogic.cancelNetUrlTask()
//    }
//
//    func getPageName() -> String {
//        guard var name = self.pageName else{
//            return ""
//        }
//
//        let lastName = name.components(separatedBy: ".").last!
//        if lastName == "BCWebVC" {
//            let webVC = self as! BCWebVC
//            var path = webVC.webView.url?.path ?? ""
//            path = path.replacingOccurrences(of: "/", with: ".")
//            name = "\(name)\(path)"
//        }
//        return name
//    }
//
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let name = getPageName()
//        BCAnalyticsLogic.startLogPageView(pageName: name)
//    }
//
//    public override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        let name = getPageName()
//        BCAnalyticsLogic.stopLogPageView(pageName: name)
//    }
//
//    func showNoRemark(){
//
//        BCShowHUD.showInfo(info: CCMessage.remark)
//    }
//
//    func showStudyAllLesson(sureAction:@escaping ()->Void, cancelAction:@escaping ()->Void){
//
//        BCShowHUD.showInfo(info: CShareMessage.studyAllLesson, sureTitle: "休息一下", cancelTitle: "重新学习", sureAction: sureAction, cancelAction: cancelAction)
//    }
//
//    func dealError(with error:String?) {
//
//        if (error == nil || error == "") {
//
//            if BCUtilLogic.notNetwork() {
//                BCShowHUD.showMessage(CCMessage.withoutNetwork)
//            }
//
//            return
//        }
//
//        if error == "no_login" || error == "token_is_null" {
//
//            self.dealTokenInvalidate()
//
//            return
//        }
//
//        if error == "need_login" {
//
//            self.dealNeedLogin()
//
//            return
//        }
//
//        let errorString = CCAuthError.authError(error: error)
//
//        if errorString == CCMessage.withoutNetwork {
//
//            BCShowHUD.showMessage(errorString)
//            return
//        }
//
//        BCShowHUD.showInfo(info: errorString)
//    }
//    /// 需要登录的功能
//    func dealNeedLogin(){
//
//        guard let tab = UIApplication.shared.keyWindow?.rootViewController as? BCHomeVC else {
//
//            return
//        }
//
//        tab.login()
//    }
    
//    /// token 失效处理，被别的设备登录
//    func dealTokenInvalidate() {
//
//        BCPushMessageLogic.deleteAlias()
//
//        if !BCUserModel.shared.isRealToken {
//
//            BCAppReviewLogic.getToken()
//
//            BCShowHUD.showMessage(CCMessage.withoutNetwork)
//
//            return
//        }
//
//        // 将登录状态置为未登录
//        BCUserModel.shared.isRealToken = true
//        BCUserModel.shared.token = ""
//        BCUserModel.shared.userId = ""
//
//        if BCAppReviewLogic.shared().inReview {
//            BCAppReviewLogic.getToken()
//        }
//
//        guard let tab = UIApplication.shared.keyWindow?.rootViewController as? BCHomeVC else {
//
//            return
//        }
//
//        let errorString = CCAuthError.authError(error: "no_login")
//
//        BCShowHUD.showInfo(info: errorString) {
//
//            tab.login()
//
//        }
//
//    }
//
//    /// 处理报错信息
//    func dealAuthError(with error:String?){
//
//        if error == nil || error == "" {
//            self.dealError(with: error)
//            return
//        }
//
//        let errorString = CCAuthError.authError(error: error)
//
//        if errorString == CCMessage.withoutNetwork {
//
//            BCShowHUD.showMessage(errorString)
//            return
//        }
//
//        BCShowHUD.showInfo(info: errorString)
//    }
    
    @objc public func backAction(){
        
        self.navigationController?.popViewController(animated: true)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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

