//
//  TriangeView.swift
//  Beloved
//
//  Created by Anas Belkhadir on 04/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//


import UIKit

class TriangeView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func drawRect(rect: CGRect) {
        
        let ctx : CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, (CGRectGetMaxX(rect)/2.0), CGRectGetMinY(rect))
        CGContextClosePath(ctx)
        
        CGContextSetRGBFillColor(ctx, 1.0, 0.5, 0.0, 0.60);
        CGContextFillPath(ctx);
    }
}