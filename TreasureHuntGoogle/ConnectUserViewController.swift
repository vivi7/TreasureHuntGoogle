//
//  ConnectUserViewController.swift
//  TresureHuntGoogle
//
//  Created by Vincenzo Favara on 15/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import UIKit

class ConnectUserViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var segue = false
    var signupActive = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var signUpLabel: UILabel!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        if signupActive == true {
            signupActive = false
            signUpLabel.text = "Use the form below to log in"
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            alreadyRegistered.text = "Not registered"
            signUpToggleButton.setTitle("Sign up", forState: UIControlState.Normal)
        } else {
            signupActive = true
            signUpLabel.text = "Use the form below to sign up"
            signUpButton.setTitle("Sign up", forState: UIControlState.Normal)
            alreadyRegistered.text = "Already registered?"
            signUpToggleButton.setTitle("Log In", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        var error = ""
        if username.text == "" || password.text == "" {
            error = "Please enter a username and password"
        }
        if error != "" {
            displayAlert("Error In Form", error: error)
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signupActive == true {
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, signupError: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if signupError == nil  {
                        // Hooray! Let them use the app now.
                        println("signed up")
                        self.segue = true
                        DataManager.sharedInstance.newUserOperation()
                    } else {
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            error = errorString
                        } else {
                            error = "Please try again later"
                        }
                        self.displayAlert("Could Not Sign Up", error: error)
                    }
                }
            } else {
                PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                    (user: PFUser!, signupError: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                 
                    if signupError == nil {
                        println("logged in")
                        self.segue = true
                        DataManager.sharedInstance.newUserOperation()
                    } else {
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            error = errorString
                        } else {
                            error = "Please try again later"
                        }
                        
                        self.displayAlert("Could Not Log In", error: error)
                    }
                }
            }
            
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if self.segue {
//            if segue.identifier == "toNavigationAppSegue" { //segue che collega il controller con il navigation
//                let controller = (segue.destinationViewController as UINavigationController).topViewController as ListClueViewController
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
