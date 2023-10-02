//
//  LocationManager.swift
//  GuideMe
//
//  Created by John Chan on 7/9/2023.
//

import Foundation
import CoreLocation
import MapKit

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension MKCoordinateRegion {
    
    static func defaultRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 22.30, longitude: 114.17), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
    
    static func regionFromLandmark(_ place: Place) -> MKCoordinateRegion {
        MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 22.3248192, longitude: 114.1690193), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Published var places : [Place] = []
    @Published var permissionDenied = false
    
    let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission(){
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation(){
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus{
        case .denied:
            print("Your have denied app to access location services.")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            ()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else{
            //show an error
            return
        }

        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
        print("current loc is \(latestLocation.coordinate.latitude), \(latestLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        print("error to locate")
    }
    
}
