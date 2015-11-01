
class FlapGroup{
    var groupId: Int
    var userIds: Array<Int>
    var videoIds: Array<Int>
    var groupName: String
    var groupDesc: String
    var groupCreateTime:String
    
        
    
    init(json: NSDictionary) {
        self.groupId = json["group_id"] as! Int
        self.userIds = json["user_ids"] as! Array<Int>
        self.videoIds = json["video_ids"]as! Array<Int>
        self.groupName = json["group_name"]as! String
        self.groupDesc = json["group_desc"]as! String
        self.groupCreateTime = json["group_create_time"]as! String
    }
    
}