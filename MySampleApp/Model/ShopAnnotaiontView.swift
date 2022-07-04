//
//  ShopAnnotaiontView.swift
//  MySampleApp
//
//  Created by Yeongwoo Kim on 2022/07/04.
//

import Foundation
import MapKit

final class ShopAnnotationView: NSObject, MKAnnotation {
    let location: CLLocation
    var coordinate: CLLocationCoordinate2D {
        self.location.coordinate
    }
    
    init(location: CLLocation) {
        self.location = location
    }
}
