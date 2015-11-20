//
//  Group.swift
//  Prototype
//
//  Created by Brunno Attorre on 11/20/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

class GroupFlap{
    var userId: String
    var groupName: String
  
    
    init(groupName: String, userId: String) {
        self.userId = userId
        self.groupName = groupName
    }
    
    func toDictionary() -> [String: AnyObject]{
        return [
            "user_fb_id": userId,
            "group_name": groupName
        ]
    }
    
    
}