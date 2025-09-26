//
//  MapViewModel.swift
//  OpenStreetMap
//
//  Created by Clario_Mac_CSI-3 on 25/09/25.
//

import Foundation
import CoreLocation

class MapViewModel {
    
    private(set) var route: Route?
    private var currentIndex = 0
    private var timer: Timer?
    
    // Callbacks for ViewController
    var onRouteFetched: ((Route) -> Void)?
    var onCarMoved: ((CLLocationCoordinate2D) -> Void)?
    
    // MARK: - Fetch Route from OSRM
    func fetchRoute(waypoints: [Waypoint]) {
        guard waypoints.count >= 2 else { return }
        
        let coordsStr = waypoints
            .map { "\($0.coordinate.longitude),\($0.coordinate.latitude)" }
            .joined(separator: ";")
        
        let urlStr = "https://router.project-osrm.org/route/v1/driving/\(coordsStr)?geometries=geojson"
        guard let url = URL(string: urlStr) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let routes = json["routes"] as? [[String: Any]],
               let geometry = routes.first?["geometry"] as? [String: Any],
               let coords = geometry["coordinates"] as? [[Double]] {
                
                let coordinates = coords.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }
                let route = Route(coordinates: coordinates)
                self.route = route
                
                DispatchQueue.main.async {
                    self.onRouteFetched?(route)
                }
            }
        }.resume()
    }
    
    // MARK: - Animate Car
    func startCarAnimation(interval: TimeInterval = 2.0) {
        guard let route = route, !route.coordinates.isEmpty else { return }
        
        currentIndex = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.moveCar()
        }
    }
    
    private func moveCar() {
        guard let route = route else { return }
        
        guard currentIndex + 1 < route.coordinates.count else {
            timer?.invalidate()
            return
        }
        
        currentIndex += 1
        let nextCoord = route.coordinates[currentIndex]
        
        DispatchQueue.main.async {
            self.onCarMoved?(nextCoord)
        }
    }
}
