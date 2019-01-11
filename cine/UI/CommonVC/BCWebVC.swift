//
//  BCWebVC.swift
//  iPhone
//
//  Created by bstcine on 2017/11/24.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit
import WebKit

extension WKProcessPool {
    public static let share:WKProcessPool = WKProcessPool.init()
}

open class BCWebVC: BCBaseVC {
    
    private weak var container:WKUserContentController?
    
    var callBack:String?
    var currentMethod:H5InvokeNativeFunction?
    var currentData:[String:Any]?
    
    var beginTime:Date?
    
    var isPlayingScreen:Bool = false
    private var isPaid:Bool = false
    
    public var webView:WKWebView = {
        
        let config = WKWebViewConfiguration()
        config.processPool = WKProcessPool.share
        config.userContentController = WKUserContentController()
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.preferences.minimumFontSize = 8
        
        config.allowsInlineMediaPlayback = true
        config.requiresUserActionForMediaPlayback = false
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.configuration.allowsInlineMediaPlayback = true
        
        return webView
    }()
    
    public var htmlString:String = "" {
        
        didSet{
            
            let preHTML = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
            
            self.webView.loadHTMLString(
                preHTML+htmlString, baseURL: URL.init(string: "https://www.bstcine.com"))
            
            self.showLoading()
        }
    }
    
    public var isNeedHandler:Bool = false
    
    public var urlString:String = "" {
        didSet{
            self.reloadWebView()
        }
    }
    
    public func reloadWebView() {
        // 判断网络状态
//        if !isIPad && BCUtilLogic.notNetwork() {
//
//            BCShowHUD.showMessage("网络异常")
//
//            return
//        }
        
        guard let url = URL.init(string: urlString) else{
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 120)
        
        self.webView.load(request)
        
        self.beginTime = Date()
        
        self.showLoading()
    }
    
    public var isCanRefresh:Bool = false {
        didSet{
//            if isCanRefresh {
//                self.addFresh()
//            }else {
//                self.removeFresh()
//            }
        }
    }
    
    public var hideCount:UInt = 0
    
    public var startTime:Date = Date()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        container = webView.configuration.userContentController
        
        container?.add(self, name: kNative)
        
//        if isCanRefresh && !self.isHadFresh {
//            self.addFresh()
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(webViewDisappear), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(webViewAppear), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var topInstance = kNavigationBarHeight
        if self.navigationController == nil || self.navigationController!.navigationBar.isHidden {
            topInstance = 0
        }
        webView.frame = CGRect(x: 0, y: topInstance, width: self.view.width, height: self.view.height - topInstance)
    }
    
    override public func backAction() {
        
        container?.removeScriptMessageHandler(forName: kNative)
        if isPaid {
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            super.backAction()
        }
    }
    
}

extension BCWebVC:WKNavigationDelegate, WKUIDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismissLoading()
        
        let getHref = "document.title"
        
        webView.evaluateJavaScript(getHref) { (title, error) in
            
            guard let newTitle = title as? String else {
                return
            }
            if newTitle == "" {
                return
            }
            self.navigationItem.title = newTitle
        }
        
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let policy = self.getPolicy(url: navigationAction.request.url!)
        print(policy, self.urlString)
        if policy == self.urlString {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        
        let newVC = BCWebVC()
        newVC.urlString = policy
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
//    public func decisionHandlerAllow(url: URL) -> Bool {
//
//        let absoluteString = url.absoluteString.replacingOccurrences(of: "/?", with: "?")
//        let inputString = self.urlString.replacingOccurrences(of: "/?", with: "?")
//
//        let absolutePath = absoluteString.split(separator: "?").first ?? ""
//        let inputPath = inputString.split(separator: "?").first ?? ""
//
//        let isContainAllow = absoluteString.contains("token") || absoluteString.contains("about:blank") || !absoluteString.contains("bstcine")
//        let isAllow = absolutePath == inputPath && url.path != "/login" && isContainAllow
//
//        return isAllow
//    }
//
    public func getPolicy(url:URL) -> String {
        let policy = url.absoluteString

        if policy.contains("token") && policy.contains("sitecode") {
            return policy
        }

        if policy.contains("?") {
            return "\(policy)&\(commonPara)"
        }

        return "\(policy)?\(commonPara)"

    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.dismissLoading()
//        if error._code == NSURLErrorCancelled {
//            return
//        }else if error._code == NSURLErrorTimedOut {
//            self.dealError(with: "network_timeout")
//        }else {
//            self.dealError(with: "system_error")
//        }
    }
//
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

        self.dismissLoading()
//        if error._code == NSURLErrorCancelled {
//            return
//        }else if error._code == NSURLErrorNotConnectedToInternet {
//            return
//        } else if error._code == NSURLErrorTimedOut {
//            self.dealError(with: "network_timeout")
//        }else {
//            self.dealError(with: "system_error")
//        }
    }
//
//    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//
//        BCShowHUD.showInfo(info: message) {
//
//            completionHandler()
//
//        }
//    }
    
//    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
//
//        let completeAny = completionHandler as Any
//
//        let completeAlert = completeAny as? (()->Void)
//
//        let completePane = completeAny as? ((Bool)->Void)
//
//        BCShowHUD.showInfo(info: message, sureAction: {
//            completeAlert?()
//            completePane?(true)
//        }) {
//            completeAlert?()
//            completePane?(false)
//        }
//
//    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        alertVC.addTextField { (text) in
            text.becomeFirstResponder()
        }
        
        let action = UIAlertAction(title: "queding", style: UIAlertAction.Style.default) { (action) in
            let text = alertVC.textFields?.first?.text
            completionHandler(text)
        }

        alertVC.addAction(action)

        present(alertVC, animated: true, completion: nil)
    }
}

extension BCWebVC:WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // 判断是否存在正在执行的方法，防止同时执行多个方法
        if self.currentMethod != nil {
            return
        }
        // 获取json 字符串，解析出字典
        guard let bodyString = message.body as? String else {
            return
        }
        
        guard let data = bodyString.data(using: .utf8) else {
            return
        }
        
        let body = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        guard let messageBody = body as? [String:Any] else {
            return
        }
        // 获取方法参数
        guard let methodString = messageBody["method"] as? String else {
            return
        }
        // 生成方法
        guard let method = H5InvokeNativeFunction.init(rawValue: methodString) else {
            print(methodString)
            return
        }
        
        // 标记正在执行的方法和方法的回调
        self.currentMethod = method
        self.callBack = messageBody["callback"] as? String
        
        self.currentData = messageBody["data"] as? [String:Any]
        
        switch method {
            
        case .login:
            
            self.H5_NativeLogin()
            
            break
            
        case .linkCourseDetail:
            
            self.showCourseDetail()
            
            break
            
        case .share:
            
            self.gotoShare(shareDict: self.currentData)
            
            break
            
        case .timeline:
            
            guard let type = self.currentData?["type"] as? String else {
                self.removeH5Method()
                return
            }
            
            self.calcuteLoadTime()
            
            break
            
        case .installWechat:
            
            self.setWechatClientStatus()
            
            break
            
        case .window:
            
            guard let data = messageBody["data"] as? [String:Any] else {
                break
            }
            
            guard let event = data["event"] as? String else {
                return
            }
            
            self.dealWindowEvent(event: event)
            
            break
            
        case .sendImg:
            
            guard let data = messageBody["data"] as? [String:Any] else {
                break
            }
            
            sendImage(data: data)
            
            break
            
        case .openBrowser:
            
            guard let data = messageBody["data"] as? [String:Any] else {
                break
            }
            
            openBrowser(data: data)
            
            break
            
        case .pay:
            guard let data = messageBody["data"] as? [String:Any] else {
                break
            }
            let payType = data["pay_type"] as? String ?? ""
            let orderId = data["order_id"] as? String ?? ""
            self.gotoPay(orderId: orderId, payType: payType)
            break
            
        case .paySuccess:
//            NotificationCenter.default.post(name: kNotificationRefreshAll, object: nil)
            self.isPaid = true
            self.removeH5Method()
            break
            
        case .play:
            guard let data = messageBody["data"] as? [String:Any] else {
                self.removeH5Method()
                break
            }
            let courseId = data["course_id"] as? String ?? ""
            let lessonId = data["lesson_id"] as? String ?? ""
            self.gotoPlay(courseId: courseId, lessonId: lessonId)
            break
            
        case .learn:
            
            guard let data = messageBody["data"] as? [String:Any] else {
                self.removeH5Method()
                break
            }
            let courseId = data["course_id"] as? String ?? ""
            let lessonId = data["last_lesson_id"] as? String ?? ""
            self.gotoLearn(courseId: courseId, lessonId: lessonId)
            
            break
            
        default:
            self.removeH5Method()
            
            break
        }
        
    }
    
    @objc func gotoPlay(courseId:String, lessonId:String) {
        self.removeH5Method()
    }
    
    @objc func gotoLearn(courseId:String, lessonId:String) {
        self.removeH5Method()
    }
    
    func gotoPay(orderId:String, payType:String) {
        let callBack = self.callBack
        self.removeH5Method()
        if orderId == "" || payType == "" {
            return
        }
        weak var weakSelf:BCWebVC? = self
        self.showLoading()
        if payType == "1" {
//            BCPurchaseLogic.aliPay(orderId: orderId, success: { (isSuc) in
//
//                weakSelf?.dismissLoading()
//                weakSelf?.invokeH5CallBack(callBack: callBack, para: [String : Any]())
//
//            }) { (cError) in
//                weakSelf?.dismissLoading()
//                weakSelf?.invokeH5CallBack(callBack: callBack, para: [String : Any]())
//                weakSelf?.dealError(with: cError?.except_case_desc)
//            }
        }else if payType == "3" {
//            BCPurchaseLogic.wechatPay(orderId: orderId, success: { (status) in
//                weakSelf?.dismissLoading()
//                weakSelf?.invokeH5CallBack(callBack: callBack, para: [String : Any]())
//            }) { (cError) in
//                weakSelf?.dismissLoading()
//                weakSelf?.invokeH5CallBack(callBack: callBack, para: [String : Any]())
//                weakSelf?.dealError(with: cError?.except_case_desc)
//            }
        }
    }
    
    func dealWindowEvent(event:String){
        
        self.removeH5Method()
        
        guard let type = windowType.init(rawValue: event) else {
            return
        }
        
        switch type {
        case .requestFullscreen:
            
            self.playerRequestFullScreen()
            
            break
            
        case .exitFullscreen:
            
            self.playerExitFullScreen()
            
            break
        }
    }
    
}

extension BCWebVC {
    
    @objc public func openBrowser(data: [String:Any]) {
        self.removeH5Method()
    }
    
    @objc public func sendImage(data:[String:Any]) {
        self.removeH5Method()
    }
    
    /// 界面隐藏
    @objc func webViewDisappear(){
        self.hideCount += 1
        self.webView.evaluateJavaScript("window._cine_listener.emit('pagehide',{})", completionHandler: nil)
    }
    
    /// 界面出现
    @objc func webViewAppear(){
        
        if self.hideCount == 0 {
            return
        }
        self.webView.evaluateJavaScript("window._cine_listener.emit('pageshow',{})", completionHandler: nil)
    }
    
    /// 详情页试听播放，开启全屏模式
    func playerRequestFullScreen(){
        
//        guard let courseVC = self as? BCCourseDetailVC else {
//            return
//        }
//
//        isPlayingScreen = true
//
//        UIDevice.current.setValue(
//            UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
//
//        UIViewController.attemptRotationToDeviceOrientation()
//
//        courseVC.backControl.isHidden = true
//        courseVC.backImageView.isHidden = true
//        courseVC.shareControl.isHidden = true
//        courseVC.shareImageView.isHidden = true
//        courseVC.topView.isHidden = true
//
//        if !kIsVerb_iPhoneX {
//            return
//        }
//
//        self.webView.snp.remakeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
    }
    /// 详情页试听结束，关闭全屏模式
    func playerExitFullScreen(){
        
//        guard let courseVC = self as? BCCourseDetailVC else {
//            return
//        }
//
//        isPlayingScreen = false
//
//        UIDevice.current.setValue(
//            UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//        UIViewController.attemptRotationToDeviceOrientation()
//
//        courseVC.backControl.isHidden = false
//        courseVC.backImageView.isHidden = false
//        courseVC.shareControl.isHidden = false
//        courseVC.shareImageView.isHidden = false
//        courseVC.topView.isHidden = false
//
//        if !kIsVerb_iPhoneX {
//            return
//        }
//
//        self.webView.snp.remakeConstraints { (make) in
//            make.top.equalTo(self.view).offset(topSafeArea)
//            make.left.right.bottom.equalTo(self.view)
//        }
    }
    
    /// 结束回调，本次任务结束
    func removeH5Method(){
        
        self.currentMethod = nil
        self.currentData = nil
        self.callBack = nil
        
    }
    
    /// H5加载时间计算
    private func calcuteLoadTime(){
        
        self.removeH5Method()
        
        self.dismissLoading()
    }
    /// 发送客户端是否存在的消息
    public func setWechatClientStatus(){
        
        let wechatInstall = WXApiManager.isWXAppInstalled() ? 1 : 0

        self.currentMethod = nil

        self.invokeH5CallBack(para: ["wechat" : wechatInstall])

        if wechatInstall == 0 {

            self.dismissLoading()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    /// H5调用本地分享方法
    public func gotoShare(shareDict:[String:Any]?) {
        
        self.dismissLoading()

        OperationQueue().addOperation {
            guard let shareData = shareDict else {
                self.removeH5Method()
                self.dismissLoading()
                return
            }
            
            guard let _ = shareData["sharelog_id"] as? String else {
                self.removeH5Method()
                self.dismissLoading()
                return
            }
            
            let share_imgUrl = shareData["imgUrl"] as? String ?? ""
            let share_title = shareData["title"] as? String ?? ""
            let share_desc = shareData["desc"] as? String ?? ""
            let share_link = shareData["link"] as? String ?? ""
            
            let callBack = self.callBack
            
            self.callBack = nil
            self.currentMethod = nil
            
            let imageUrl = URL.init(string: share_imgUrl)
            
            var image:UIImage!
            
            if imageUrl != nil {
                
                let imageData = try? Data.init(contentsOf: imageUrl!)
                
                if imageData != nil {
                    image = UIImage(data: imageData!)
                    image = image.wechatShare
                }
            }
            
            if image == nil {
                image = UIImage(named: "pic_default")!
            }
            
            OperationQueue.main.addOperation {
                
                weak var weakSelf:BCWebVC? = self
                
                WXApiManager.sharedFriend(withTitle: share_title, description: share_desc, image: image, urlString: share_link) { (result, isSuc) in
                    let shareResutl = isSuc ? 1 : 0
                    
                    weakSelf?.invokeH5CallBack(callBack: callBack, para: ["shareSuccess":shareResutl])
                }
            }
            
        }
    }
    
    /// H5调用本地课程详情
    public func showCourseDetail(){
        
        guard let courseData = self.currentData else {
            self.removeH5Method()
            return
        }

        guard let courseId = courseData["course_id"] as? String else {
            self.removeH5Method()
            return
        }
        
        let courseUrl = H5_URL_COURSE_DETAIL(courseId: courseId)
        
        let webVC = BCWebVC()
        webVC.urlString = courseUrl
        
        webVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(webVC, animated: true)
        
        self.removeH5Method()
    }
    
    @objc public func NativeLogin() {
        self.removeH5Method()
        
//        let loginVC = BCLoginVC()
//
//        weak var weakSelf:BCWebVC? = self
//
//        loginVC.loginComplete = {(isSuc) in
//
//            if isSuc == .success {
//                weakSelf?.freshWebView()
//            }else if isSuc == .cancel {
//                weakSelf?.navigationController?.popViewController(animated: false)
//            }
//        }
//        let loginNav = BCNavigationVC(rootViewController: loginVC)
//        self.present(loginNav, animated: true, completion: nil)
    }
    
    /// H5调用本地登录
    public func H5_NativeLogin() {
        
//        guard let tab = UIApplication.shared.keyWindow?.rootViewController as? BCHomeVC else {
//
//            return
//        }
//
//        weak var weakSelf:BCWebVC? = self
//
//        let callBack = self.callBack
//
//        self.callBack = nil
//        self.currentMethod = nil
//
//        tab.login { (isSuc) in
//
//            if !isSuc {
//                weakSelf?.removeH5Method()
//                return
//            }
//
//            let token = BCUserModel.shared.token
//
//            let para = ["token":token]
//            weakSelf?.invokeH5CallBack(callBack: callBack, para: para)
//        }
    }
    
    /// 调用H5回调方法
    public func invokeH5CallBack(para:[String:Any]) {
        
        self.invokeH5CallBack(callBack: self.callBack, para: para)
    }
    
    public func invokeH5CallBack(para:[String:Any], isJson:Bool) {
        
        self.invokeH5CallBack(callBack: self.callBack, para: para, isJson: isJson)
        
    }
    
    public func invokeH5CallBack(callBack:String? , para:[String:Any]) {
        
        self.invokeH5CallBack(callBack: callBack, para: para, isJson: false)
    }
    
    public func invokeH5CallBack(callBack:String? , para:[String:Any], isJson:Bool) {
        
        if callBack == nil {
            return
        }
        
        // 将字典转换为json 字符串
        let paraData = try! JSONSerialization.data(withJSONObject: para, options: .prettyPrinted)
        let paraString = String.init(data: paraData, encoding: .utf8)!
        
        self.invokeH5CallBack(callBack: callBack, paraString: paraString)
        
    }
    
    public func invokeH5CallBack(callBack:String? , paraString:String){
        
        self.invokeH5CallBack(callBack: callBack, paraString: paraString, isJson: true)
    }
    
    public func invokeH5CallBack(callBack:String? , paraString:String, isJson:Bool){
        
        var realString = paraString
        
        if !isJson {
            // 去掉其中的空格和换行符
            realString = realString.exNS.replacingOccurrences(of: " ", with: "")
            realString = realString.exNS.replacingOccurrences(of: "\n", with: "")
        }
        
        self.invokeH5CallBack(callBack: callBack, realString: realString, isJson: isJson)
        
    }
    
    public func invokeH5CallBack(callBack:String? , realString:String) {
        
        self.invokeH5CallBack(callBack: callBack, realString: realString, isJson: false)
        
    }
    
    public func invokeH5CallBack(callBack:String? , realString:String, isJson:Bool) {
        
        var result:String
        
        if isJson {
            // 生成 javaScript 运行代码
            result = String.init(format: "window._cine_listener.emit('%@',%@)", callBack!, realString)
        }else {
            result = String.init(format: "window._cine_listener.emit('%@','%@')", callBack!, realString)
        }
        print("调起js方法: ",result)
        // 执行 javaScript 代码
        self.webView.evaluateJavaScript(result, completionHandler: nil)
        self.webView.evaluateJavaScript(result) { (result, error) in
            
            if error == nil {
                print("执行回调成功")
            }else {
                print(error?.localizedDescription ?? "执行回调失败")
            }
            
        }
        self.removeH5Method()
        
    }
    
}

