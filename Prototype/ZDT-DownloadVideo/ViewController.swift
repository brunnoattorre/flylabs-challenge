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
    
    var groupSelected: Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var progress: Float = 0
    private var totalBytes = [Int: Int64]()
    private var totalDownloaded = [Int: Int64]()

    private var listTasks: [NSURLSessionDownloadTask] = []
    private var listURLs: [NSURL] = [NSURL(string: "https://s3-us-west-2.amazonaws.com/flylabschallenge/Group1/20151011_222027.mp4")!,NSURL(string: "https://s3-us-west-2.amazonaws.com/flylabschallenge/Group1/20151011_221546.mp4")!]
    
    var user_fb_id: String?
    var user_fb_name: String?
    
    
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
        for (key,value) in totalBytes{
            totalBytesExpected = totalBytesExpected + value
        }
        var totalDownloadedBytes = Int64(0)
        for (key,value) in totalDownloaded{
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
    
    // MARK: view methods
    
    @IBOutlet weak var recordButton: DownloadButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.recordButton.backgroundColor = UIColor(red:0.03, green:0.95, blue:0.95, alpha:1.0)
        self.recordButton.layer.cornerRadius = 0
        print(self.recordButton.layer.cornerRadius.description)
        
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
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)

            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                self.user_fb_id = result["id"] as? String
                self.user_fb_name = result["name"] as? String
                NSLog(self.user_fb_id! + "-" + self.user_fb_name!)
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
        return 20
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // choose reusable cell type
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! CollectionViewCell

        // set title and image
        cell.title?.text = "Group \(indexPath.item)"
        cell.groupId = indexPath.item
        cell.pinImage?.image = UIImage(named: "spiral-rainbow-background.jpg")
        
        // round the image
        cell.pinImage.layer.cornerRadius = cell.pinImage.frame.size.width / 2
        cell.pinImage.clipsToBounds = true
        
        // give it a gesture recognizer
        let cSelector : Selector = "tapped:"
        cell.tag = indexPath.item
        let tap = UITapGestureRecognizer.init(target: self, action: cSelector)
        cell.addGestureRecognizer(tap)
        return cell
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        NSLog(String(sender.view!.tag))
        self.uiImage = (collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: sender.view!.tag, inSection: 0)) as! CollectionViewCell).pinImage
        self.listURLs =   S3ClientService().listFilesFromS3(sender.view!.tag)
        groupSelected = sender.view!.tag
        if(!listURLs.isEmpty){
            downloadButtonPressed()
        }
    }
    
    // MARK: camera segue/methods
    
//    @IBAction func recordVideo(sender: AnyObject) {
//        if UIImagePickerController.isSourceTypeAvailable(
//            UIImagePickerControllerSourceType.Camera) {
//                
//                let imagePicker = UIImagePickerController()
//                
//                imagePicker.delegate = self
//                imagePicker.sourceType =
//                    UIImagePickerControllerSourceType.Camera
//                imagePicker.mediaTypes = [kUTTypeVideo as String]
//                imagePicker.allowsEditing = false
//                
//                self.navigationController!.pushViewController(imagePicker, animated: true)
//        }
//
//    }
}
