//
//  File.swift
//  UvaDining
//
//  Created by Justin Barry on 4/27/16.
//  Copyright © 2016 Justin Barry. All rights reserved.
//

import Foundation
import Alamofire
import Fuzi



extension String {
    func getFoodList() -> [String] {
        var foodString = ""
        var foodArray = [String]()
        var stringHtml = ""
        let link = self
        
    
        guard let myURL = NSURL(string: link) else {
            print("Error: \(link) doesn't seem to be a valid URL")
            return foodArray
        }
        
        do {
            let myHTMLString = try String(contentsOfURL: myURL)
            stringHtml = myHTMLString
            
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
        
        let html = stringHtml
        do {
            // if encoding is omitted, it defaults to
            let doc = try? HTMLDocument(string: html, encoding: NSUTF8StringEncoding)
            
            // CSS queries
            if let elementById = doc!.firstChild(css: "#RenderMenuDetailsSection") {
                foodString = elementById.stringValue
                //print(elementById.stringValue)
                
            }
            // Getting rid of spacing issues
            foodString = foodString.stringByReplacingOccurrencesOfString("\r\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            //Appending food items to list
            foodArray = foodString.componentsSeparatedByString("  ")
            //Removing empty strings in the list
            foodArray = foodArray.filter { $0 != "" }
        }
        removeUnwantedFoods(&foodArray)
        return foodArray
    }
}



      