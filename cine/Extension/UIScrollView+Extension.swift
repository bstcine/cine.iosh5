//
//  UIScrollView+Extension.swift
//  iPhone
//
//  Created by bstcine on 2017/11/16.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import Foundation
import MJRefresh

extension UIScrollView {
    
    // 添加下拉刷新方法
    public func refreshHeader(target:Any,action:Selector){
        self.mj_header = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: action)
    }
    
    // 结束刷新动画
    public func endFreshHeader(){
        self.mj_header.endRefreshing()
    }
}
