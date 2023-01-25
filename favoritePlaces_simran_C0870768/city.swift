//
//  city.swift
//  favoritePlaces_simran_C0870768
//
//  Created by simran mehra on 2023-01-24.
//

import Foundation
import MapKit

class city : NSObject, MKAnnotation {
    
    var title: String?
    
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        
    }

}

