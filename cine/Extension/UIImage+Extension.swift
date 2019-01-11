//
//  UIImage+Extension.swift
//  iPhone
//
//  Created by bstcine on 2017/10/13.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit

extension UIImage{
    
    /**
     * @ 将图片切成指定的长方形，以中心点扩散
     * @
     */
    public func ex_clipsRectangle(_ size:CGSize)->UIImage{
        
        let targetScale = size.width / size.height
        let imageScale = self.size.width / self.size.height
        
        var cropWidth:CGFloat = 0
        var cropHeight:CGFloat = 0
        
        if targetScale > imageScale {
            
            cropWidth = size.width
            cropHeight = cropWidth / imageScale
            
        } else {
            
            cropHeight = size.height
            cropWidth = cropHeight * imageScale
        }
        
        
        var targetImage = self.ex_croppingSize(targetSize: CGSize(width: cropWidth, height: cropHeight))
        
        let imgRef = targetImage.cgImage!
        let imgWidth = targetImage.size.width * targetImage.scale
        let imgHeight = targetImage.size.height * targetImage.scale
        
        let offsetX = (imgWidth - size.width)/2
        let offsetY = (imgHeight - size.height)/2
        let targetRect = CGRect(x: offsetX, y: offsetY, width: size.width, height: size.height)
        
        let targetRef = imgRef.cropping(to: targetRect)
        if targetRef == nil {
            return self
        }
        
        targetImage = UIImage(cgImage: targetRef!)
        
        return targetImage
    }
    
    /**
     * @ 将图片切为正方形
     * @param  nil:
     * @return 裁切后的正方形图片
     */
    public func ex_clipsSquare()->UIImage{
        
        let imgWidth = self.size.width * self.scale
        let imgHeight = self.size.height * self.scale
        var lengthTarget:CGFloat
        if imgWidth > imgHeight {
            lengthTarget = imgHeight
        }else{
            lengthTarget = imgWidth
        }
        
        return self.ex_clipsRectangle(CGSize(width: lengthTarget, height: lengthTarget))
    }
    /**
     * @ 切圆
     * @param  nil: nil
     * @return 切圆后的图片
     */
    public func ex_clipsCorner()->UIImage{
        let radiousW = self.size.width/2
        let radiousH = self.size.height/2
        var radiousTarget:CGFloat
        if radiousW > radiousH {
            radiousTarget = radiousW
        }else{
            radiousTarget = radiousH
        }
        return self.ex_clipCorners(targetRadious: radiousTarget)
    }
    /**
     * @ 为图片切圆角（高效处理圆角）
     * @ 裁剪圆角，保持原像素
     * @param  trgetRadious:  目标圆角
     * @return 处理后的图片,如果裁剪失败，返回原图
     */
    public func ex_clipCorners(targetRadious:CGFloat) -> UIImage{
        let width = self.size.width * self.scale
        let height = self.size.height * self.scale
        let bezierRect = CGRect(x: 0, y: 0, width: width, height: height)
    UIGraphicsBeginImageContextWithOptions(CGSize(width:width,height:height), false, 1.0)
        UIBezierPath(roundedRect: bezierRect, cornerRadius: targetRadious).addClip()
        self.draw(in: bezierRect)
        let targetImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if targetImage == nil {
            print("裁剪图片为圆形失败")
            return self
        }
        return targetImage!
    }
    
    /**
     * @ 图片压缩到指定尺寸(默认是需要保证图片比例的)
     * @param  targetSize: 需要压缩到的图片尺寸
     * @return 压缩后的图片:如果压缩失败，将返回原图
     */
    public func ex_croppingSize(targetSize:CGSize)->UIImage{
        return self.ex_croppingSize(targetSize: targetSize, isKeepRatio: true)
    }
    
    /**
     * @ 图片压缩到指定尺寸(默认是需要保证图片比例的)
     * @param  targetSize: 需要压缩到的图片尺寸
     * @isKeepRatio: 是否需要保持图片比例
     * @return 压缩后的图片:如果压缩失败，将返回原图
     */
    public func ex_croppingSize(targetSize:CGSize, isKeepRatio:Bool)->UIImage {
        
        var scaleFactor:CGFloat = 0.0
        var scaleWidth = targetSize.width
        var scaleHeight = targetSize.height
        var thumnailPoint = CGPoint.zero
        if (__CGSizeEqualToSize(targetSize, self.size)) {
            
            return self
        }
        
        if isKeepRatio {
            
            let targetWidth = targetSize.width
            let targetHeight = targetSize.height
            let widthFactor = targetWidth/self.size.width
            let heightFactor = targetHeight/self.size.height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            }else{
                scaleFactor = heightFactor
            }
            scaleWidth = self.size.width * scaleFactor
            scaleHeight = self.size.height * scaleFactor
            
            if scaleWidth > scaleHeight {
                thumnailPoint.y = (targetHeight - scaleHeight) * 0.5
            }else if scaleWidth < scaleHeight{
                thumnailPoint.x = (targetWidth - scaleWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        let thumnailRect = CGRect(origin: thumnailPoint, size: CGSize(width: scaleWidth, height: scaleHeight))
        self.draw(in: thumnailRect)
        let targetImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if targetImage == nil {
            print("图片压缩失败")
            return self
        }
        return targetImage!
        
    }
}
