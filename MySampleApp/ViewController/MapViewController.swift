//
//  MapViewController.swift
//  MySampleApp
//
//  Created by Yeongwoo Kim on 2022/07/04.
//

import UIKit
import MapKit
import Combine

final class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let mapViewModel = MapViewModel()
    private var observers: Set<AnyCancellable> = []
    
    lazy var changeCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Category", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(changeCategory), for: .touchUpInside)
        return button
    }()
    
    lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: self.mapView)
        button.isHidden = true
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureMapView()
        configureBindings()
        addAnnotation()
    }
    
    private func configureView() {
        mapView.addSubview(userTrackingButton)
        mapView.addSubview(changeCategoryButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.widthAnchor.constraint(equalToConstant: 50),
            userTrackingButton.heightAnchor.constraint(equalToConstant: 50),
            userTrackingButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -50),
            userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50),
            
            changeCategoryButton.widthAnchor.constraint(equalToConstant: 50),
            changeCategoryButton.heightAnchor.constraint(equalToConstant: 50),
            changeCategoryButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 50),
            changeCategoryButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50),
        ])
    }
    
    private func configureMapView() {
//        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsUserLocation = true
    }
    
    private func configureBindings() {
        mapViewModel.$locationAutorization
            .sink { [weak self] bool in
                self?.userTrackingButton.isHidden = !bool
            }
            .store(in: &self.observers)
        mapViewModel.$initialLocation
            .sink { [weak self] location in
                self?.configureLocation(location)
            }
            .store(in: &self.observers)
    }
    
    private func configureLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    private func removeAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func addAnnotation(category: ShopCategory? = nil) {
        if category == nil {
            mapView.addAnnotations(mapViewModel.model.shops.map{ ShopAnnotationView(location: $0.location) })
        } else {
            mapView.addAnnotations(mapViewModel.model.shops.filter{ category!.isShopIncludedCategory(subCategory: $0.category) }.map{ ShopAnnotationView(location: $0.location) })
        }
    }
    
    @objc private func changeCategory() {
        self.removeAnnotation()
        self.addAnnotation(category: .hair)
    }
}
