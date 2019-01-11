//
//  UIImage+Wechat.swift
//  iPhone
//
//  Created by bstcine on 2017/11/30.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    
    /// 生成二维码
    public class func qrcodeImage(url:String)->UIImage?{
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setDefaults()
        
        let data = url.data(using: .utf8)
        
        filter?.setValue(data, forKey: "inputMessage")
        
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let image = filter?.outputImage else {
            return nil
        }
        
        return self.dealQrcode(image, size: qRcodeWH)
    }
    /// 处理为高清二维码
    private class func dealQrcode(_ origin:CIImage, size:CGFloat) -> UIImage {
        
        let extent: CGRect = origin.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(origin, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        
        bitmapRef.scaleBy(x: scale, y: scale)
        
        bitmapRef.draw(bitmapImage, in: extent)
        
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
    
    public var wechatShare:UIImage {
        
        var sourceImage = self
        
        guard var imageData = sourceImage.jpegData(compressionQuality: 0.5) else {
            return self
        }
        
        let targetCount:Int = 30 * 1024
        
        while imageData.count > targetCount {
            
            let width = sourceImage.size.width / 2
            let height = sourceImage.size.height / 2
            
            let targetSize = CGSize(width: width, height: height)
            
            sourceImage = sourceImage.ex_croppingSize(targetSize: targetSize)
            
            imageData = sourceImage.jpegData(compressionQuality: 0.5)!
            
        }
        
        let targetImage = UIImage.init(data: imageData)
        
        return targetImage!
        
    }
    
}
