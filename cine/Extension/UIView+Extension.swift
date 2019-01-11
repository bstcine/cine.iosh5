//
//  UIView+Extension.swift
//  iPhone
//
//  Created by bstcine on 2017/10/20.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit

extension UIView {
    
    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    public var centerX: CGFloat{
        get{
            return self.center.x
        }
        set{
            var point = self.center
            point.x = newValue
            self.center = point
        }
    }
    public var centerY: CGFloat{
        get{
            return self.center.y
        }
        set{
            var point = self.center
            point.y = newValue
            self.center = point
        }
    }
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            var rect = self.frame
            rect.origin = newValue
            self.frame = rect
        }
    }
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            var rect = self.frame;
            rect.size = newValue
            self.frame = rect
        }
    }
}
