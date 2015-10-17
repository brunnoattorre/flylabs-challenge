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
    var numberOfItens = 2
    var i = 0

    
    override func viewDidLoad(){
        super.viewDidLoad()
        i = 0
        
    }
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moved = true
    }
    
   
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(moved){
            i++
            (self.player as? AVQueuePlayer)?.advanceToNextItem()
            if(i>=numberOfItens){
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }else{
            (self.player as? AVQueuePlayer)?.pause()
        }
        moved = false
    }
    
    
}