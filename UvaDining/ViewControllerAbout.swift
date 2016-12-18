//
//  BackDoor.swift
//  UvaDining
//
//  Created by Justin Barry on 6/7/16.
//  Copyright © 2016 Justin Barry. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Fuzi
import CloudKit

class ViewControllerAbout: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var adminInput: UITextField!
    
    override func viewDidLoad() {
        adminInput.delegate = self
        let backgroundChoiceMenu = UIImageView(frame: CGRectMake(0, 0, 375, 667));
        let image = UIImage(named: "About");
        backgroundChoiceMenu.image = image;
        self.view.addSubview(backgroundChoiceMenu) 
        self.view.addSubview(adminInput)
    }
    
    //Lets the user submit their admin key using the return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    @IBAction func processDataFromKey(sender: AnyObject) {
        if adminInput.text == "k2rkent2424" {
            print("Admin successfully accessed")
            let alertController: UIAlertController = UIAlertController(title: ("Welcome Admin"), message: ("Records are Being Updated for Today! Please check with JB if the records don't look like they were updated. Thanks!"), preferredStyle: .Alert)
            //        alertController.addAction(UIAlertAction(title: "Buy for \(selectedProduct["price"] as! String)", style: .Default, handler: nil))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: {() -> Void in })
            
            
            //Update the database for today
            newDeleteRecord()
            newAddRecords()
            modifyRecord()


//            for i in 0...7 {
//                newDeleteRecord(i)
////                newAddRecords(Constants.dates[i])
////                modifyRecord(Constants.dates[i])
            }

        }
        
}
    
    
    
    
    
    





