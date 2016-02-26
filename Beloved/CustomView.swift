//
//  CustomView.swift
//  Beloved
//
//  Created by Anas Belkhadir on 26/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit


class CustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateLayerFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateLayerFrame()
    }
    func updateLayerFrame() {
        alpha = 0.85
        layer.borderColor = UIColor.grayColor().CGColor
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).CGColor
        layer.shadowOffset = CGSizeMake(3.0, 3.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 3.0
    }
    


    
    
}
