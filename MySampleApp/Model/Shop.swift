//
//  Shop.swift
//  MySampleApp
//
//  Created by Yeongwoo Kim on 2022/07/04.
//

import Foundation
import CoreLocation

struct Shop: Codable, Hashable {
    let serialNumber: Int
    let category: String
    let shopName: String
    let ownerName: String
    let country: String
    let address: String
    let latitude: Double
    let longitude: Double
    let phoneNumber: String
    let menu: String
    let price: String
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

