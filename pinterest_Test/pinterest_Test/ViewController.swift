//
//  ViewController.swift
//  pinterest_Test
//
//  Created by synerzip on 30/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import UIKit
import PinterestSDK

class ViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var messageTextView: UITextView!
    var board: PDKBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func shareAction(sender: AnyObject) {
        authenticateAction()
//        createBoardAction()

    }
    
    func authenticateAction() {
        PDKClient.sharedInstance().authenticateWithPermissions([PDKClientReadPublicPermissions,
            PDKClientWritePublicPermissions,
            PDKClientReadPublicPermissions,
            PDKClientReadPrivatePermissions,
            PDKClientWritePrivatePermissions,
            PDKClientReadRelationshipsPermissions,
            PDKClientWriteRelationshipsPermissions],
            withSuccess: {
                (responseObject: PDKResponseObject?) in
                print("\(responseObject?.user().firstName) authenticated")
                self.getboards()
            }, andFailure: {
                (error: NSError?) in
                print(error)
        })
    }
    
    func getboards() {
        
        PDKClient.sharedInstance().getPath("https://api.pinterest.com/v1/me/boards/", parameters: nil, withSuccess: {
            (response: PDKResponseObject?) in
                let boards = response?.boards()
                self.board = boards?.last as! PDKBoard
                self.pinItAction()
            }, andFailure: {
                (error:NSError?) in
                print(error)
        })
    }
    
    func create(name: String) {
        PDKClient.sharedInstance().createBoard(name, boardDescription: "test board for testing purpose", withSuccess: {
            (response: PDKResponseObject?) in
                print("\(response?.board().name) board created")
                self.board = response?.board()
                self.pinItAction()
            }, andFailure: {
                (error: NSError?) in
                print(error)
        })
        
    }
    
    func createBoardAction() {
        let createBoardAlert = UIAlertController(title: "Create Board", message: "Enter Board Name", preferredStyle: .Alert)
        let createAction =  UIAlertAction(title: "Create", style: .Default, handler: {(action: UIAlertAction!) -> Void in
            let textField = createBoardAlert.textFields![0] as UITextField
            self.create(textField.text!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in }
        
        createBoardAlert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in }
        createBoardAlert.addAction(createAction)
        createBoardAlert.addAction(cancelAction)
        presentViewController(createBoardAlert, animated: true, completion: nil)
    }
    
    func pinItAction() {
        let parameters = NSMutableDictionary()
        parameters.setValue(board.identifier, forKey: "board")
        parameters.setValue("this is test pin", forKey: "note")
        parameters.setValue("https://www.pinterest.com", forKey: "link")
        parameters.setValue("https://about.pinterest.com/sites/about/files/logo.jpg", forKey: "image_url")
//        let imageData : NSData = UIImageJPEGRepresentation(UIImage(named: "test.jpg")!, 0.1)!
//        parameters.setValue(imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)), forKey: "image_base64")
        PDKClient.sharedInstance().postPath("https://api.pinterest.com/v1/pins/",
            parameters: parameters as [NSObject : AnyObject],
            withSuccess: {
                _ in
                print("Pinned")
            },
            andFailure: {
                (error: NSError?) in
                print(error)
        })
    }
}

