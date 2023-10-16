//
//  CalculateFitRegion.swift
//  GuideMe
//
//  Created by John Chan on 16/10/2023.
//

import Foundation
import MapKit

struct CalculateFitRegion{
    
    func fitPolyline(decodedCoordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion{
        guard !decodedCoordinates.isEmpty else { return MKCoordinateRegion()}
                
//        var minLat = decodedCoordinates.first!.latitude
//        var maxLat = decodedCoordinates.first!.latitude
//        var minLon = decodedCoordinates.first!.longitude
//        var maxLon = decodedCoordinates.first!.longitude
        var avgLat = 0.0
        var avgLon = 0.0
//                
//        for pin in decodedCoordinates {
//            minLat = min(minLat, pin.latitude)
//            maxLat = max(maxLat, pin.latitude)
//            minLon = min(minLon, pin.longitude)
//            maxLon = max(maxLon, pin.longitude)
//            avgLat += pin.latitude
//            avgLon += pin.longitude
//            print("[\(pin.latitude),\(pin.longitude)],")
//        }
//        
//        avgLat = avgLat / Double(decodedCoordinates.count)
//        avgLon = avgLon / Double(decodedCoordinates.count)
        
        let minLat = min(decodedCoordinates.first!.latitude, decodedCoordinates.last!.latitude)
        let maxLat = max(decodedCoordinates.first!.latitude, decodedCoordinates.last!.latitude)
        let minLon = min(decodedCoordinates.first!.longitude, decodedCoordinates.last!.longitude)
        let maxLon = max(decodedCoordinates.first!.longitude, decodedCoordinates.last!.longitude)
        
        avgLat = (decodedCoordinates.first!.latitude + decodedCoordinates.last!.latitude) / 2.0
        avgLon = (decodedCoordinates.first!.longitude + decodedCoordinates.last!.longitude) / 2.0
        
        print("center \(avgLat),\(avgLon)")
        
        let center = CLLocationCoordinate2D(latitude: avgLat , longitude: avgLon)
        
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5 )
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    
    func fitPinsRegion(pins : [Pin]) -> MKCoordinateRegion{
        guard !pins.isEmpty else { return MKCoordinateRegion()}
        
        var minLat = pins.first!.coordinate.latitude
        var maxLat = pins.first!.coordinate.latitude
        var minLon = pins.first!.coordinate.longitude
        var maxLon = pins.first!.coordinate.longitude
        var avgLat = 0.0
        var avgLon = 0.0
        
        for pin in pins {
            let coordinate = pin.coordinate
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
            avgLat += coordinate.latitude
            avgLon += coordinate.longitude
            print("pin \(coordinate.latitude) \(coordinate.longitude)")
        }
        
        avgLat = avgLat / Double(pins.count)
        avgLon = avgLon / Double(pins.count)
        
        print("center \(avgLat),\(avgLon)")
        
        let center = CLLocationCoordinate2D(latitude: avgLat , longitude: avgLon)
        
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5 )
        
        return MKCoordinateRegion(center: center, span: span)
    }

}
