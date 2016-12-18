//
//  Constants.swift
//  UvaDining
//
//  Created by Justin Barry on 6/7/16.
//  Copyright © 2016 Justin Barry. All rights reserved.
//

import Foundation
import CloudKit

public struct Constants {
    static let meals: [String] = ["Breakfast", "Lunch", "Dinner"]
    
    static let database = CKContainer.defaultContainer().publicCloudDatabase
    //Key: Dining Hall
    //Value: ID used in the URL that correlates with the dining hall
    static let diningHall: [String: String] = ["Newcomb" : "704", "Ohill": "695", "Runk": "701"]
    //Key: Meal
    //Value: ID used in the URL that correlates with the meal
    static let periodIds: [String: String] = ["Breakfast": "1421", "Brunch" : "1422", "Lunch": "1423", "Dinner": "1424"]
    
    static let  dates: [String] = getDates()
    
    static let styler = NSDateFormatter()
    //The items app users don't care about
    static let unwantedFoods = ["American Cheese", "Cheddar Cheese", "Green Leaf Lettuce", "Tartar Sauce", "Iceberg Lettuce", "Expand All", "Collapse All", "View Selected Items", "Clear Selected", " ", "CONDIMENT (MIX): GRAVY - COUNTRY - DO NOT USE", "", "Shredded Cheddar Cheese", "Light Sour Cream", "Honey Mustard Dijon", "Light Mayonnaise", "Mayonnaise", "White Bread", "Whole Wheat Bread", "Yellow Mustard", "Dill Pickle Slices", "Pancake Syrup", "Banana Peppers", "Hummus","Kaiser Roll", "Oil & Vinegar", "Ranch Dressing", "Signature Chips", "Hoagie Roll", "Marble Rye Bread", "Shredded Carrots", "Lite Italian Dressing", "Cottage Cheese", "Swiss Cheese", "Alfredo Sauce", "Collard Greens", "Spaghetti Sauce", "Whipped Light Cream Cheese", "Whipped Margarine", "Balsamic Vinaigrette", "Citrus Water", "Creamy Caesar Dressing", "Croutons", "Fat-Free French Dressing", "Honey Mustard Dressing", "Light Ranch Dressing", "Toasted Barley", "Sunflower Seeds", "Romaine Lettuce"]
    
    //Key: Category on the Website
    //Value: Category on the App
    static let parsedmealCategories = ["Copper Hood": "Main Course", "Exhibition": "Main Course",
"Grill": "Main Course", "Home": "Main Course", "2 to 5 grill": "Main Course", "Home Zone": "Main Course", "Fire and Ice": "Main Course", "Deli": "Soup and Sandwitch","Soup": "Soup and Sandwitch", "Pasta": "Pasta", "Desserts": "Baked Goods","Dessert": "Baked Goods", "Pizza": "Pizza", "Salad Bar": "Salad Bar", "Exhibition Breakfast": "Omlette Options", "Mongolian": "Main Course", "Bake Shop": "Baked Goods", "Vegan": "Vegan Options", "Vegan Bar": "Vegan Options", "Fresh Market": "Salad Bar", "Grill Breakfast": "Omlette Options", "Deli Breakfast": "Cereals and Grains", "Saute": "Main Course", "Saute Breakfast": "Omlette Options"]
}
