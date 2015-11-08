//
//  ChooseGroupRecipientsViewController.swift
//  Prototype
//
//  Created by Ben Lieblich on 10/19/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

struct Group{
    var title: String = ""
    var list = [Int: Bool]()
}

class ChooseGroupRecipientsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, NewGroupMembersViewControllerDelegate {
    
    let numGroups = 20
    var url: NSURL = NSURL();
    var selectedGroups = [Int: Bool]()
    var newGroup = Group()
    let appColor = UIColor(red:0.03, green:0.95, blue:0.95, alpha:1.0)
    let flapTitleFont = UIFont(name: "MarkerFelt-Thin", size: 12)
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
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
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            picker.dismissViewControllerAnimated(true, completion: nil)
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
    
    // MARK: - Collection View Setup
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 30, 15, 30)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numGroups
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // choose reusable cell type
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("recipientCell", forIndexPath: indexPath) as! CollectionViewCell
        
        // set title and image
        if(indexPath.item == 0) {
            cell.title?.text = "New Refly"
            cell.pinImage?.image = UIImage(named: "newRefly.png")
        } else {
            cell.title?.text = "Group \(indexPath.item)"
            
            var gender = ""
            if(arc4random_uniform(100)>50) {
                gender = "men"
            } else {
                gender = "women"
            }
            
            if let url = NSURL(string: "http://lorempixel.com/400/200/") {
                print(url)
                
                if let data = NSData(contentsOfURL: url){
                    cell.pinImage?.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.pinImage?.image = UIImage(data: data)
                }
            }
        }
        
        
        cell.title?.textAlignment = NSTextAlignment.Center
        cell.title?.font = self.flapTitleFont
        cell.title?.textColor = self.appColor
        cell.groupId = indexPath.item
        
        // round the image
        cell.pinImage.layer.cornerRadius = cell.pinImage.frame.size.width / 2
        cell.pinImage.layer.borderColor = self.appColor.CGColor
        cell.pinImage.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        if((selectedGroups[indexPath.item]) == nil || selectedGroups[indexPath.item] == false){
            if(indexPath.item == 0) {
                let newGroupController = self.storyboard?.instantiateViewControllerWithIdentifier("newGroupModalView") as! NewGroupMembersViewController
                newGroupController.delegate = self
                presentViewController(newGroupController, animated: true, completion: nil)
            } else {
                let width = CABasicAnimation(keyPath: "borderWidth")
                width.fromValue = 0.0;
                width.toValue   = 4.0;
                cell.pinImage.layer.addAnimation(width, forKey: "borderWidth")
                cell.pinImage.layer.borderWidth = 4.0
                selectedGroups[indexPath.item] = true
            }
        } else{
            if(indexPath.item == 0) {
                self.newGroup = Group()
            }
            let width = CABasicAnimation(keyPath: "borderWidth")
            width.fromValue = 4.0;
            width.toValue   = 0.0;
            cell.pinImage.layer.addAnimation(width, forKey: "borderWidth")
            cell.pinImage.layer.addAnimation(width, forKey: "borderWidth")
            cell.pinImage.layer.borderWidth = 0.0
            selectedGroups.removeValueForKey(indexPath.item)
        }

        // check which groups have been selected
        print(selectedGroups.description)
        
    }
    
    func upload (){
        let outFormatter = NSDateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        outFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        for groupId in self.selectedGroups.keys {
            if(selectedGroups[groupId] == true) {
                S3ClientService().uploadToS3( self.url, groupId: groupId, videoId: outFormatter.stringFromDate(NSDate()))

            }
        }
    }
    @IBAction func sendSelected(sender: AnyObject) {
        upload()
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        
        for aViewController in viewControllers {
            if(aViewController is ViewController){
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
        }
    }
    
    //MARK: - New Group Creation
    
    func createNewGroup(controller: NewGroupMembersViewController, group: Group) {
        self.newGroup = group
        print(group.title)
        print(group.list.description)
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        let indexPath = NSIndexPath.init(forItem: 0, inSection: 0)
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        let width = CABasicAnimation(keyPath: "borderWidth")
        width.fromValue = 0.0;
        width.toValue   = 4.0;
        cell.pinImage.layer.addAnimation(width, forKey: "borderWidth")
        cell.pinImage.layer.borderWidth = 4.0
        selectedGroups[indexPath.item] = true
    }

}
