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
    
    
}