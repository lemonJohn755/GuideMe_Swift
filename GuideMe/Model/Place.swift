//
//  Place.swift
//  GuideMe
//
//  Created by John Chan on 7/9/2023.
//

import Foundation

import MapKit

struct Place: Identifiable, Hashable {
    
    let placemark: MKPlacemark
    
    let id = UUID()
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
}
