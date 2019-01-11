//
//  BCH5URLProtocol+CacheFile.swift
//  H5Test
//
//  Created by 李党坤 on 2018/7/17.
//  Copyright © 2018年 com.bstcine.www. All rights reserved.
//

import Foundation

/// 存放缓存数据的目录地址，注册时生成该目录，拦截时检测资源文件。如果目录中已存在，则直接使用目录中的资源，否则下载后再使用，并将下载后的资源放置到该目录中
fileprivate let LDK_H5_CachePath:String = NSTemporaryDirectory() + "LDK_H5_URLPROTOCOL_CachePath"
fileprivate let IMAGETYPES = ["jpg","jpeg","png"]
fileprivate let RESOURCETYPES = IMAGETYPES + ["css","js"]
fileprivate let CACHELIMITTYPES = ["cnzz"]

public extension BCH5UrlProtocol {

    /// 初始化缓存路径
    public class func initCachePath() -> String? {
        if !FileManager.default.fileExists(atPath: LDK_H5_CachePath) {
            do{
                try FileManager.default.createDirectory(atPath: LDK_H5_CachePath, withIntermediateDirectories: true, attributes: nil)
                return LDK_H5_CachePath
            }catch{
                return nil
            }
        }
        return LDK_H5_CachePath
    }
    
    /// 清理缓存文件
    public class func clearCacheFiles() -> Bool {
        if FileManager.default.fileExists(atPath: LDK_H5_CachePath) {
            do{
                try FileManager.default.removeItem(atPath: LDK_H5_CachePath)
                return true
            }catch{
                return false
            }
        }
        return true
    }
    
    /// 判断缓存文件是否存在
    public class func cacheFileExists(request: URLRequest, isResponse:Bool) -> Bool {
        let fileName = getCacheFileName(request: request, isResponse: isResponse)
        return FileManager.default.fileExists(atPath:fileName)
    }
    
    /// 归档缓存文件(DATA文件, URLRESPONSE文件)
    public class func archiveCacheFile(object:Any, request: URLRequest, isResponse:Bool) -> Bool {
        for limitType in CACHELIMITTYPES {
            if request.url!.absoluteString.contains(limitType) {
                return false
            }
        }
        let fileName = getCacheFileName(request: request, isResponse: isResponse)
        return NSKeyedArchiver.archiveRootObject(object, toFile: fileName)
    }
    
    /// 解档缓存文件
    public class func unArchiveCacheFile(request: URLRequest, isResponse:Bool) -> Any? {
        let fileName = getCacheFileName(request: request, isResponse: isResponse)
        return NSKeyedUnarchiver.unarchiveObject(withFile: fileName)
    }
    
    /// 判断该请求是否为资源文件
    public class func isResourceType(_ request:URLRequest) -> Bool {
        let pathExtension = request.url!.pathExtension
        let isContain = RESOURCETYPES.contains(pathExtension)
        return isContain
    }
    
    /// 根据url生成缓存文件名称
    private class func getCacheFileName(request: URLRequest, isResponse:Bool) -> String {
        // 获取加盐辨别值（根据请求的范围）
        let salt = request.allHTTPHeaderFields?["Range"]
        var requestName:String
        let params = request.url!.params
        if params == nil || params!.count == 0 || params!["token"] == "" {
            requestName = request.url!.absoluteString
        }else {
            let baseString = request.url!.absoluteString.split(separator: "?").first!
            requestName = String(baseString)
            for (key,value) in params! {
                if (key == "token" || key == "sitecode") {
                    continue
                }
                if requestName.contains("?") {
                    requestName = "\(requestName)&\(key)=\(value)"
                }else {
                    requestName = "\(requestName)?\(key)=\(value)"
                }
            }
        }
        
        let resourceName = "\(requestName)_\(salt ?? "")"
        var fileName = (resourceName).MD5String
        if isResponse {
            fileName = "response_\(fileName)"
        }
        return LDK_H5_CachePath + "/\(fileName)"
    }
}
