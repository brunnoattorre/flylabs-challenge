//
//  ViewController.swift
//  ZDT-DownloadVideo
//
//  Created by Sztanyi Szabolcs on 11/04/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import AWSS3
import Alamofire


class ViewController: UIViewController, NSURLSessionDownloadDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource , UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var videoView: UIView!

    @IBOutlet var progressView: ProgressView!
    
    private var uiImage: UIImageView!
    private var backendService = BackendService()
    
    
    var groupSelected: Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var progress: Float = 0
    private var totalBytes = [Int: Int64]()
    private var totalDownloaded = [Int: Int64]()

    private var listTasks: [NSURLSessionDownloadTask] = []
    private var listURLs: [NSURL] = [NSURL(string: "https://s3-us-west-2.amazonaws.com/flylabschallenge/Group1/20151011_222027.mp4")!,NSURL(string: "https://s3-us-west-2.amazonaws.com/flylabschallenge/Group1/20151011_221546.mp4")!]
    
    var user_fb_id: String?
    var user_fb_name: String?
    let appColor = UIColor(red:0.03, green:0.95, blue:0.95, alpha:1.0)
    var listGroups: [FlapGroup] = [FlapGroup]()
    var groupsSize: Int = 0
    var friends = []
    
    @IBAction func downloadButtonPressed() {
        listTasks = []
        createDownloadTask()
        
    }
    
    func createDownloadTask() {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        for urls in listURLs{
            let downloadRequest = NSMutableURLRequest(URL: urls)
            let downloadTask = session.downloadTaskWithRequest(downloadRequest)
            listTasks.append(downloadTask)
        }
        for task in listTasks{
            task.resume()
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        totalBytes[downloadTask.taskIdentifier] = totalBytesExpectedToWrite
        totalDownloaded[downloadTask.taskIdentifier] = totalBytesWritten
        var totalBytesExpected = Int64(0)
        for (_,value) in totalBytes{
            totalBytesExpected = totalBytesExpected + value
        }
        var totalDownloadedBytes = Int64(0)
        for (_,value) in totalDownloaded{
            totalDownloadedBytes = totalDownloadedBytes + value
        }

        
        progress = (Float(totalDownloadedBytes) / Float(totalBytesExpected))
        self.uiImage.alpha = CGFloat(progress * 0.4)
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        let fileManager = NSFileManager.defaultManager()
        let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent(String(downloadTask.taskIdentifier) + ".mp4")
        do {
            do{
                try fileManager.removeItemAtURL(fileURL)
            }catch{
                print(error)
            }
            try fileManager.moveItemAtURL(location, toURL: fileURL)
        } catch {
            print(error)
        }
        if(progress == 1.0  ){
            self.uiImage.alpha = CGFloat(1)
            performSegueWithIdentifier("segue1", sender: nil)
            resetView()
        }
       
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            if(segue.identifier == "segue1") {
                (segue.destinationViewController as! MyVideoPlayerViewController).groupId = self.groupSelected
                let fileManager = NSFileManager.defaultManager()
                let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                let destination = segue.destinationViewController as!
                AVPlayerViewController
                var listVideos = [AVPlayerItem]()
                for task in listTasks{
                    NSLog(String(task.taskIdentifier))
                    let item = AVPlayerItem(URL: documents.URLByAppendingPathComponent(String(task.taskIdentifier) + ".mp4"))
                    listVideos.append(item)
                }
                destination.player = FlyLabsPlayer(items: listVideos)
                destination.player?.play()
            }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
                task.cancel()
        
    }
    
    func resetView() {
        for task in listTasks{
            task.cancel()
        }
    }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
//        self.recordButton.backgroundColor = self.appColor
//        self.recordButton.layer.cornerRadius = 0
//        print(self.recordButton.layer.cornerRadius.description)
        
        collectionView.delegate = self
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: AWSRegionType.USEast1, identityPoolId: "us-east-1:420e4e3a-8411-4352-9b63-5f3a7d5760da")
        
        let defaultServiceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USWest2, credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = defaultServiceConfiguration

//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 90, height: 90)
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            let vc = LoginViewController()
            self.parentViewController?.presentViewController(vc, animated: false, completion: nil)
        } else {

            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                self.friends = result["data"] as! [Dictionary<String, String>]
            })
        }
       
        
    }
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)

            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                print (result)
                self.user_fb_id = result["id"] as? String
                self.user_fb_name = result["name"] as? String
                NSLog(self.user_fb_id! + "-" + self.user_fb_name!)
                if(self.user_fb_id != nil){
                    self.backendService.getGroups(self.user_fb_id!, controller: self)
                }
//                let params = [ "user_fb_id":self.user_fb_id!, "user_fb_name":self.user_fb_name! ]
//                Alamofire.request(.GET, "http://refly-bd.herokuapp.com/api/register",
//                    parameters: params, encoding:.JSON).responseJSON { response in
//
//                        if let JSON = response.result.value {
//                            print("JSON: \(JSON)")
//                            print(JSON["result"])
//                        }
//                }
            })
        }
    }
    
    
    func addGradientBackgroundLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        
        let colorTop: AnyObject = UIColor(red: 73.0/255.0, green: 223.0/255.0, blue: 185.0/255.0, alpha: 1.0).CGColor
        let colorBottom: AnyObject = UIColor(red: 36.0/255.0, green: 115.0/255.0, blue: 192.0/255.0, alpha: 1.0).CGColor
        gradientLayer.colors = [colorTop, colorBottom]
        
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(-40, 30, 15, 30)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupsSize
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // choose reusable cell type
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! CollectionViewCell

        let group = self.listGroups[indexPath.item]
        // set title and image
        cell.title?.text = "Group \(indexPath.item)"
        cell.groupId = indexPath.item
        
        
        cell.title?.text = group.groupName
        cell.groupId = group.groupId
        if let url = NSURL(string: "http://lorempixel.com/600/200/") {
            print(url)
            
            if let data = NSData(contentsOfURL: url){
                cell.pinImage?.contentMode = UIViewContentMode.ScaleAspectFit
                cell.pinImage?.image = UIImage(data: data)
            }else{
                cell.pinImage?.image = UIImage(named: "spiral-rainbow-background.jpg")

            }
        }
        
        if let url = NSURL(string: "http://api.randomuser.me/portraits/med/men/" + String(arc4random_uniform(100)) + ".jpg") {
            print(url)
            
            if let data = NSData(contentsOfURL: url){
                cell.personImage?.contentMode = UIViewContentMode.ScaleAspectFit
                cell.personImage?.image = UIImage(data: data)
            }
        }
        

        cell.playImage?.image = UIImage(named: "play_button.png")
        
        if(arc4random_uniform(2) == 1){
            if let url = NSURL(string: "http://api.randomuser.me/portraits/med/men/" + String(arc4random_uniform(100)) + ".jpg") {
                print(url)
        
                if let data = NSData(contentsOfURL: url){
                    cell.personImage2?.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.personImage2?.image = UIImage(data: data)
                    cell.personImage2?.clipsToBounds = true;
                    cell.personImage2?.layer.cornerRadius = cell.personImage2.frame.size.width / 2
                }
            }
            if(arc4random_uniform(2) == 1){
                if let url = NSURL(string: "http://api.randomuser.me/portraits/med/men/" + String(arc4random_uniform(100)) + ".jpg") {
                    print(url)
                    
                    if let data = NSData(contentsOfURL: url){
                        cell.personImage3?.contentMode = UIViewContentMode.ScaleAspectFit
                        cell.personImage3?.image = UIImage(data: data)
                        cell.personImage3?.clipsToBounds = true;
                        cell.personImage3?.layer.cornerRadius = cell.personImage3.frame.size.width / 2
                    }
                }
                
            }

        }
        
        
        
        // round the image
        cell.personImage?.clipsToBounds = true;
        cell.personImage?.layer.cornerRadius = cell.personImage.frame.size.width / 2
        
        // give it a gesture recognizer
        let cSelector : Selector = "pressed:"
        cell.tag = indexPath.item
        let press = UILongPressGestureRecognizer.init(target: self, action: cSelector)
        cell.addGestureRecognizer(press)
        
        // give it a gesture recognizer
        let cSelector2 : Selector = "tapped:"
        cell.tag = indexPath.item
        let tap = UITapGestureRecognizer.init(target: self, action: cSelector2)
        cell.addGestureRecognizer(tap)
        return cell
    }
  
    
    func tapped(sender: UITapGestureRecognizer) {
        NSLog(String(sender.view!.tag))
        self.uiImage = (collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: sender.view!.tag, inSection: 0)) as! CollectionViewCell).pinImage
        self.listURLs =   S3ClientService().listFilesFromS3((listGroups[sender.view!.tag] as FlapGroup).groupId)
        if(!listURLs.isEmpty){
            downloadButtonPressed()
        }
    }
    
    func pressed(sender: UILongPressGestureRecognizer) {
        let addGroupMembersVC = self.storyboard?.instantiateViewControllerWithIdentifier("addGroupMembersModalView") as! AddGroupMembersViewController
        addGroupMembersVC.group = (sender.view?.tag)!
        presentViewController(addGroupMembersVC, animated: true, completion: nil)
    }
    
    //prepare for segue
    //tell the new vc which group is sending
}
