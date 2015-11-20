import Alamofire

class BackendService{
    
    func getGroups(fbId: String,controller: ViewController) {
        getGroupIds(fbId,controller: controller)
    }
    
    func getGroupIds(fbId: String, controller: ViewController) -> Array<Int>{
        var groupIds = [Int]()

        Alamofire.request(.GET, "http://refly-bd.herokuapp.com/api/groups?user_fb_id="+fbId,
             encoding:.JSON).responseJSON { request in
                switch request.result {
                case .Success(let JSON):
                    print(JSON)
                    groupIds = (JSON["group_ids"] as? [Int])!
                    self.getGroups(groupIds, controller: controller)
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }
        
        return groupIds
    }
    
    func getGroups(listIds: Array<Int>, controller: ViewController){
        controller.groupsSize = listIds.count
        controller.listGroups = [FlapGroup]()

        for groupId in listIds{
            Alamofire.request(.GET, "http://refly-bd.herokuapp.com/api/group/"+String(groupId),
                encoding:.JSON).responseJSON { request in
                    switch request.result {
                    case .Success(let JSON):
                        controller.listGroups.append(FlapGroup.init(json: JSON as! NSDictionary))
                        if(controller.groupsSize == controller.listGroups.count){
                            controller.collectionView.reloadData()
                        }
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                    }
            }

        }
    }
    
    func submitVideo(userId: String, videoPath: String, groupIds: Array<Int>){
        let video = Video.init(videoPath: videoPath, userId: userId,  groupId: groupIds).toDictionary()
        Alamofire.request(.POST, "http://refly-bd.herokuapp.com/api/videos",parameters: video,
            encoding:.JSON).responseJSON { request in
                switch request.result {
                case .Success(let JSON):
                    print("Video uploaded")
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }
    }
    
    func createGroup(userId:String, groupName: String, controller: NewGroupMembersViewController){
        let group = GroupFlap.init(groupName: groupName, userId: userId).toDictionary()
        Alamofire.request(.POST, "http://refly-bd.herokuapp.com/api/groups",parameters: group,
            encoding:.JSON).responseJSON { request in
                switch request.result {
                case .Success(let JSON):
                    var dictionary = (json: JSON as! NSDictionary)
                    print("Group  uploaded" + String(dictionary.valueForKey("group_id")))
                    controller.groupId = Int(String(dictionary.valueForKey("group_id")!))!
                    controller.upload()
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }
    }

    
}