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
    var paused = false
    var numberOfItems = 2
    var i = 0

    
    override func viewDidLoad(){
        super.viewDidLoad()
        numberOfItems = ((self.player as? AVQueuePlayer)?.items().count)!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player)
        i = 0
        
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        if(i >= numberOfItems){
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if(paused){
            (self.player as? AVQueuePlayer)?.play()
            paused = false
        }else{
            (self.player as? AVQueuePlayer)?.pause()
            paused = true
        }
    }
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moved = true
    }
    
   
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(moved){
            i++
            (self.player as? AVQueuePlayer)?.advanceToNextItem()
            if(i>=numberOfItems){
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
        moved = false
    }
    
    
}