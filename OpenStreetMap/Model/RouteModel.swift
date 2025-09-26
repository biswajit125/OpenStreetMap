//
//  RouteModel.swift
//  OpenStreetMap
//
//  Created by Clario_Mac_CSI-3 on 25/09/25.
//

import Foundation
import CoreLocation

struct Route {
    let coordinates: [CLLocationCoordinate2D]
}

struct Waypoint {
    let coordinate: CLLocationCoordinate2D
}
