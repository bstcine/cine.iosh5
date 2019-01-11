//
//  BCProgressView.swift
//  Cine.iOS
//
//  Created by 李党坤 on 2018/11/9.
//  Copyright © 2018 善恩英语. All rights reserved.
//

import UIKit

public class BCProgressView: UIView {

    private var progressLayer:BCProgressLayer?
    
    public convenience init(frame: CGRect, progressWidth: CGFloat?, progressColor: UIColor?) {
        self.init()
        self.frame = frame
        self.backgroundColor = UIColor.clear
        
        let progressLayer = BCProgressLayer(frame: frame, progressWidth: progressWidth, progressColor: progressColor)
        
        self.layer.addSublayer(progressLayer)
        
        self.progressLayer = progressLayer
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.progressLayer?.frame = self.layer.bounds
    }
    
    public class func createProgressView() -> BCProgressView {
        
        var layerWH:CGFloat
        var lineWidth:CGFloat
        
        if isIPad {
            layerWH = 50
            lineWidth = 2
        }else {
            layerWH = 40
            lineWidth = 2
        }
        return BCProgressView(frame: CGRect(x: 0, y: 0, width: layerWH, height: layerWH), progressWidth: lineWidth, progressColor: UIColor.lightGray)
    }
    
}
