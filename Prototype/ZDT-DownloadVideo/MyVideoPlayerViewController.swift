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
    var previousX = CGFloat(0)
    var paused = false
    var numberOfItems = 2
    var i = 0
    var groupId: Int!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        numberOfItems = ((self.player as? FlyLabsPlayer)?.items().count)!
        (self.player as? FlyLabsPlayer)?.viewController = self
        (self.player as? FlyLabsPlayer)?.groupId = self.groupId
        i = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(!paused){
            self.player?.pause()
        }
        super.viewDidDisappear(animated)
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
        }
        moved = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addNewVideoToFlap") {
            let ngvc = segue.destinationViewController as! NewGroupMembersViewController
            ngvc.groupId = self.groupId
        }
        
    }
    
    
}