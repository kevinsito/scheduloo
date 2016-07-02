//
//  LoginViewController.swift
//  Scheduloo
//
//  Created by Roger Cui on 2014-07-03.
//  Copyright (c) 2014 Kevin Sito. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet var loginView : FBLoginView = FBLoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This view loaded")
        loginView.delegate = self
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView) {
        loginView.hidden = true
        let vc : AnyObject! = self.storyboard.instantiateViewControllerWithIdentifier("tabbedSB")
        self.presentViewController(vc as UIViewController, animated: true, completion: nil)
    }

}