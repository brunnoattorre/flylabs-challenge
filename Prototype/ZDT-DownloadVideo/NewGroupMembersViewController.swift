//
//  NewGroupMembersViewController.swift
//  Prototype
//
//  Created by Ben Lieblich on 10/27/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

//protocol NewGroupMembersViewControllerDelegate{
//    func createNewGroup(controller: NewGroupMembersViewController, group: Group)
//}

class NewGroupMembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var groupId: NSInteger = 0
    var url: NSURL = NSURL()
    let appColor = UIColor(red:0.03, green:0.95, blue:0.95, alpha:1.0)
    let flapTitleFont = UIFont(name: "MarkerFelt-Thin", size: 12)
    
    @IBOutlet weak var recipientTableView: UITableView!
    @IBOutlet weak var groupTitle: UITextField!
    var newGroup = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.recipientTableView.delegate = self
        self.recipientTableView.dataSource = self
//        self.recipientTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        
        // Call the uiimagepicker for the camera
        let picker = UIImagePickerController()
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
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = true
        }
        self.navigationController?.presentViewController(picker, animated: false, completion: nil)
    }
    
    // MARK: - UIImagePickerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let url = info[UIImagePickerControllerMediaURL] {
            self.url = url as! NSURL
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if(self.groupId>0) {
            //add video to flap
            //code
            
            //pop off the view controller
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    
    @IBAction func cancelNewGroup(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createNewGroup(sender: AnyObject) {
        if(self.groupTitle.text == "") {
            self.groupTitle.layer.borderColor = UIColor.redColor().CGColor
            self.groupTitle.layer.borderWidth = 1
        }
        else {
            self.groupTitle.layer.borderWidth = 0
        }
        if(self.newGroup.list.isEmpty) {
            let noRecipientsAlert = UIAlertController(title: "No Recipients", message: "Try choosing some friends to send your video to.", preferredStyle: UIAlertControllerStyle.Alert)
            noRecipientsAlert.addAction(UIAlertAction(title: "Gotcha", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(noRecipientsAlert, animated: true, completion: nil)
        }
        if(self.groupTitle.text != "" && !self.newGroup.list.isEmpty) {
            self.newGroup.title = self.groupTitle.text!
        }
        //send to server
        //code
        
        //go to home screen
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! FriendTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var gender = ""
        if(arc4random_uniform(100)>50) {
            gender = "men"
        } else {
            gender = "women"
        }
        
        if let url = NSURL(string: "http://api.randomuser.me/portraits/med/" + gender + "/" + String(arc4random_uniform(100)) + ".jpg") {
            print(url)
            
            if let data = NSData(contentsOfURL: url){
                cell.profilePic?.contentMode = UIViewContentMode.ScaleAspectFit
                cell.profilePic?.image = UIImage(data: data)
            }
        }
        let names = ["Ben", "Brunno", "YuChien", "Andy", "Steven","Tim"]
        cell.friendName?.text = names[Int(arc4random_uniform(6))]

        
        // round the image
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendTableViewCell
        
        print(cell.checked)
        if(cell.checked) {
            cell.accessoryType = UITableViewCellAccessoryType.None
            self.newGroup.list.removeValueForKey(indexPath.item)
            cell.checked = false
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.newGroup.list[indexPath.item] = true
            cell.checked = true
        }
    }
        
// MARK: - Nav Bar Delegate Methods
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
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
