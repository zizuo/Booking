//
//  HotelCollectionViewCell.swift
//  Booking_demo
//
//  Created by Ata Ene on 3/21/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import UIKit
import SwiftyJSON

class HotelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var kilomtrLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var labelHotelName: UILabel!
    @IBOutlet weak var labelStar: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelBook: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    
    var radius: CGFloat = 1
    
    var productId: Int?
    var address: String?
    var city_id: String?
    var status: String?
    var decline_reason: String?
    var email: JSON?
    var img: JSON?
    var lat: String?
    var lng: String?
    var tel: JSON?
    var rating: Int?
    var title: String?
    var descr: String?
    var tags: JSON?
    
    
    override func prepareForReuse() {
        //        thumbImage.hnk_cancelSetImage()
    }
    
    func updateLayerProperties() {
        
        layer.cornerRadius = radius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        self.thumbImage.contentMode = .ScaleAspectFill
        self.thumbImage.clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5);
        layer.shadowOpacity = 0.3
        layer.shadowPath = shadowPath.CGPath
        
    }
}
