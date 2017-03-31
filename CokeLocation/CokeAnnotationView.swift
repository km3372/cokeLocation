//
//  CokeAnnotationView.swift
//  Cokelocation
//
//  Created by Ken Moody on 3/26/17.
//  Copyright © 2017 iMoodyStudios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CokeAnnotationView: MKAnnotationView {
    
   
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        var frame = self.frame
        frame.size = CGSize(width: 80, height: 80)
        self.frame = frame
        self.backgroundColor = UIColor.clear
        self.centerOffset = CGPoint(x: -5, y: -5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        UIImage(named: "Coke.png")?.draw(in: CGRect(x: 30, y: 30, width: 30, height: 30))
        
    }
    
    
}
