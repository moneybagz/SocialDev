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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        })
    }

}

