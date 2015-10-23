//
//  S3ClientService.swift
//  Prototype
//
//  Created by Brunno Attorre on 10/17/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit
import AWSS3

class S3ClientService{
    var amountUploaded:Int64 = 0
    var filesize:Int64 = 0
    var urls : [NSURL] = []
    
    func uploadToS3(path : NSURL, groupId: Int, videoId: Int){
        // Get the file using url loading mechanisms to get the mime type.
        let url = NSURL(string: "https://s3-us-west-2.amazonaws.com/flylabschallenge/Group" + String(groupId) + "/" + String(videoId) + ".mov")
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = "PUT";
        urlRequest.HTTPBody = NSData(contentsOfURL: path);
        urlRequest.setValue("video/mov", forHTTPHeaderField: "Content-Type")
        let s3Manager = AFAmazonS3Manager()
        s3Manager.requestSerializer.region = AFAmazonS3USWest2Region;
        s3Manager.requestSerializer.bucket = "flylabschallenge";
        let operation = s3Manager.HTTPRequestOperationWithRequest(urlRequest, success: nil, failure: {( operation : AFHTTPRequestOperation,  error:NSError) in
            NSLog(String(error))
            })
        
        s3Manager.operationQueue.addOperation(operation)
    
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
                        if(s3Object.key.containsString(".mp4") || s3Object.key.containsString(".mov") ){
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