//
//  ChooseGroupRecipientsViewController.swift
//  Prototype
//
//  Created by Ben Lieblich on 10/19/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

class ChooseGroupRecipientsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    let numGroups = 20
    var groupList: [Bool] = []
    var url: NSURL = NSURL();
    var highlighted = [Int: Bool]()
    var groupId: String = ""
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        self.groupList = [Bool](count:self.numGroups, repeatedValue: false)
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
    
    // MARK: - Collection View Setup
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 30, 15, 30)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numGroups
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(90, 90)
//    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // choose reusable cell type
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("recipientCell", forIndexPath: indexPath) as! CollectionViewCell
        
        // set title and image
        var cSelector : Selector = nil
        if(indexPath.item == 0) {
            cell.title?.text = "New Refly"
            cell.pinImage?.image = UIImage(named: "newRefly.png")
            cSelector = "chooseNewGroupMembers:"
        } else {
            cell.title?.text = "Group \(indexPath.item)"
            cell.groupId = indexPath.item
            cell.pinImage?.image = UIImage(named: "spiral-rainbow-background.jpg")
            cSelector = "tapped:"
        }
        
        // round the image
        cell.pinImage.layer.cornerRadius = cell.pinImage.frame.size.width / 2
        let borderColor = UIColor(red:0.03, green:0.95, blue:0.95, alpha:1.0)
        cell.pinImage.layer.borderColor = borderColor.CGColor
        cell.pinImage.clipsToBounds = true
        
        // give it a gesture recognizer
        cell.tag = indexPath.item
        let tap = UITapGestureRecognizer.init(target: self, action: cSelector)
        cell.addGestureRecognizer(tap)
        return cell
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        NSLog(String(sender.view!.tag))
        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: sender.view!.tag, inSection: 0)) as! CollectionViewCell
        if((highlighted[sender.view!.tag]) != nil && highlighted[sender.view!.tag] == true){
            let width = CABasicAnimation(keyPath: "borderWidth")
            width.fromValue = 4.0;
            width.toValue   = 0.0;
            cell.pinImage.layer.addAnimation(width, forKey: "borderWidth")
            cell.pinImage.layer.addAnimation(width, forKey: "borderWidth")
            cell.pinImage.layer.borderWidth = 0.0
            highlighted[sender.view!.tag] = false
            self.groupList.removeAtIndex(cell.groupId)
        } else{
            let width = CABasicAnimation(keyPath: "borderWidth")
            width.fromValue = 0.0;
            width.toValue   = 4.0;
            cell.pinImage.layer.addAnimation(width, forKey: "borderWidth")
            cell.pinImage.layer.borderWidth = 4.0
            highlighted[sender.view!.tag] = true
            self.groupList.insert(true, atIndex: cell.groupId)
        }
        print(self.groupList.description)
        
    }
    
    func chooseNewGroupMembers(sender: UITapGestureRecognizer){
        performSegueWithIdentifier("chooseNewGroupFriends", sender: self)
    }
    
    func upload (){
        let outFormatter = NSDateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        outFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        for (group, chosen) in self.groupList.enumerate() {
            if(chosen) {
                S3ClientService().uploadToS3( self.url, groupId: group, videoId: outFormatter.stringFromDate(NSDate()))

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
