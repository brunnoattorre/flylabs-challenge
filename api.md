# Back end API documentation
* API ENDPOINT
http://refly-bd.heroku.com/

|URL           | description   |      method   |  params  | Success response    | 
| ---- | ------ | ------ | ---  |    ------- |
| api/register  | once facebook authentication success, client should send a request to update or create an entry in user database  | POST |  {'user_fb_id':'test', 'user_fb_name' : 'test'} | code: 200, {'result' : 'success'}|
| api/groups  | create a group | POST |  {'user_fb_id':'test', 'group_name':'test'} | code: 200, {'result' : 'success'}|
| api/groups  | get group lists | GET |  optional : {'user_fb_id':'test'} | code: 200, {'group_ids' : ['123','456', '789']}|
| api/group/{group_id}/add  | add member to a group | POST |  {'user_fb_id':'test1'} | code: 200, {'result' : 'success'}|
| api/group/{group_id} | get group info | GET |   | code: 200, {'group_id' : 123, 'user_ids': [1,2,3], 'video_ids': [1123,231231,123241], 'group_name': 'test', 'group_desc': 'for test', 'group_create_time' :'20111101'}|
| api/group/{group_id}  | delete a group | DELETE |   | code: 200, {'result' : 'success'}|
| api/group/{group_id}  | update a group | PUT |  {'user_fb_id':'test', 'group_name':'test'} | code: 200, {'result' : 'success', 'group_id' : 1}|
| api/videos  | add video info | POST |  {'video_s3_path':'1/2/3/1.mp4', 'user_fb_id' :'1231', 'created_at' : '20110101', 'order' : 1, 'group_ids':[123', '23', '456']} | code: 200, {'result' : 'success', 'video_id' : 1}|
| api/group/{group_id}/videos  | get video lists of a certain group | GET |   | code: 200, {'result' : [{'video_id': 1, 'video_s3_path' : '1/2/3/4.mp4', 'user_fb_id' : '123', 'created_at' : '201011', 'order' : 1}, {'video_id': 2, 'video_s3_path' : '1/2/3/5.mp4', 'user_fb_id' : '1233', 'created_at' : '2010112', 'order' : 2}, {'video_id': 3, 'video_s3_path' : '1/2/3/1.mp4', 'user_fb_id' : '12312', 'created_at' : '2010113', 'order' : 3}]}|
| api/user/{user_fb_id}/groups  | get group lists of a certain user | GET |   | code: 200, {'result' : [{'group_id': 1, 'group_name' : 'haha', 'created_at' : '123', 'description' : '201011'}, {'group_id': 1, 'group_name' : 'haha2', 'created_at' : '124', 'description' : '201012'}, {'group_id': 1, 'group_name' : 'haha3', 'created_at' : '2013125', 'description' : '201011'}]}|
| api/user/{user_fb_id}/videos  | get video lists of a certain user | GET |   | code: 200, {'result' : [{'video_id': 1, 'video_s3_path' : '1/2/3/4.mp4', 'user_fb_id' : '123', 'created_at' : '201011', 'order' : 1}, {'video_id': 2, 'video_s3_path' : '1/2/3/5.mp4', 'user_fb_id' : '123', 'created_at' : '2010112', 'order' : 2}, {'video_id': 3, 'video_s3_path' : '1/2/3/1.mp4', 'user_fb_id' : '123', 'created_at' : '2010113', 'order' : 3}]}|
