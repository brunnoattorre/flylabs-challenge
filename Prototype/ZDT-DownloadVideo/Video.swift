//
//  Video.swift
//  Prototype
//
//  Created by Brunno Attorre on 10/31/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

class Video{
    var video_s3_path: String
    var user_fb_id: String
    var created_at: String
    var order: Int
    var group_ids: Array<Int>
    
    init(videoPath: String, userId: String, groupId: Array<Int>) {
        self.video_s3_path = videoPath
        self.user_fb_id = userId
        self.created_at = NSDateFormatter.dateFormatFromTemplate("yyyyMMdd hh:mm:ss", options: 0, locale: NSLocale(localeIdentifier: "en-US"))!
        self.order = 1
        self.group_ids = groupId
    }
    
    func toDictionary() -> [String: AnyObject]{
        return [
            "video_s3_path": video_s3_path,
            "user_fb_id": user_fb_id,
            "created_at": created_at,
            "order": order,
            "group_ids":group_ids
            
        ]
    }
    

}