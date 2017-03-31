//
//  Cokelocation.swift
//  Cokelocation
//
//  Created by Ken Moody on 3/25/17.
//  Copyright © 2017 iMoodyStudios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CokeAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title :String?, subtitle :String?) {
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        
    }

}
