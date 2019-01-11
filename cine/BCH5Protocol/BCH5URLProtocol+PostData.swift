//
//  BCH5URLProtocol+PostData.swift
//  H5Test
//
//  Created by 李党坤 on 2018/7/17.
//  Copyright © 2018年 com.bstcine.www. All rights reserved.
//

/// 待用POST请求请求体列表，包含一个baseBody和对应的apiBody，由使用者定义，如果api对应的body为空，将为POST请求的body设置一个["data":[]]属性
fileprivate var _postData:[String:[String:Any]]?

public extension BCH5UrlProtocol {
    
    /// 通过该属性操作_postData,给使用者更加明确的接口意义
    public class var postData:[String:[String:Any]] {
        get{
            return _postData ?? [String:[String:Any]]()
        }
    }
    /// 新增一条请求体数据
    public class func addPostData(urlString: String, value: [String:Any]){
        if _postData == nil {
            _postData = [String:[String:Any]]()
        }
        _postData!.updateValue(value, forKey: urlString)
    }
    /// 新增请求体data字段数据
    public class func addPostDataKey(urlString:String, paramKey:String, key:String, value:Any) {
        if _postData == nil {
            return
        }
        var postValue = _postData![urlString] ?? [String:Any]()
        var paramValue = postValue[paramKey] as? [String:Any] ?? [String:Any]()
        paramValue.updateValue(value, forKey: key)
        postValue.updateValue(paramValue, forKey: paramKey)
        _postData!.updateValue(postValue, forKey: urlString)
        print("添加成功")
    }
    /// 更新一条请求体数据
    public class func updatePostData(urlString: String, value:[String:Any]){
        self.addPostData(urlString: urlString, value: value)
    }
    /// 删除一条请求体数据
    public class func deletePostData(urlString: String){
        if _postData == nil {
            return
        }
        _postData?.removeValue(forKey: urlString);
    }
    /// 新增一批请求体数据
    public class func addPostDatas(postDatas:[String:[String:Any]]){
        if _postData == nil {
            _postData = postDatas
            return
        }
        for (key,value) in postDatas {
            _postData?.updateValue(value, forKey: key)
        }
    }
    /// 更新一批请求体数据
    public class func updatePostDatas(postDatas:[String:[String:Any]]){
        addPostDatas(postDatas: postDatas)
    }
    /// 删除一批请求体数据
    public class func deletePostDatas(keys:[String]){
        if _postData == nil {
            return
        }
        for key in keys {
            _postData!.removeValue(forKey: key)
        }
    }
    /// 清除请求体数据
    public class func clearPostData(){
        _postData = nil
    }
    
}
