//
//  BCProgressLayer.swift
//  Cine.iOS
//
//  Created by 李党坤 on 2018/11/8.
//  Copyright © 2018 善恩英语. All rights reserved.
//

import Foundation

class BCProgressLayer: CAShapeLayer {
    
    private var progressWidth:CGFloat = 2
    private var progressColor:UIColor = UIColor.lightGray
    
    convenience init(frame: CGRect, progressWidth:CGFloat?, progressColor:UIColor?) {
        self.init()
        
        self.frame = frame
        self.backgroundColor = UIColor.clear.cgColor
        
        if progressWidth != nil {
            self.progressWidth = progressWidth!
        }
        if progressColor != nil {
            self.progressColor = progressColor!
        }
        
        self.creatProgress()
    }
    
    override func layoutSublayers() {
        
        guard let layer = self.superlayer else {
            return
        }
        
        self.frame = CGRect(x: (layer.frame.width - self.frame.width) / 2, y: (layer.frame.height - self.frame.height) / 2, width: self.frame.width, height: self.frame.height)
    }
    
    private func creatProgress() {
        
        if self.frame.width == 0 || self.frame.height == 0 {
            return
        }
        
        // 创建圆环容器
        let WH:CGFloat = self.frame.width
        let lineW:CGFloat = progressWidth
        
        //创建一个圆环
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x:WH/2,y:WH/2), radius: WH/2-lineW, startAngle: CGFloat.pi * 0.6, endAngle: CGFloat.pi * 2.4, clockwise: true)
        
        self.path = bezierPath.cgPath
        self.lineWidth = progressWidth
        self.lineCap = .round
        self.lineJoin = .round
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = progressColor.cgColor
        
        // 添加旋转动画
        let rotationAnimation2 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation2.fromValue = NSNumber(value: 0)
        rotationAnimation2.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation2.repeatCount = MAXFLOAT
        rotationAnimation2.duration = 1
        rotationAnimation2.isRemovedOnCompletion = false
        self.add(rotationAnimation2, forKey: nil)
    }
    
}
