//
//  FlyLabsPlayer.swift
//  Prototype
//
//  Created by Brunno Attorre on 10/22/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class FlyLabsPlayer: AVQueuePlayer{

    var viewConroller: MyVideoPlayerViewController = MyVideoPlayerViewController()
    var startPlaying = false
    
    override func didChangeValueForKey(key: String) {
        super.didChangeValueForKey(key)
        if(super.items().count > 0 ){
            startPlaying = true
        }
        if(super.items().count == 0 && startPlaying){
            var alert = UIAlertController(title: "Add new videos", message: "Would you like to add a new video to this group", preferredStyle: UIAlertControllerStyle.Alert)
            self.viewConroller.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    self.viewConroller.performSegueWithIdentifier("chooseVideoAfterVideoPlayer", sender: self.viewConroller)
                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    print("destructive")
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    self.viewConroller.navigationController?.popToRootViewControllerAnimated(true)

                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    print("destructive")
                }
            }))

        }
    }
    
    override func advanceToNextItem() {
        super.advanceToNextItem()
    }
}