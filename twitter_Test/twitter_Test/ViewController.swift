//
//  ViewController.swift
//  twitter_Test
//
//  Created by synerzip on 20/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import UIKit
import TwitterKit
import Accounts
import Twitter
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var msgTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func postAction(sender: AnyObject) {
//        let composer = TWTRComposer()
//        
//        composer.setText("just setting up my Fabric")
////        composer.setImage(UIImage(named: "fabric"))
//        
//        // Called from a UIViewController
//        composer.showFromViewController(self) { result in
//            if (result == TWTRComposerResult.Cancelled) {
//                print("Tweet composition cancelled")
//            }
//            else {
//                print("Sending tweet!")
//            }
//        }
//        postimg()
        post()
    }
    func postimg() {
        Twitter.sharedInstance().logInWithCompletion {
            (session, error) -> Void in
            if session != nil {
                print("signed in as \(session!.userName)")
                let strUploadUrl = "https://upload.twitter.com/1.1/media/upload.json"
                let strStatusUrl = "https://api.twitter.com/1.1/statuses/update.json"
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                
                let twAPIClient = TWTRAPIClient.init(userID: session!.userName)
                var error: NSError?
                var parameters:Dictionary = Dictionary<String, String>()
                // get image from bundle
                let imageData : NSData = UIImageJPEGRepresentation(UIImage(named: "test.jpg")!, 0.1)!
                
                parameters["media"] = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                //for uploading video would I just do this parameters["media'] = NSData.dataWithContentsOfMappedFile(url.relativePath!) as? NSData
                let twUploadRequest = twAPIClient.URLRequestWithMethod("POST", URL: strUploadUrl, parameters: parameters, error: &error)
                if true {
                    twAPIClient.sendTwitterRequest(twUploadRequest) {
                        (uploadResponse, uploadResultData, uploadConnectionError) -> Void in
                        if (uploadConnectionError == nil) {
                            // using SwiftyJSON to parse result
                            let json = JSON(data: uploadResultData!)
                            // check for media id in result
                            if (json["media_id_string"].string != nil) {
                                print("result = \(json)")
                                // post a status with link to media
                                parameters = Dictionary<String, String>()
                                parameters["status"] = "Hey look at this google.com"
                                parameters["media_ids"] = json["media_id_string"].string!
                                let twStatusRequest = twAPIClient.URLRequestWithMethod("POST", URL: strStatusUrl, parameters: parameters, error: &error)
                                if true //(twStatusRequest != nil)
                                {
                                    twAPIClient.sendTwitterRequest(twStatusRequest) { (statusResponse, statusData, statusConnectionError) -> Void in
                                        if (statusConnectionError != nil) {
                                            print("Error posting status \(statusConnectionError)")
                                        } else {
                                            print("Successfully tweeted")
                                        }
                                    } // completion
                                }
                            } else {
                                print("Media_id not found in result = \(json)")
                            }
                        } else {
                            print("Error uploading image \(uploadConnectionError)")
                        }
                    } // completion
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
    
    func post() {
        let account = ACAccountStore()
        let accType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let msgToPost = msgTextView.text
        let img = UIImage(named: "test.jpg")
        let arrayOfAccounts = account.accounts
        for acc in arrayOfAccounts! {
            print(acc.username)
        }
        
        account.requestAccessToAccountsWithType(accType, options: nil, completion: {
            (granted: Bool, error: NSError?) in
            if granted == true {
                let arrayOfAcc = account.accountsWithAccountType(accType)
                if arrayOfAcc.count > 0 {
                    let acct = arrayOfAcc[0] as! ACAccount
                    
                    var parameters:Dictionary = Dictionary<String, String>()
                    // get image from bundle
                    let imageData : NSData = UIImageJPEGRepresentation(UIImage(named: "test.jpg")!, 0.1)!
                    
                    parameters["media"] = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                    //for uploading video would I just do this parameters["media'] = NSData.dataWithContentsOfMappedFile(url.relativePath!) as? NSData
                    let requestURL = NSURL(string: "https://upload.twitter.com/1.1/media/upload.json")
                    let postRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod(rawValue: 1)!, URL: requestURL, parameters: parameters as [NSObject : AnyObject])
                    postRequest.account = acct;
                    postRequest.performRequestWithHandler({
                        (responseData: NSData?, urlResponse: NSHTTPURLResponse?, error: NSError?) in
                        if (error == nil) {
                            // using SwiftyJSON to parse result
                            let json = JSON(data: responseData!)
                            // check for media id in result
                            if (json["media_id_string"].string != nil) {
                                print("result = \(json)")
                                // post a status with link to media
                                parameters = Dictionary<String, String>()
                                parameters["status"] = "Hey look at this google.com"
                                parameters["media_ids"] = json["media_id_string"].string!
                                let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
                                let postRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod(rawValue: 1)!, URL: requestURL, parameters: parameters as [NSObject : AnyObject])
                                postRequest.account = acct;
                                postRequest.performRequestWithHandler({
                                    (responseData: NSData?, urlResponse: NSHTTPURLResponse?, error: NSError?) in
                                    if error != nil {
                                        print(error?.description)
                                    } else {
                                        print("Tweet successful")
                                    }
                                })
                            } else {
                                print("Media_id not found in result = \(json)")
                            }
                        } else {
                            print("Error uploading image \(error)")
                        }
                    })
                    
//                    let message = NSMutableDictionary()
//                    message.setObject("\(msgToPost)", forKey: "status")
//                    let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
//                    let postRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod(rawValue: 1)!, URL: requestURL, parameters: message as [NSObject : AnyObject])
//                    postRequest.account = acct;
//                    postRequest.performRequestWithHandler({
//                        (responseData: NSData?, urlResponse: NSHTTPURLResponse?, error: NSError?) in
//                        if error != nil {
//                            print(error?.description)
//                        } else {
//                            print("Tweet successful")
//                        }
//                    })
                } else {
                    Twitter.sharedInstance().logInWithCompletion { session, error in
                        if (session != nil) {
                            print("signed in as \(session!.userName)");
                        } else {
                            print("error: \(error!.localizedDescription)");
                        }
                    }
                }
            }
        })
    }
    


}

