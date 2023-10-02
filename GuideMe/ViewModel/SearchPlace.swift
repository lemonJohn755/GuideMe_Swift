//
//  SearchPlace.swift
//  GuideMe
//
//  Created by John Chan on 7/9/2023.
//

import Foundation
import MapKit
import Combine

class SearchPlace: ObservableObject{
    
    let locationManager = LocationManager()
    var cancellables = Set<AnyCancellable>()
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.defaultRegion()

    @Published var places: [Place] = []
    @Published var place: Place?
    
    init() {
        locationManager.$region.assign(to: \.region, on: self)
            .store(in: &cancellables)
    }

    
    func search(query: String) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = locationManager.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                let mapItems = response.mapItems
                self.places = mapItems.map {
                    Place(placemark: $0.placemark)
                }
            }
        }
    }
    
}
