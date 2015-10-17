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

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(NSHomeDirectory())
        // Do any additional setup after loading the view.
        
//        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "performBackNavigation")
//        let sendButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "")
//        self.navigationItem.leftBarButtonItem = backButton
//        self.navigationItem.rightBarButtonItem = sendButton
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = true
        self.presentViewController(picker, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performBackNavigation(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var myImage: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let url = info[UIImagePickerControllerMediaURL] {
            
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
            self.navigationController?.popViewControllerAnimated(false)
        }

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(false)
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
