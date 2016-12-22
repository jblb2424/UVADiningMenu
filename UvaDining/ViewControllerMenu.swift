//
//  ViewControllerRunk.swift
//  UvaDining
//
//  Created by Justin Barry on 7/21/16.
//  Copyright © 2016 Justin Barry. All rights reserved.
//
//
import Foundation
import UIKit
import Alamofire
import Fuzi

import CloudKit
import APHorizontalMenu


class ViewControllerRunk: UIViewController, MIResizableTableViewDelegate, MIResizableTableViewDataSource, APHorizontalMenuSelectDelegate

{
    
    
    //diningHall string value set based on what button is pressed in ViewControllerSelection
    var diningHall = ""
    
    var productsList: [[String: AnyObject]] = []
    
    //Initializes meal dictionaries as empty, so the user doesn't see a blank screen before the meals load
    var breakfastDict = ["category": "Breakfast", "products": []]
    
    var lunchDict = ["category": "Lunch", "products": []]
    
    var dinDict = ["category": "Dinner", "products": []]
    
    var brunchDict = ["category": "Brunch (Weekends Only)", "products": []]
    
    
    
    let horizontalMenuRunk: APHorizontalMenu = APHorizontalMenu(frame: CGRectMake(-10, 60, 470, 50))
    let weekDays = Constants.weekDays
    let dates = Constants.dates
    var monthAndDay: [String] = []
    
    
    
    
    
    let navyBlueColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 1)
    let baige = UIColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1)
    let betterGray = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    let barImage = UIImage(named: "NavBar")

    
    @IBOutlet weak var mealTable: MIResizableTableView!
    @IBOutlet weak var navBar: UINavigationBarTaller!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //Formats the information that will go into APHorizontal Menu(e.g Saturday, Dec.24)
        for i in 0...7 {
            let day = weekDays[i] + ", "
            let date = dates[i]
            let substringMonth = date.substringWithRange(Range<String.Index>(start: date.startIndex.advancedBy(5),end: date.startIndex.advancedBy(7)))
            let substringDay = date.substringWithRange(Range<String.Index>(start: date.startIndex.advancedBy(8),end: date.endIndex))
            let shortendMonth = day + Constants.shortendMonths[substringMonth]! + substringDay
            monthAndDay.append(shortendMonth)
        }
        
        
      
        navBar.frame.origin.y = -10
//        navBar.barTintColor = baige
        navBar.setBackgroundImage(barImage, forBarMetrics: .Default)

        
        
        //Customize the menu title
        titleLabel.text = diningHall
        titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 21)
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = CGSizeZero
        titleLabel.layer.shadowRadius = 2
        
        //Initialize productsList with dictionaries with no foods, for looks only
        productsList = [breakfastDict, lunchDict, dinDict, brunchDict]
        
        //MIR configuration
        self.mealTable.configureWithDelegate(self, andDataSource: self)
        self.mealTable.registerNib(ProductTableViewCell.cellNib(), forCellReuseIdentifier: ProductTableViewCell.cellIdentifier())
        
        //Initializes the APHorizontalMenu
        horizontalMenuRunk.delegate = self
        horizontalMenuRunk.values = monthAndDay
        self.view!.addSubview(horizontalMenuRunk)
        self.horizontalMenuRunk.selectedIndex = 0
        self.horizontalMenuRunk.cellBackgroundColor = betterGray
        self.horizontalMenuRunk.cellSelectedColor = navyBlueColor
        self.horizontalMenuRunk.textSelectedColor = UIColor.orangeColor()
        self.horizontalMenuRunk.textColor = UIColor.blackColor()
        
        
        //Grab today's menu, as the default day is today
        queryDatabase(0, hall: diningHall, dictionary: &productsList, UItable: mealTable) { dict in
            self.productsList = dict
        }
                
    }
    
    
    func horizontalMenu(horizontalMenu: AnyObject, didSelectPosition index: Int) {
        queryDatabase(index, hall: diningHall, dictionary: &productsList, UItable: mealTable) { dict in
            self.productsList = dict
        }
        
        NSLog("APHorizontalMenu selection: %d", index)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MIR DataSource
    func resizableTableView(resizableTableView: MIResizableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func resizableTableView(resizableTableView: MIResizableTableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSectionsInResizableTableView(resizableTableView: MIResizableTableView) -> Int {
        return self.productsList.count
    }
    
    func resizableTableView(resizableTableView: MIResizableTableView, numberOfRowsInSection section: Int) -> Int {
        return (self.productsList[section]["products"])!.count
    }
    
    func resizableTableView(resizableTableView: MIResizableTableView, viewForHeaderInSection section: Int) -> UIView? {
        var categoryDictionary: [NSObject : AnyObject] = self.productsList[section] as [NSObject : AnyObject]
        return CategoryView.getViewWithTitle((categoryDictionary["category"] as! String), andProductsNumber: (categoryDictionary["products"])!.count)
    }
    
    func resizableTableView(resizableTableView: MIResizableTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductTableViewCell = resizableTableView.dequeueReusableCellWithIdentifier(ProductTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! ProductTableViewCell
        let productDictionary = ((self.productsList[indexPath.section]["products"]) as! [[String: String]]) [indexPath.row]
        cell.configureWithProductTitle((productDictionary["title"]), description: (productDictionary["description"]), andPrice: (productDictionary["price"]))
        return cell
    }
    //MIR Delegate
    func resizableTableViewInsertRowAnimation() -> UITableViewRowAnimation {
        return .Fade
    }
    
    func resizableTableViewDeleteRowAnimation() -> UITableViewRowAnimation {
        return .Fade
    }
    
    func resizableTableViewSectionShouldExpandSection(section: Int) -> Bool {
        return true
    }
    
    func resizableTableView(tableView: MIResizableTableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedProduct = ((self.productsList[indexPath.section]["products"]) as! [[String: String]])[indexPath.row]
        let alertController: UIAlertController = UIAlertController(title: (selectedProduct["title"]), message: (selectedProduct["description"]), preferredStyle: .Alert)
//        alertController.addAction(UIAlertAction(title: "Buy for \(selectedProduct["price"] as! String)", style: .Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        self.presentViewController(alertController, animated: true, completion: {() -> Void in
            self.mealTable.deselectRowAtIndexPath(indexPath, animated: true)
        })
    }}

