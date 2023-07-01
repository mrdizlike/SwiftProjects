//
//  Capital.swift
//  Project15
//
//  Created by Виктор on 12.03.2023.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordingate: CLLocationCoordinate2D, info: String){
        self.title = title
        self.coordinate = coordingate
        self.info = info
    }

}
