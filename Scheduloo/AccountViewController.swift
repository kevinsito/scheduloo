//
//  AccountViewController.swift
//  Scheduloo
//
//  Created by Roger Cui on 2014-07-03.
//  Copyright (c) 2014 Kevin Sito. All rights reserved.
//
import Foundation
class AccountViewController: UIViewController {
    
    @IBAction func logout(sender : AnyObject) {
        FBSession.activeSession().closeAndClearTokenInformation()

        let vc : AnyObject! = self.storyboard.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(vc as UIViewController, animated: true, completion: nil)
    }
    
    @IBOutlet var profilePictureView : UIImageView
    @IBOutlet var name : UILabel
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded view")
        FBSession.initialize()
        if (FBSession.activeSession().isOpen) {
            FBRequestConnection.startWithGraphPath("me", parameters: ["fields": "friends, first_name, last_name, picture.type(normal)"
        ], HTTPMethod: "GET", completionHandler: {connection, result, error in
                if (!error) {

                    
                    let firstName = result.objectForKey("first_name") as String
                    let lastName = result.objectForKey("last_name") as String
                    
                    self.name.text = "\(firstName) \(lastName)"
                    
                    // Set up picture
                    var pictureURL : NSURL = NSURL(string: result.objectForKey("picture").objectForKey("data").objectForKey("url") as String)
                    self.profilePictureView.image = UIImage(data: NSData(contentsOfURL: pictureURL))
                    self.profilePictureView.layer.masksToBounds = true;
                    self.profilePictureView.layer.cornerRadius = 30.0;
                    self.profilePictureView.layer.borderColor = UIColor.whiteColor().CGColor;
                    self.profilePictureView.layer.borderWidth = 1.0;
                    
                }
            })
            
            FBRequestConnection.startWithGraphPath("me/friends", parameters: ["fields": "name, id, picture"
                ], HTTPMethod: "GET", completionHandler: {connection, result, error in
                    if (!error) {
                        print(result)
                        

                        // Set up picture
         
                    }
            })
        }
    }
    
    // Change status bar to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  }