//
//  ViewController.swift
//  SocialDev
//
//  Created by Clyfford Millet on 1/26/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    
    @IBOutlet var emailField: FancyField!
    @IBOutlet var pwdField: FancyField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // _ = UID STRING, checking if key exists
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func facebookBtnPressed(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("CLYFF: Unable to authenticate with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("CLYFF: User cancelled authentication")
            } else {
                print("CLYFF: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("CLYFF: Unable to authenticate with Firebase -\(error)")
            } else {
                print("CLYFF: Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }

    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("CLYFF: Email user authenticated with firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("CLYFF: Unable to authenticate with Firebase using email")
                        } else {
                            print("Clyff: Successfully authenticated with firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        
        // GIVE USERNAME SEGUE IF NEW USER
        FIRDatabase.database().reference().child("users/\(FIRAuth.auth()!.currentUser!.uid)/username").observeSingleEvent(of: .value, with: {(snap) in
            
            if snap.exists(){
                //Your user already has a username
                self.performSegue(withIdentifier: GO_TO_FEED, sender: nil)
            }else{
                //You need to set the user's name and the the required segue
                self.performSegue(withIdentifier: "UserNameVC", sender: nil)
            }
        })
    }
}

