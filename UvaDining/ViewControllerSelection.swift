//
//  ViewControllerSelection.swift
//  UvaDining
//
//  Created by Justin Barry on 6/7/16.
//  Copyright © 2016 Justin Barry. All rights reserved.
//

import Foundation
import UIKit

class SelectionScreen: UIViewController {
    
    let navyBlueColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 1)
    let smokeyGrayColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    @IBOutlet var backround: UIView!
    @IBOutlet weak var navBar: UINavigationBarTaller!
    @IBOutlet weak var backgroundChoiceMenu: UIImageView!
    
    var diningHallSelection = "Runk" //Tells the menu view what dining hall we pressed
    
    
    @IBAction func ohillButton(sender: AnyObject) {
        diningHallSelection = "Ohill"
        
       
    }
    @IBAction func runkbutton(sender: AnyObject) {
        diningHallSelection = "Runk"
    }
    
    @IBAction func newcombButton(sender: AnyObject) {
        diningHallSelection = "Newcomb"
        
    }
    
    @IBAction func aboutButton(sender: AnyObject) {
        diningHallSelection = "About"
    }
    
    
    override func viewDidLoad() {
        backround.backgroundColor = smokeyGrayColor
        
//        navBar.frame.origin.y = -10
//        navBar.barTintColor = navyBlueColor
//        navBar.backgroundColor = navyBlueColor

//        let backgroundChoiceMenu = UIImageView(frame: CGRectMake(0, 0, 375, 667));
//        let image = UIImage(named: "Opening");
//        backgroundChoiceMenu.image = image;
//        self.view.addSubview(backgroundChoiceMenu)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if diningHallSelection != "About" {
            let destinationController: ViewControllerRunk = segue.destinationViewController as! ViewControllerRunk
            
            destinationController.diningHall = diningHallSelection
        }
    }
}
