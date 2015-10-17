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

class ViewController: UIViewController, NSURLSessionDownloadDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var videoView: UIView!

    @IBOutlet var progressView: ProgressView!

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var progress: Float = 0
    private var totalBytes = [Int: Int64]()
    private var totalDownloaded = [Int: Int64]()

    private var listTasks: [NSURLSessionDownloadTask] = []
    private var listURLs: [NSURL] = [NSURL(string: "https://s3-us-west-2.amazonaws.com/flylabschallenge/20151011_222027.mp4")!,NSURL(string: "https://s3-us-west-2.amazonaws.com/flylabschallenge/20151011_221546.mp4")!]
    
    
    
    
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

        
        progress = Float(totalDownloadedBytes) / Float(totalBytesExpected)
        progressView.animateProgressViewToProgress(progress)
        progressView.updateProgressViewLabelWithProgress(progress * 100)
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        let fileManager = NSFileManager.defaultManager()
        let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent(String(downloadTask.taskIdentifier) + ".mov")
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
        if(progress == 1.0 ){
            performSegueWithIdentifier("segue1", sender: nil)
            resetView()
        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            let fileManager = NSFileManager.defaultManager()
            let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let destination = segue.destinationViewController as!
            AVPlayerViewController
            var listVideos = [AVPlayerItem]()
            for task in listTasks{
                let item = AVPlayerItem(URL: documents.URLByAppendingPathComponent(String(task.taskIdentifier) + ".mov"))
                listVideos.append(item)
            }
            destination.player = AVQueuePlayer(items: listVideos)
            destination.player?.play()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientBackgroundLayer()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 90, height: 90)
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            let vc = LoginViewController()
            self.parentViewController?.presentViewController(vc, animated: false, completion: nil)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil) {
                    print("Error: \(error)")
                } else {
                    print("fetched user: \(result)")
                }
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.title?.text = "Group \(indexPath.row)"
        cell.pinImage?.image = UIImage(named: "securitymonkeyHead.png")
        return cell
    }
    @IBAction func initiateDownload(sender: AnyObject) {
        downloadButtonPressed()
    }
    
}
