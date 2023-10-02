//
//  ContentView.swift
//  GuideMe
//
//  Created by John Chan on 7/9/2023.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct ContentView: View {
    @EnvironmentObject var searchPlace: SearchPlace
    @EnvironmentObject var locationManager: LocationManager
    @State private var searchText = ""
    @State private var region : MKCoordinateRegion = MKCoordinateRegion()

    var body: some View {
        NavigationView{
            GeometryReader { proxy in
                VStack{
                    ZStack (alignment: .topTrailing){
                        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: searchPlace.places) { place in
                            MapAnnotation(
                                coordinate: place.coordinate,
                                content: {
                                    Image(systemName: "pin.circle.fill")
                                        .foregroundColor(searchPlace.place == place ? .red: .blue)
                                        .scaleEffect(searchPlace.place == place ? 2: 1)
                                }
                            )
                        }
                        .ignoresSafeArea()
                        .onChange(of: locationManager.region.span) {_ in
                            print("out of display area")
                            region = locationManager.region
                        }
//                        .onChange(of: region.span) {_ in
//                            print("map dragged")
//                            locationManager.stopUpdateLocation()
////                            region = locationManager.region
//                        }
                        
                        LocationButton(.currentLocation) {
                            print("Location btn tapped")
                            
                            locationManager.requestAllowOnceLocationPermission()
                            
                            // move map's camera to current location
                            region = locationManager.region
                        }
                        .font(.title2)
                        .cornerRadius(8)
                        .labelStyle(.iconOnly)
                        .symbolVariant(.circle)
                        .foregroundColor(Color.white)
                        .tint(Color.orange)
                        .padding(10)
                    }
                    .frame(height: proxy.size.height * 0.5)
                    
                    ScrollView{
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Where you go?", text: $searchText)
                                .disableAutocorrection(true)
                                .onChange(of: searchText, perform: { newValue in
                                    searchPlace.search(query: searchText)
                                })
                        }
                        .font(.title2)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.orange, lineWidth: 3)
                        )
                        .padding()
                        
                        if !searchPlace.places.isEmpty && searchText != "" {
                            ScrollView{
                                VStack{
                                    ForEach(searchPlace.places,  id: \.self){ place in
                                        VStack{
                                            HStack{
                                                VStack{
                                                    Text(place.placemark.name ?? "")
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    Text(place.placemark.title ?? "")
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .foregroundColor(.gray)
                                                        .font(.callout)
                                                }
                                                NavigationLink(destination: 
                                                                DirectionSearchView(destination: Destination(name: place.name, title: place.title, lat: place.placemark.coordinate.latitude, long: place.placemark.coordinate.longitude)),
                                                    label: {
                                                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill").foregroundColor(Color.orange)
                                                            .font(.title)
                                                    }
                                                )
                                            }
                                            Divider()
                                        }
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            searchPlace.place = place
                                             print("You tapped \(place)")
                                            withAnimation {
//                                                locationManager.region = MKCoordinateRegion.regionFromLandmark(place)
                                                region = MKCoordinateRegion.regionFromLandmark(place)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    Spacer()
                }                        
                .task{
                    region = locationManager.region
                }
                
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SearchPlace())
            .environmentObject(LocationManager())

    }
}
