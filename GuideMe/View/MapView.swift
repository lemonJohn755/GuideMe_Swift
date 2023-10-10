//
//  MapView.swift
//  GuideMe
//
//  Created by John Chan on 10/10/2023.
//

import SwiftUI
import MapKit
import _CoreLocationUI_SwiftUI

struct MapView: View{
    @EnvironmentObject var locationManager: LocationManager
    //    @State var region : MKCoordinateRegion = MKCoordinateRegion()
    @State private var region : MKCoordinateRegion = MKCoordinateRegion()
    
    var body: some View {
        ZStack (alignment: .topTrailing){
            Map(coordinateRegion: $region, showsUserLocation: true)
                .task{
                    region = locationManager.region
                }
            
            LocationButton(.currentLocation) {
                print("Location btn tapped")
                locationManager.requestAllowOnceLocationPermission()
                region = locationManager.region
            }
            .font(.title2)
            .cornerRadius(8)
            .labelStyle(.iconOnly)
            .symbolVariant(.circle)
            .foregroundColor(Color.white)
            .tint(Color.orange)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
        }
        
    }
    
}

