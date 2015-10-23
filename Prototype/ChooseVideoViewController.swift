//
//  ChooseVideoViewController.swift
//  Prototype
//
//  Created by Ben Lieblich on 10/17/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
class ChooseVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var url: NSURL = NSURL();
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let picker = UIImagePickerController()
        // Do any additional setup after loading the view.
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                

                
                picker.delegate = self
                picker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.allowsEditing = false
                picker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
                picker.videoMaximumDuration = 10

        } else {

            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.allowsEditing = true
        }
        self.presentViewController(picker, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let url = info[UIImagePickerControllerMediaURL] {
            
            self.url = url as! NSURL
            let player = AVPlayer.init(URL: url as! NSURL)
            let playerController = AVPlayerViewController()
            
            playerController.player = player
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = self.view.frame
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            player.play()
            
        } else {
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            //self.navigationController?.popViewControllerAnimated(false)
        }

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueToGroupSelection") {
            let svc = segue.destinationViewController as! ChooseGroupRecipientsViewController;
            svc.url = self.url
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
