//
//  FirebaseAuthClient.swift
//  Brave Heart Minute
//
//  Created by Vladimir Djokanovic on 8/21/17.
//  Copyright © 2017 Intellex. All rights reserved.
//

import UIKit
import FirebaseAuth

let AUTH_VERIFICATION_ID = "authVerificationID"

class FirebaseAuthClient: NSObject {
    
    static let sharedInstance = FirebaseAuthClient()
    
    override init() {
        super.init()
        
        self.listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if self.userAuthorized{
                
                //TODO: Set to go to first authorized view controller
            }
            else{
                
                //TODO: Set to go to authorization view controller
            }
        }
    }
    
    var listener : AuthStateDidChangeListenerHandle?
    var userAuthorized : Bool{
        get{
            
            return Auth.auth().currentUser != nil
        }
    }
    
    

    /// Firebase authorization for all methods
    ///
    /// - Parameters:
    ///   - credential: Credential for auhorization
    ///   - success: Is authorization success
    static func auth(credential: AuthCredential, success: @escaping SuccessHandler){
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                
                success(false)
                print(error.localizedDescription)
                return
            }
            // User is signed in
            success(true)
        }
    }
    
    /// Firebase autorization with email and password
    ///
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - success: Is authorization success
    static func auth(email: String, password: String, success: @escaping SuccessHandler){
    
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let err = error{
                
                success(false)
                print(err.localizedDescription)
                return
            }
            
            // User is signed in
            success(true)
        }
    }

    /// Firebae user logout
    ///
    /// - Parameter succes: Is logout success
    static func logout(_ succes: @escaping SuccessHandler){
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            succes(true)
        } catch let signOutError as NSError {
            succes(false)
            print ("Error signing out: %@", signOutError)
        }
    }
    
    /// Firebase phone authorization
    ///
    /// - Parameters:
    ///   - phoneNumber: Phone number to be authorized
    ///   - success: Is authorization success
    static func phoneAuth(phoneNumber: String, success: @escaping (_ success: Bool) -> Void){
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber) { (verificationID, error) in
            
            if let error = error {
                
                success(false)
                print(error.localizedDescription)
                return
            }
            else{
                
                UserDefaults.standard.set(verificationID, forKey: AUTH_VERIFICATION_ID)
                UserDefaults.standard.synchronize()
                success(true)
            }
        }
    }
    
    /// Firebase verify code for phone authorization
    ///
    /// - Parameters:
    ///   - verifyCode: Received code
    ///   - success: Is verification success
    static func verifyPhone(verifyCode: String, success: @escaping SuccessHandler){
        
        let verificationID = UserDefaults.standard.string(forKey: AUTH_VERIFICATION_ID)
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verifyCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                
                print(error.localizedDescription)
                success(false)
                return
            }
            else{
                success(true)
            }
        }
    }
}
