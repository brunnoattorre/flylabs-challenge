//
//  DownloadButton.swift
//  ZDT-DownloadVideo
//
//  Created by Sztanyi Szabolcs on 11/04/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

class DownloadButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.whiteColor().CGColor
        
        layer.cornerRadius = 8.0
        
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
    }
    
}
