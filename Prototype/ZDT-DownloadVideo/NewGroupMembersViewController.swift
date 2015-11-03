//
//  NewGroupMembersViewController.swift
//  Prototype
//
//  Created by Ben Lieblich on 10/27/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

protocol NewGroupMembersViewControllerDelegate{
    func createNewGroup(controller: NewGroupMembersViewController, group: Group)
}

class NewGroupMembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {

    @IBOutlet weak var recipientTableView: UITableView!
    @IBOutlet weak var groupTitle: UITextField!
    
    var delegate:NewGroupMembersViewControllerDelegate! = nil
    var newGroup = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.recipientTableView.delegate = self
        self.recipientTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelNewGroup(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
            delegate.createNewGroup(self, group: self.newGroup)
        }
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
        
        // round the image
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        
        cell.friendName?.text = "Monkey"
        
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
