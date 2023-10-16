//
//  DirectionSearchView.swift
//  GuideMe
//
//  Created by John Chan on 8/9/2023.
//

import SwiftUI
import MapKit
import _CoreLocationUI_SwiftUI

struct DirectionSearchView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var getRoutes: GetRoutes
    
    @State var region = MKCoordinateRegion()
    @State var pins : [Pin] = []
    
    var destination : Destination
    //    var origin : Origin
    
    var body: some View {
        
        //        NavigationView{
        GeometryReader { proxy in
            ScrollView{
                ZStack (alignment: .topTrailing){
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: pins){
                        MapMarker(coordinate: $0.coordinate)
                    }
                    .task {
                        let lat = locationManager.region.center.latitude
                        let long = locationManager.region.center.longitude
                        pins = [
                            Pin(name: "Your Locaiton", coordinate: CLLocationCoordinate2D(latitude:  lat , longitude: long)),
                            Pin(name: destination.name , coordinate: CLLocationCoordinate2D(latitude: destination.lat, longitude: destination.long))
                        ]
                        
                        region = fitPinsRegion(pins: pins)
                    }
                    
                    LocationButton(.currentLocation) {
                        print("Location btn tapped")
                        locationManager.requestAllowOnceLocationPermission()
                        region = locationManager.region
                    }
                    .font(.title3)
                    .cornerRadius(8)
                    .labelStyle(.iconOnly)
                    .symbolVariant(.circle)
                    .foregroundColor(Color.white)
                    .tint(Color.orange)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                }
                .frame(height: proxy.size.height * 0.4, alignment: .leading)
                
                // Start & Destination
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        VStack{
                            Label("Start", systemImage: "location.fill")
                                .labelStyle(.iconOnly)
                                .font(.title)
                            Text("Start")
                                .font(.callout)
                        }
                        VStack{
                            Label("Your location", systemImage: "pin.circle")
                                .frame( maxWidth: .infinity ,alignment: .leading)
                                .foregroundStyle(Color.blue)
                            Text(String(format: "%.5f", locationManager.region.center.latitude)+", "+String(format: "%.5f", locationManager.region.center.longitude))
                                .textSelection(.enabled)
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                                .frame( maxWidth: .infinity ,alignment: .leading)
                        }
                    }

                    HStack{
                        VStack{
                            Label("Destination", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                                .labelStyle(.iconOnly)
                                .font(.title)
                            Text("End")
                                .font(.callout)
                        }
                        VStack{
                            Text(destination.title)
                                .frame( maxWidth: .infinity ,alignment: .leading)
                            Text("\(destination.lat), \(destination.long)")
                                .frame( maxWidth: .infinity ,alignment: .leading)
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        .textSelection(.enabled)
                    }
                }
                .padding()

                Divider()
            
                // route list
                if (!getRoutes.routes.isEmpty){
                    Text("Results: \(getRoutes.routes.count)")
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ForEach (getRoutes.routes){ route in
                        NavigationLink(destination: ItinteryView(route: route)) {
                            RouteRowView(route: route)
                        }
                        Divider()

                    }
                    Text(getRoutes.routes.first?.copyrights ?? "")
                        .font(.caption)
                        .foregroundStyle(Color(.gray))
                }
                
            }

            .navigationTitle("Route Suggestion")
            .onAppear(){
                // Read sample API response
                getRoutes.fetchDemo(destination: destination, origin: Origin(lat: locationManager.region.center.latitude, long: locationManager.region.center.longitude))
                
                // Call Direction API
                //            getRoutes.fetch(destination: destination, origin: Origin(lat: locationManager.region.center.latitude, long: locationManager.region.center.longitude))
            }
        }
        
    }
    
    private func fitPinsRegion(pins : [Pin]) -> MKCoordinateRegion{
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



struct DirectionSearchView_Previews: PreviewProvider {
    
    static var previews: some View {
        @State var destination : Destination = Destination(name: "貝澳泳灘", title: "Pui O Beach Lantau Island", lat: 22.2398019, long: 113.9745063)
        @State var origin : Origin = Origin(lat: 22.32481920, long: 114.16901930)
        
        DirectionSearchView(destination: destination)
            .environmentObject(LocationManager())
            .environmentObject(GetRoutes(destination: destination, origin: origin))
        
    }
}

