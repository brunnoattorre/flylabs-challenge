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
    
    var moved = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Create and initialize a tap gesture
        let tapRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleTap:"))
           
        view.addGestureRecognizer(tapRecognizer);
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moved = true
    }
    
   
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(moved){
            (self.player as? AVQueuePlayer)?.advanceToNextItem()
        }else{
            (self.player as? AVQueuePlayer)?.pause()
        }
        moved = false
    }
    @IBAction func handleTap(sender: AnyObject) {
        self.player?.pause()

    }
}