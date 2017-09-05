//
//  GoogleClient.swift
//  Uzoni
//
//  Created by Dusan Cucurevic on 3/25/17.
//  Copyright © 2017 DusanCucurevic. All rights reserved.
//

import GoogleSignIn
import FirebaseAuth

class GoogleClient: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {

    var success : ((_ success: Bool) -> Void?)?
    var token : String?
    var context : UIViewController?
    var isFirebase: Bool!
    
    static let sharedInstance = GoogleClient()
    
    static func authorize(from context: UIViewController, isFirebaseAuth: Bool, successHandler: @escaping (_ success: Bool) -> Void) {
        
        sharedInstance.context = context
        sharedInstance.isFirebase = isFirebaseAuth
        
        // Google delegate
        GIDSignIn.sharedInstance().delegate = sharedInstance
        GIDSignIn.sharedInstance().uiDelegate = sharedInstance

        GIDSignIn.sharedInstance().signIn()
        
        sharedInstance.success = successHandler
    }
    
    static func logout() {
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            sharedInstance.token = ""
            GIDSignIn.sharedInstance().signOut()
        }
        
        // Firebase logout
        FirebaseAuthClient.logout({ (success) in
            
            print("Firebase logout success: \(success)")
        })
    }
    
    //MARK:- Delegate methods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            
            if let idToken = user.authentication.idToken {
                
                GoogleClient.sharedInstance.token = idToken
                
                // Connect with firebase and then set callback
                if GoogleClient.sharedInstance.isFirebase{
                    
                    guard let authentication = user.authentication else {
                        
                        if let success = GoogleClient.sharedInstance.success{
                            success(false)
                        }
                        return
                    }
                    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                                   accessToken: authentication.accessToken)
                    FirebaseAuthClient.auth(credential: credential, success: { (finish) in
                        
                        if let success = GoogleClient.sharedInstance.success{
                            success(finish)
                        }
                    })
                    
                }
                else{
                    
                    if let success = GoogleClient.sharedInstance.success{
                        success(true)
                    }
                }
            }
            else{
                
                if let success = GoogleClient.sharedInstance.success{
                    success(false)
                }
            }
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        context?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        context?.dismiss(animated: true, completion: nil)
    }
    
}
