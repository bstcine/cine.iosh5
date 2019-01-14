//
//  BCPWAVC.swift
//  iPhone
//
//  Created by 李党坤 on 2019/1/11.
//  Copyright © 2019 com.bstcine.www. All rights reserved.
//

import UIKit
import cine

class BCPWAVC: BCWebVC {

    private let pwaButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.setTitle("pwa", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.red
        return button
    }()
    private var pwaCenter:CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(pwaButton)
        
        pwaButton.addTarget(self, action: #selector(showPWA(_:)), for: .touchUpInside)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragPWAButton(_:)))
        pwaButton.addGestureRecognizer(panGesture)
        
        self.urlString = H5_URL_STRING(path: .csub)
    }
    
    @objc func dragPWAButton(_ pan:UIPanGestureRecognizer){
        
        switch pan.state {
        case .changed:
            let point = pan.translation(in: self.view)
            let center = CGPoint(x: self.pwaCenter!.x+point.x, y: self.pwaCenter!.y+point.y)
            self.pwaButton.center = center
            break
        case .ended:
            self.pwaCenter = self.pwaButton.center
            break
        default:
            break
        }
        
    }
    
    @objc func showPWA(_ sender:UIButton) {
        
        self.invokeH5Function(callBack: NativeInvokeH5Func.test.rawValue, para: ["type":"pwa", "user":"ios"])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if self.pwaCenter == nil {
            self.pwaCenter = CGPoint(x: 60, y: 100)
        }
        pwaButton.center = self.pwaCenter!
    }

}
