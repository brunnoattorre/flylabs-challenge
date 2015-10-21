//
//  ChooseGroupRecipientsViewController.swift
//  Prototype
//
//  Created by Ben Lieblich on 10/19/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

class ChooseGroupRecipientsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    var url: NSURL = NSURL();
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self

        addGradientBackgroundLayer()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    }
    
    // MARK: - Collection View Setup
    
    func addGradientBackgroundLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        
        let colorTop: AnyObject = UIColor(red: 73.0/255.0, green: 223.0/255.0, blue: 185.0/255.0, alpha: 1.0).CGColor
        let colorBottom: AnyObject = UIColor(red: 36.0/255.0, green: 115.0/255.0, blue: 192.0/255.0, alpha: 1.0).CGColor
        gradientLayer.colors = [colorTop, colorBottom]
        
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

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
        return 20
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
            cell.pinImage?.image = UIImage(named: "spiral-rainbow-background.jpg")
            cSelector = "tapped:"
        }
        
        // round the image
        cell.pinImage.layer.cornerRadius = cell.pinImage.frame.size.width / 2
        cell.pinImage.clipsToBounds = true
        
        // give it a gesture recognizer
        cell.tag = indexPath.item
        let tap = UITapGestureRecognizer.init(target: self, action: cSelector)
        cell.addGestureRecognizer(tap)
        return cell
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        NSLog(String(sender.view!.tag))
        let fileManager = NSFileManager.defaultManager()
        
        let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        
        S3ClientService().uploadToS3( documents.URLByAppendingPathComponent(String(1) + ".mov"), groupId: sender.view!.tag, videoId: 1)
        
    }
    
    func chooseNewGroupMembers(sender: UITapGestureRecognizer){
        performSegueWithIdentifier("chooseNewGroupFriends", sender: self)
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
