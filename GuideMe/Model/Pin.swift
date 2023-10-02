//
//  Pin.swift
//  GuideMe
//
//  Created by John Chan on 26/9/2023.
//

import Foundation
import CoreLocation

struct Pin: Identifiable {
    let id = UUID()
    let name: String
//    let title: String
    let coordinate: CLLocationCoordinate2D
}
