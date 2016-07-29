//
//  Hotel.swift
//  Booking_demo
//
//  Created by Ata Ene on 3/24/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import Foundation
import SwiftyJSON

class Hotel {
    let hotel_id : Int
    let address : String
    let admin : String
    let city_id : String
    let status : Int
    let decline_reason : String
    let email : JSON
    let img : JSON
    let lat : Double
    let lng : Double
    let tel : JSON
    let rating : Int
    let title : String
    let descr : String
    let tag : JSON

    convenience init(hotelJSON: JSON) {
        self.init(hotel_id: hotelJSON["_id"], address: hotelJSON["address"], admin: hotelJSON["admin"], city_id: hotelJSON["city_id"], status: hotelJSON["status"], decline_reason: hotelJSON["decline_reason"], email: hotelJSON["email"], img: hotelJSON["img"], lat: hotelJSON["lat"], lng: hotelJSON["lng"], tel: hotelJSON["tel"], rating: hotelJSON["rating"], title: hotelJSON["title"], descr: hotelJSON["descr"], tag: hotelJSON["tag"])
    }
    
    init(hotel_id: JSON, address: JSON, admin: JSON, city_id: JSON, status: JSON, decline_reason: JSON, email: JSON, img: JSON, lat: JSON, lng: JSON, tel: JSON, rating: JSON, title: JSON, descr: JSON, tag: JSON) {
        
        self.hotel_id = hotel_id.intValue
        self.address = address.stringValue
        self.admin = admin.stringValue
        self.city_id = city_id.stringValue
        self.status = status.intValue
        self.decline_reason = decline_reason.stringValue
        self.email = email
        self.img = img
        self.lat = lat.doubleValue
        self.lng = lng.doubleValue
        self.tel = tel
        self.rating = rating.intValue
        self.title = title.stringValue
        self.descr = descr.stringValue
        self.tag = tag

        
    }
}