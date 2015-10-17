//
//  LoginViewController.swift
//  Prototype
//
//  Created by chan yu chien on 2015/10/17.
//  Copyright © 2015年 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO:Token is already available.
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(loginView)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func returnUserData()
//    {
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil) {
//                print("Error: \(error)")
//            } else {
//                print("fetched user: \(result)")
//            }
//        })
//    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
