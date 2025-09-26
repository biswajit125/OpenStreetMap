//
//  ViewController.swift
//  OpenStreetMap
//
//  Created by Clario_Mac_CSI-3 on 25/09/25.
//

import UIKit
import MapLibre

class ViewController: UIViewController, MLNMapViewDelegate {
    // MARK: - Properties
    private var mapView: MLNMapView!
    private var carAnnotation: MLNPointAnnotation?
    private let viewModel = MapViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        bindViewModel()
        setupWaypointsAndRoute()
    }
    
    // MARK: - Setup Map
    private func setupMap() {
        mapView = MLNMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = URL(string: AppConfig.mapStyleURL)
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onRouteFetched = { [weak self] route in
            self?.drawRoute(route.coordinates)
            self?.addCarMarker(route.coordinates.first!)
            self?.viewModel.startCarAnimation()
        }
        viewModel.onCarMoved = { [weak self] coordinate in
            self?.moveCar(to: coordinate)
        }
    }
    
    // MARK: - Setup Waypoints & Route
    private func setupWaypointsAndRoute() {
        let waypoints = [
            Waypoint(coordinate: DefaultCoordinates.delhi),
            Waypoint(coordinate: DefaultCoordinates.chandigarh)
        ]
        // Center map on first waypoint
        mapView.setCenter(waypoints[0].coordinate, zoomLevel: 9, animated: false)
        // Fetch route
        viewModel.fetchRoute(waypoints: waypoints)
    }
    
    // MARK: - Drawing
    private func drawRoute(_ coords: [CLLocationCoordinate2D]) {
        let polyline = MLNPolyline(coordinates: coords, count: UInt(coords.count))
        mapView.addAnnotation(polyline)
    }
    
    private func addCarMarker(_ coordinate: CLLocationCoordinate2D) {
        let annotation = MLNPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = Constants.carAnnotationIdentifier
        carAnnotation = annotation
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Update Car
    private func moveCar(to coordinate: CLLocationCoordinate2D) {
        guard let car = carAnnotation else { return }
        UIView.animate(withDuration: Constants.carAnimationDuration, delay: 0, options: .curveLinear, animations: {
            car.coordinate = coordinate
            self.mapView.setCenter(coordinate, animated: true)
        }, completion: nil)
    }
    
    // MARK: - Car Marker View
    func mapView(_ mapView: MLNMapView, viewFor annotation: MLNAnnotation) -> MLNAnnotationView? {
        if annotation.title == Constants.carAnnotationIdentifier {
            let view = MLNAnnotationView(reuseIdentifier: Constants.carAnnotationIdentifier)
            let imageView = UIImageView(image: UIImage(systemName: "car.fill"))
            imageView.tintColor = .red
            imageView.frame = CGRect(origin: .zero, size: Constants.carIconSize)
            view.addSubview(imageView)
            view.bounds = imageView.bounds
            return view
        }
        return nil
    }
}
