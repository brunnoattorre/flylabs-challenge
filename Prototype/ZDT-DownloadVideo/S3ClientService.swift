//
//  S3ClientService.swift
//  Prototype
//
//  Created by Brunno Attorre on 10/17/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit


class S3ClientService{
    var amountUploaded:Int64 = 0
    var filesize:Int64 = 0
    var urls : [NSURL] = []
    
    func uploadToS3(path : String, groupId: Int, videoId: Int){
        
        
        // once the image is saved we can use the path to create a local fileurl
        var url:NSURL = NSURL(fileURLWithPath: path)
        
        // next we set up the S3 upload request manager
        var uploadRequest = AWSS3TransferManagerUploadRequest()
        // set the bucket
        uploadRequest?.bucket = "flylabschallenge"
        // I want this image to be public to anyone to view it so I'm setting it to Public Read
        uploadRequest?.ACL = AWSS3ObjectCannedACL.PublicRead
        // set the image's name that will be used on the s3 server. I am also creating a folder to place the image in
        uploadRequest?.key = "Group" + String(groupId) + "/" + String(videoId) + ".mp4"
        // set the content type
        uploadRequest?.contentType = "video/mp4"
        // and finally set the body to the local file path
        uploadRequest?.body = url;
        
        // we will track progress through an AWSNetworkingUploadProgressBlock
        uploadRequest?.uploadProgress = {[unowned self](bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.amountUploaded = totalBytesSent
                self.filesize = totalBytesExpectedToSend;
                self.update()
                
            })
        }
        
        // now the upload request is set up we can creat the transfermanger, the credentials are already set up in the app delegate
        var transferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        // start the upload
        transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                NSLog("Error: \(task.error)")
            } else {
                NSLog("Upload successful")
            }
            return nil
        }
    }
    
    func listFilesFromS3(groupId: Int) -> [NSURL]{
        self.urls = []

        let s3 = AWSS3.defaultS3()
        let listObjectsRequest = AWSS3ListObjectsRequest()
        listObjectsRequest.bucket = "flylabschallenge"
        listObjectsRequest.prefix = "Group" + String(groupId) 
        s3.listObjects(listObjectsRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                print("listObjects failed: [\(error)]")
            }
            if let exception = task.exception {
                print("listObjects failed: [\(exception)]")
            }
            if let listObjectsOutput = task.result as? AWSS3ListObjectsOutput {
                if let contents = listObjectsOutput.contents as? [AWSS3Object] {
                    for s3Object in contents {
                        if(s3Object.key.containsString(".mp4")){
                            NSLog(s3Object.key)
                            self.urls.append(NSURL(string: String("https://s3-us-west-2.amazonaws.com/flylabschallenge/" + s3Object.key))!)
                        }
                    }
                    
                }
            }
            return nil
        }.waitUntilFinished()
        NSLog(String(self.urls.count))
        return self.urls
    }
    
    func update(){
        
    }
}