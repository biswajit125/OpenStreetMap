//
//  AppConstants.swift
//  OpenStreetMap
//
//  Created by Prashant Kumar on 26/09/25.
//

import Foundation


import Foundation
import CoreLocation
import UIKit


enum AppConfig {
    static let mapStyleURL = "https://api.maptiler.com/maps/basic/style.json?key=t9EgukvkPbgxjCnj8lUP"
}

enum DefaultCoordinates {
    static let delhi = CLLocationCoordinate2D(latitude: 28.6138954, longitude: 77.2090057)
    static let chandigarh = CLLocationCoordinate2D(latitude: 30.7334421, longitude: 76.7797143)
    static let haridwar = CLLocationCoordinate2D(latitude: 29.9457, longitude: 78.1642)
    static let dehradun = CLLocationCoordinate2D(latitude: 30.3165, longitude: 78.0322)
}

enum Constants {
    static let carAnnotationIdentifier = "car"
    static let carIconSize: CGSize = CGSize(width: 32, height: 32)
    static let carAnimationDuration: TimeInterval = 2.0
}



