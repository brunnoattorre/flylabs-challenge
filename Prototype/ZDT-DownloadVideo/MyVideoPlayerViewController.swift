//
//  MyVideoPlayerViewController.swift
//  Prototype
//
//  Created by Brunno Attorre on 10/12/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class MyVideoPlayerViewController: AVPlayerViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Create and initialize a tap gesture
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
           
        tapRecognizer.numberOfTapsRequired = 1;
        
        view.addGestureRecognizer(tapRecognizer);
    }
 
    @IBAction func handleTap(sender: AnyObject) {
        self.player?.pause()

    }
}