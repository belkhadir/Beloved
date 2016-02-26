//
//  CustomContainerSingInView.swift
//  Beloved
//
//  Created by Anas Belkhadir on 26/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit


class CustomContainerSingInView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }

    func configureUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
    }

}


