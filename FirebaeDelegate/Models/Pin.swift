//
//  Pin.swift
//  FirebaeDelegate
//
//  Created by C4Q on 11/20/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreLocation
import MapKit
import Contacts

class Pin: NSObject, MKAnnotation {
    
    let title: String?
    let creatorID: String
    let lat: Double
    let long: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    init(title: String, creatorID: String, lat: Double, long: Double) {
        self.title = title
        self.creatorID = creatorID
        self.lat = lat
        self.long = long
    }
    
    init?(from dict: [String: Any]) {
        guard let title = dict["title"] as? String,
        let creatorID = dict["creatorID"] as? String,
        let lat = dict["lat"] as? Double,
        let long = dict["long"] as? Double
            else {return nil}
        self.title = title
        self.creatorID = creatorID
        self.lat = lat
        self.long = long
        
    }
    
    
    var fieldsDict: [String: Any] {
        return ["title": self.title,
                "creatorID": self.creatorID,
                "lat": self.lat,
                "long": self.long]
    }
    
    public func getMapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    
}


