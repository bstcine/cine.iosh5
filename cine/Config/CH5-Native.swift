//
//  CH5-Native.swift
//  Cine.iOS
//
//  Created by 李党坤 on 2018/11/7.
//  Copyright © 2018 善恩英语. All rights reserved.
//

import Foundation

/// H5网页相对路径
public enum H5_URL_PATH:String {
    case courseDetail = "/content/course"      // 课程详情
    case market = "/"                          // 商城主页
    case mine = "/user"                        // 用户信息
    case learn = "/learn"                      // 学习首页
    case address = "/address"                  // 个人地址
    case vocabReport = "/quizvocab/reportlist" // 词汇量测试结果
    case quizCourse = "/quiz/kj"               // 课程测试
    
    case login = "/login"                      // 登陆
    case signIn = "/auth/signin"               // 新版登录
    case allTask = "/learn/task"               // 所有任务
    case lword = "/lword"                      // 词汇学习入口
    case wordCard = "/lword/card"              // 卡片式学习
    case wordList = "/lword/list"              // 列表式学习
    case wordQuiz = "/lword/quiz"              // 词汇测试
    case wordCourse = "/lword/course"          // 核心词汇top10000
    case quizVocab = "/quizvocab"              // 词汇量测试
    case quizVocabCard = "/quizvocab/card"     // 词汇量测试
    case player = "/learn/course"              // 课程学习
    case csub = "/widget/pwa"
}

/// H5网页路径
public func H5_URL_STRING(path: H5_URL_PATH) -> String {
    return "\(kBSCineDomain)\(path.rawValue)?\(commonPara)"
}
public func H5_URL_COURSE_DETAIL(courseId:String) -> String {
    return "\(kBSCineDomain)\(H5_URL_PATH.courseDetail.rawValue)?cid=\(courseId)&\(commonPara)"
}


/// 配置 H5回调监听名称
public let kNative = "native"
/// 配置 H5约定执行方法
public enum H5InvokeNativeFunction:String {
    case unknow = "-1"
    case login = "login"
    case share = "share"
    case linkCourseDetail = "course"
    case timeline = "timeline"
    case purchase = "pre_confirm"
    case installWechat = "installed_app_list"
    case quizExit = "quiz_exit"
    case quizInit = "init_quiz_data"
    case addressInit = "address_init_data"
    case addressSave = "address_save"
    case window = "window"
    case sendImg = "send_img"
    case openBrowser = "open_browser"
    case pay = "app_pay"
    case showPayment = "showPayment"
    case paySuccess = "order_pay_success"
    case play = "play"
    case learn = "learn"
}
public enum NativeInvokeH5Func:String {
    case unknow = "-1"
    case share = "outer_share"
    case pagehide = "pagehide"
    case pageshow = "pageshow"
    case test = "android_call_h5_test"
}
public enum windowType:String {
    case requestFullscreen = "requestFullscreen"
    case exitFullscreen = "exitFullscreen"
}


