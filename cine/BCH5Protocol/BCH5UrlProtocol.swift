//
//  BCH5RequestProtocol.swift
//  Cine.iOS
//
//  Created by bstcine on 2017/12/15.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import Foundation

@objc public class BCH5UrlProtocol: URLProtocol {
    
    private var session:URLSession?
    public var currentData:Data = Data.init()
    public var currentResponse:Data = Data.init()
    
    public override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        self.session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    public override class func canInit(with:URLRequest)->Bool {
        if with.httpMethod == "POST" {
            return false
        }
        return URLProtocol.property(forKey: "FilteredKey", in: with) == nil
    }
    
    public override class func canonicalRequest(for request:URLRequest)->URLRequest {
        
        var newRequest = request
        return newRequest
    }
    
    public override func startLoading() {
        
        let newRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "FilteredKey", in: newRequest)
        
        // 对已经存在的资源文件不再获取网络数据
        let isResource = type(of: self).isResourceType(self.request)
        if self.request.httpMethod == "GET" && isResource {
            let saveData = BCH5UrlProtocol.unArchiveCacheFile(request: self.request, isResponse: false) as? Data
            let response = BCH5UrlProtocol.unArchiveCacheFile(request: self.request, isResponse: true) as? URLResponse
            if saveData != nil && response != nil {
                self.sendResponse(response: response!, data: saveData!)
                return
            }
        }
        let netWork = true
            // CRequestManager.networkStatus()
        // 判断网络是否可用
        if netWork {
            let task = self.session!.dataTask(with: newRequest as URLRequest)
            task.resume()
        }else {
            let localSuc = sendLocalData()
            if !localSuc {
                let task = self.session!.dataTask(with: newRequest as URLRequest)
                task.resume()
            }
        }
        
    }
    
    public override func stopLoading() {
        
        self.session?.invalidateAndCancel()
        self.session = nil
    }
    
    public override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }
    
    func sendLocalData() -> Bool {
        
        guard let response = BCH5UrlProtocol.unArchiveCacheFile(request: self.request, isResponse: true) as? URLResponse else {
            print("没有response")
            return false
        }
        guard let saveData = BCH5UrlProtocol.unArchiveCacheFile(request: self.request, isResponse: false) as? Data else {
            print("文件没有数据:")
            return false
        }
        
        self.sendResponse(response: response, data: saveData)
        
        return true
    }
    
    /// 本地资源嵌入
    public func sendResponse(response:URLResponse,data:Data) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        self.client?.urlProtocol(self, didLoad: data)
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
}

extension BCH5UrlProtocol:URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        // 将URLResponse返回到客户端
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
        
        // 判断是否为pwa缓存数据
        if dataTask.currentRequest!.httpMethod == "GET" || dataTask.currentRequest!.url!.absoluteString.contains(kBSCineDomain) {
            let _ = BCH5UrlProtocol.archiveCacheFile(object: response, request:dataTask.currentRequest!, isResponse: true)
        }
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.currentData.append(data)
        self.client?.urlProtocol(self, didLoad: data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        let isCanSave = task.currentRequest!.httpMethod == "GET" || task.currentRequest!.url!.absoluteString.contains(kBSCineDomain)
        if self.currentData.count > 0 && isCanSave {
            // 缓存到本地沙盒中
            let _ = BCH5UrlProtocol.archiveCacheFile(object: self.currentData, request: task.currentRequest!, isResponse: false)
        }
        if error != nil {
            // 获取本地缓存
            let currentData = BCH5UrlProtocol.unArchiveCacheFile(request: task.currentRequest!, isResponse: false) as? Data
            if currentData != nil && currentData!.count > 0 {
                self.client?.urlProtocol(self, didLoad: currentData!)
            }else {
                self.client?.urlProtocol(self, didFailWithError: error!)
            }
        }
        // 结束客户端（WKWebView）加载
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
}

