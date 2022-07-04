//
//  MapViewModel.swift
//  MySampleApp
//
//  Created by Yeongwoo Kim on 2022/07/04.
//

import Foundation
import CoreLocation

final class MapViewModel {
    @Published private(set) var locationAutorization: Bool = false
    @Published private(set) var initialLocation: CLLocation?
    private let locationManager = LocationManager()
    let model = MapModel()
    
    init() {
        configureBindings()
        configureLocationManager()
    }
    
    func configureBindings() {
        locationManager.locationAuthorizationEvent = { [weak self] bool in
            self?.locationAutorization = bool
        }
        locationManager.initialLocationEvent = { [weak self] location in
            self?.initialLocation = location
            
            if let self = self {
                for shop in self.getNearShopsFromUser() {
                    print("\(shop.shopName): \(self.getDistanceString(self.getDistanceFromUser(shop)))")
                }
            }
        }
    }
    
    func configureLocationManager() {
        locationManager.configureAutorization()
    }
    
    private func getDistanceFromUser(_ shop: Shop) -> CLLocationDistance {
        return initialLocation?.distance(from: shop.location) ?? -1
    }
    
    private func getDistanceString(_ distance: Double) -> String {
        return distance < 1000 ? String(format: "%.1f", distance) + "m" : String(format: "%.1f", distance / 1000) + "km"
    }
    
    func getNearShopsFromUser() -> [Shop] {
        model.shops
                .filter{ getDistanceFromUser($0) < 1000 }
                .sorted{ getDistanceFromUser($0) < getDistanceFromUser($1) }
    }
}
