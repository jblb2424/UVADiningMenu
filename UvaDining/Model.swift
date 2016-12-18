//
//  Model.swift
//  UvaDining
//
//  Created by Justin Barry on 5/30/16.
//  Copyright © 2016 Justin Barry. All rights reserved.
//

import Foundation
import CloudKit
import UIKit
import SVProgressHUD




//Delays the time(seconds) in which a certain action will occur inside the func
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
    }

//Returns an array of the week's dates. Used to find dates for Constants.dates(For simplicity)
func getDates() -> [String] {
    var dates: [String] = []

    Constants.styler.dateFormat = "yyyy-MM-dd"

    for i in 0...7 {
    let pastDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: i, toDate: NSDate(), options: NSCalendarOptions())!
    dates.append(Constants.styler.stringFromDate(pastDate))
    
    }
    return dates
}

//Reformats a list of dates(Constants.dates) to a list of string weekdays
func convertDatestoWeekDays(stringDates: [String]) -> [String]
{
    var weekDates: [String] = []

    for date in stringDates {
        let df  = NSDateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.dateFromString(date)!
        df.dateFormat = "EEEE"
        let formattedDate = df.stringFromDate(date);
    weekDates.append(formattedDate)
    }
    return weekDates
}
//Parameters: The menu extracted from the Cloukit Database, and the meal dict
    //Finds indexes of Categories like Copper Hood, Deli ect
    //...then returns the foods inbetween each category
func formatData(menu: [String], inout dict:[String:NSObject]) {
    
    //Temporary dictionary clone to do our work on, casted as an array of dictionaries
    //Used because we can't index with the datatype of our actual dictionaries
    var temporaryVariableDict = (dict["products"] as! [[String: String]])
    let category: String = dict["category"] as! String
    
    
    //Guards against the menu having no items for that day
    let menuCounter: Int? = menu.count
    //make it so that the dict for that day is deleted
    guard let menuCount = menuCounter where menuCount > 0 else {
        temporaryVariableDict = temporaryVariableDict.filter {$0["description"]! != ""}
        dict["products"] = temporaryVariableDict
        print("No foods to parse in \(category)")
        return
    }
    
    let indexFinder = {() -> [Int] in
        var indexes: [Int] = []
        //The keys of this dictionary are the categories on the website
        let presentCategories = Set(Constants.parsedmealCategories.keys).intersect(menu)
        
        for category in presentCategories {
            indexes.append(menu.indexOf(category)!)
        }
        return indexes.sort()
    }
    
    
    let indexes = indexFinder()
    
    for i in 0...(indexes.count) - 1 {
        var description: String = ""
        var title: String = ""
        var first_index: Int = 0
        var second_index: Int = 0
        
        //The last category has no category after it for reference
        //So we have to account for that
        if i != (indexes.count) - 1 {
            first_index = indexes[i]
            second_index = indexes[i + 1]
        } else if i == (indexes.count) - 1 {
            first_index = indexes[i]
            second_index = (menu.count) - 1
        }
        
        description += (menu[first_index + 1...second_index - 1]).joinWithSeparator(", ")
        title = menu[first_index] //first_index is the category of the description
        
        //Exhibiton/Grill/Deli goes to different places depending on which meal we are eating
        //Appends "Breakfast" to end of category to specifiy if this is the case
        //See Constants.parsedmealCategories
        if (title == "Exhibition" || title == "Grill" || title == "Deli" || title == "Saute") && category == "Breakfast" {
            title = title + " " + category
        }
        //if statements to prevent the app from crashing if the website categories change
        if let titleFromDict: String = Constants.parsedmealCategories[title] {
            
            let index = temporaryVariableDict.indexOf{$0["title"] == titleFromDict}
            if index != nil {
                var formattedDescription = temporaryVariableDict[index!]["description"]! + ", " +  description
                //Gets rid of extraneuous ", " at beggining of description string
                if temporaryVariableDict[index!]["description"]! == "" {
                    formattedDescription = String(formattedDescription.characters.dropFirst())
                    formattedDescription = String(formattedDescription.characters.dropFirst())
                }
                
                temporaryVariableDict[index!]["description"] = formattedDescription
                
            } else {
                print(title)
            }
            
        } else {
        
        print("This will never happen" + title)
        }

    }
    //Filter out any reamining category description that had no content added to them
    temporaryVariableDict = temporaryVariableDict.filter {$0["description"]! != ""}
    //Finally, save our changes to the actual meal dictionary
    dict["products"] = temporaryVariableDict
    

}
    //Simple function to check if an item is in the unwanted food list
    //if it is, remove item
    //unwanted foods also includes extra junk leftover from parsing the wbesite
    func removeUnwantedFoods(inout foodArray: [String]) {
        for unwantedfood in Constants.unwantedFoods {
            if foodArray.contains(unwantedfood) {
                foodArray.removeAtIndex(foodArray.indexOf(unwantedfood)!)
            }
        }
    }


func newAddRecords(date: String = Constants.dates[7]) {
    let today = Constants.dates[0]
    //You can add whatever date you want to parse (in case you miss a day) but the default is next week's date
    let dateInput = date
    var location: String
    var period_id: String
    
    for (meal, mealId) in Constants.periodIds {
        for (hall, hallId) in Constants.diningHall {
            location = hallId
            period_id = mealId
            //Url template is continuously opened based on the changing meals and halls
            let Url = "http://virginia.campusdish.com/Commerce/Catalog/Menus.aspx?LocationId=\(location)&PeriodId=\(period_id)&MenuDate=\(dateInput)&UIBuildDateFrom=\(today)"
            let foodArray: [String] = Url.getFoodList()
            let idName = hall + dateInput + meal
            let iD = CKRecordID(recordName: idName)
            
            let saveToDatabase = {()  in
                //See "Extensions" file for getFoodList function
                let myRecord = CKRecord(recordType: "FoodData", recordID: iD)
                myRecord.setObject(dateInput, forKey: "Date")
                myRecord.setObject(hall, forKey: "DiningHall")
                myRecord.setObject(meal, forKey: "Meal")
                myRecord.setObject(foodArray, forKey:"FoodList")
                
                Constants.database.saveRecord(myRecord, completionHandler:
                    ({returnRecord, error in
                        if let err = error {
                            print(err.localizedDescription)
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                print("Record saved successfully")
                            }
                        }
                    }))
                
                }
         saveToDatabase()
        }
    }
}


//Configure the Array of Records from Yesterday
//Default record day to delete is yesterday
//Cannot delete records of upcoming dates
func newDeleteRecord(daysAgo: Int = 1) {
    
    //Guard statement to prevent passing negative days ago as the parameter
    //This would result in a double negative, and a record for future days would be deleted rather than past days
    let formattedDaysAgo: Int? = -(daysAgo)
    guard let checkDate = formattedDaysAgo where checkDate < 0 else {
        print("invalid number")
        return
    }
    
    var oldRecords: [CKRecordID]  = []
    Constants.styler.dateFormat = "yyyy-MM-dd"
    let pastFormat = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -(daysAgo), toDate: NSDate(), options: NSCalendarOptions())!
    let past = Constants.styler.stringFromDate(pastFormat)
    

    
    for meal in Constants.periodIds.keys {
        for hall in Constants.diningHall.keys {
            let recordString = hall + String(past) + meal
            oldRecords.append(CKRecordID(recordName: recordString))
        }
    }
    print(oldRecords)
    print(oldRecords.count)
    //Delete all Records in the Array
    let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: oldRecords)
    operation.savePolicy = .AllKeys
    operation.modifyRecordsCompletionBlock = { added, deleted, error in
        if error != nil {
            print(error?.description) // print error if any
        } else {
            // no errors, all set!
            print(deleted)
        }
    }
    Constants.database.addOperation(operation)
}



typealias theDict = [[String: AnyObject]] -> ()

//index is used to identify dates in Constants.database
func queryDatabase(index: Int, hall: String, inout dictionary: [[String: AnyObject]],  UItable: MIResizableTableView, completion: theDict) {
    var newProductsList: [[String: AnyObject]] = []
    let date = String(getDates()[index])
//The predicate searches the database for records that have the correct date and dining hall
    let predicate = NSPredicate(format: "Date == %@ AND DiningHall == %@",date, hall )
    
    var breakfastDict = ["category": "Breakfast", "products": [["title": "Main Course", "description": "", "price": "12€"], ["title": "Omlette Options", "description": "", "price": "11.3€"], ["title": "Baked Goods", "description": "", "price": "10.4€"],["title": "Salad Bar", "description": "", "price": "12€"], ["title": "Vegan Options", "description": "", "price": "12€"], ["title": "Omlette Options", "description": "", "price": "11.3€"], ["title": "Cereals and Grains", "description": "", "price": "16€"]]]
    
    var lunchDict = ["category": "Lunch", "products": [["title": "Main Course", "description": "", "price": "12€"], ["title": "Pizza", "description": "", "price": "11.3€"], ["title": "Soup and Sandwitch", "description": "", "price": "10.4€"], ["title": "Pasta", "description": "", "price": "16€"],["title": "Salad Bar", "description": "", "price": "12€"],["title": "Vegan Options", "description": "", "price": "12€"], ["title": "Omlette Options", "description": "", "price": "11.3€"], ["title": "Baked Goods", "description": "", "price": "12€"]]]
    
    var dinDict = ["category": "Dinner", "products": [["title": "Main Course", "description": "", "price": "12€"], ["title": "Pizza", "description": "", "price": "11.3€"], ["title": "Soup and Sandwitch", "description": "", "price": "10.4€"], ["title": "Pasta", "description": "", "price": "16€"],["title": "Salad Bar", "description": "", "price": "12€"],["title": "Vegan Options", "description": "", "price": "12€"], ["title": "Omlette Options", "description": "", "price": "11.3€"], ["title": "Baked Goods", "description": "", "price": "12€"]]]
    
    var brunchDict = ["category": "Brunch (Weekends Only)", "products": [["title": "Main Course", "description": "", "price": "12€"], ["title": "Pizza", "description": "", "price": "11.3€"], ["title": "Soup and Sandwitch", "description": "", "price": "10.4€"], ["title": "Pasta", "description": "", "price": "16€"],["title": "Salad Bar", "description": "", "price": "12€"],["title": "Vegan Options", "description": "", "price": "12€"], ["title": "Omlette Options", "description": "", "price": "11.3€"], ["title": "Baked Goods", "description": "", "price": "12€"]]]

    
    let query = CKQuery(recordType: "FoodData", predicate: predicate)
    // get just one value only
    let operation = CKQueryOperation(query: query)

    operation.desiredKeys = ["FoodList", "Meal", "Date"]
    SVProgressHUD.show() //Shows loading wheel 
    // get query
    operation.recordFetchedBlock = { (record : CKRecord) in
        // process record
        //print(record.objectForKey("FoodList") as! [String])
        var menu = record.objectForKey("FoodList") as! [String]
        removeUnwantedFoods(&menu)
        
        switch record.objectForKey("Meal") != nil {
            case record.objectForKey("Meal") as! String == "Lunch" :
                formatData(menu, dict: &lunchDict)
            case record.objectForKey("Meal") as! String == "Breakfast" :
                formatData(menu, dict: &breakfastDict)
            case record.objectForKey("Meal") as! String == "Dinner" :
                formatData(menu, dict: &dinDict)
            case record.objectForKey("Meal") as! String == "Brunch" :
                formatData(menu, dict: &brunchDict)
            default :
                print("Meal does not exist!")
            }
    }

    // operation completed
    operation.queryCompletionBlock = {(cursor, error) in
        dispatch_async(dispatch_get_main_queue()) {
            if error == nil {
                
                print("no errors")
                // code here
                //Configures the MIResizableTableView
                //Dictionary values are passed to the completion handler
                newProductsList = [breakfastDict, lunchDict, dinDict, brunchDict]
                completion(newProductsList)
                UItable.reloadData()
                SVProgressHUD.dismiss()
                
            } else {
                
                print("error description = \(error?.description)")
            }
        }
    }
    Constants.database.addOperation(operation)
}

func modifyRecord(date: String = Constants.dates[0]) {
    let today = Constants.dates[0]
    //You can add whatever date you want to parse (incase you miss a day) but the default is next week's date
    let dateInput = date
    var location: String
    var period_id: String
    
    for (meal, mealId) in Constants.periodIds {
        for (hall, hallId) in Constants.diningHall {
            location = hallId
            period_id = mealId
            //Url template is continuously opened based on the changing meals and halls
            let Url = "http://virginia.campusdish.com/Commerce/Catalog/Menus.aspx?LocationId=\(location)&PeriodId=\(period_id)&MenuDate=\(dateInput)&UIBuildDateFrom=\(today)"
            let foodArray: [String] = Url.getFoodList()
            let idName = hall + dateInput + meal
            let iD = CKRecordID(recordName: idName)
            
            Constants.database.fetchRecordWithID(iD, completionHandler: { (myrecord, error) in
                if error != nil {
                    print("Error fetching record: \(error!.localizedDescription)")
                } else {
                    // Now you have grabbed your existing record from iCloud
                    // Apply whatever changes you want
                     myrecord!.setObject(foodArray, forKey:"FoodList")
                    
                    // Save this record again
                    Constants.database.saveRecord(myrecord!, completionHandler: { (savedRecord, saveError) in
                        if saveError != nil {
                            print("Error saving record: \(saveError!.localizedDescription)")
                        } else {
                            print("Successfully updated record!")
                        }
                    })
                }
            })
        }
    }
}