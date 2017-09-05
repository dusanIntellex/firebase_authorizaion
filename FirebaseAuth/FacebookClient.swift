//
//  FacebookClient.swift
//  Uzoni
//
//  Created by Dusan Cucurevic on 3/25/17.
//  Copyright © 2017 DusanCucurevic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

let fbBehavior : FBSDKLoginBehavior = .native
let fbPermissions = ["email", "public_profile"]

class FacebookClient: NSObject {
    
    static let sharedInstance = FacebookClient()
    
    /// Login user with facebook
    ///
    /// - Parameter successHandler: Return true if login is success
    static func authorize(from context: UIViewController, isFirebaseAuth: Bool, successHandler: @escaping (_ success: Bool) -> Void) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = fbBehavior
        
        // Should login now
        if FBSDKAccessToken.current() == nil {
            
            fbLoginManager.logIn(withReadPermissions: fbPermissions, from: context, handler: { (result, error) -> Void in
                
                if error == nil {
                    
                    if result != nil {
                        
                        if let token = FBSDKAccessToken.current() {
                            
                            print("Facebook token \(token)")
                            
                            // Firebase auth
                            if isFirebaseAuth{
                            
                                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                                FirebaseAuthClient.auth(credential: credential, success: { (finish) in
                                    
                                    successHandler(finish)
                                })
                            }
                            else{
                                successHandler(true)
                            }
                        }
                    }
                }
                else{
                    successHandler(false)
                }
            })
            
        // Already authorized
        } else {
            successHandler(true)
        }
    }
    
    static func logout() {
        
        if FBSDKAccessToken.current() != nil{
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
        }
        
        FirebaseAuthClient.logout { (finish) in
            
            print("User is logout: \(finish)")
        }
    }
    
    
    /// Get user facebook data
    static func getFBUserData() {
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "email"]).start(completionHandler: { (connection, result, error) -> Void in
            if error == nil {
                if result != nil {
                    print(result!)
                }
            }
        })
    }
    
    
}
