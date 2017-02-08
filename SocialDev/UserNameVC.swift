//
//  UserNameVC.swift
//  SocialDev
//
//  Created by Clyfford Millet on 2/5/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class UserNameVC: UIViewController {

    
    
    @IBOutlet var usernameTextField: FancyField!
    
    @IBOutlet var tryAgainLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    @IBAction func userNameBtnPressed(_ sender: AnyObject) {
        
        guard usernameTextField.text != "" else {
            
            tryAgainLabel.text = "username must be entered"
            return
        }
        
        let userNameRef = DataService.ds.REF_USER_CURRENT.child("username")
        
        userNameRef.setValue(usernameTextField.text)
        
        self.performSegue(withIdentifier: "FeedVC", sender: nil)
    }
}
