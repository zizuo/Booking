//
//  User.swift
//  Booking_demo
//
//  Created by Ulukbek Saiipov on 2/24/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import Foundation
import CVCalendarKit

class User {
    static let sharedInstance = User()
    
    var isLoggedIn : Bool
    var id : Int
    var login : String
    var token : String
    var gender : String
    var name : String
    var lastName : String
    var email : String
    var isSmoking : Bool
    var preferedNumOfStars : String
    var preferedComfort : String
    var phone : String
    var birthDate : String
    var priceRange : String
    var pictureUser : String
    var dateIn : NSDate!
    var dateOut : NSDate!
    var sort : Int
    var geo : String
    var price : Int
    var rating : Int
    
    init() {
        isLoggedIn = false
        id = Int()
        login = ""
        token = ""
        gender = ""
        name = ""
        lastName = ""
        email = ""
        isSmoking = false
        preferedNumOfStars = "Любое"
        preferedComfort = ""
        phone = ""
        birthDate = ""
        priceRange = "Бюджет"
        pictureUser = ""
        dateIn = NSDate()
        dateOut = dateIn.day + 2
        sort = 1
        geo = ""
        price = 20000
        rating = 1
    }
}