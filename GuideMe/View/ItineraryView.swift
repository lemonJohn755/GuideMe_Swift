//
//  RouteDetailView.swift
//  GuideMe
//
//  Created by John Chan on 6/10/2023.
//

import SwiftUI
import MapKit
import _CoreLocationUI_SwiftUI
import Polyline

struct ItinteryView: View {
    
    var route : Route
    @State private var showSheet = true
    @State private var selectedDetent = PresentationDetent.fraction(0.3)
    @State var decodedCoordinates : [CLLocationCoordinate2D] = []
    @EnvironmentObject var locationManager: LocationManager
    @State var region = MKCoordinateRegion()
    @State var colorHex = "#1F51FF"
    @State var position : MapCameraPosition = .automatic
    
    var body: some View {
        GeometryReader { proxy in
            
            VStack{
                MapView(colorHex: $colorHex, position: $position, points: decodedCoordinates)
                    .frame(maxHeight: proxy.size.height * 0.7)
            }
            .sheet(isPresented: $showSheet) {
                StepView(selectedDetent: $selectedDetent, decodedCoordinates: $decodedCoordinates, colorHex: $colorHex, position: $position, route: route)
                    .presentationDetents([.fraction(0.3), .medium, .large],
                                         selection: $selectedDetent)
                    .interactiveDismissDisabled(true)
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
            .onAppear(){
                // Decode polyline string into a array of coodinates
                decodedCoordinates = decodePolyline(route.overview_polyline.points) ?? []
//                print("Decoded coordinates: \(decodedCoordinates.count) points")
            }
        }
        .navigationTitle("Itinerary")
        
    }
}


struct StepView: View{
    @Binding var selectedDetent: PresentationDetent
    @Binding var decodedCoordinates : [CLLocationCoordinate2D]
    @Binding var colorHex : String
    @Binding var position : MapCameraPosition
    
    @State var fitPolylineRegion = MKCoordinateRegion()
    @State var calculateFitRegion = CalculateFitRegion()

    var route : Route
    
    var body: some View {
        ScrollView{
            Spacer()
            HStack{
                ItinerarySummary(route: route)
                VStack{
                    Text("\(route.legs[0].duration.text)")
                        .fontWeight(.semibold)
                    Text("\(route.legs[0].arrival_time.text)")
                        .foregroundStyle(Color(.gray))
                }
                .font(.callout)
                .frame(maxWidth: 80, alignment: .trailing)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                decodedCoordinates = decodePolyline(route.overview_polyline.points) ?? []
                colorHex = "#1F51FF"
                fitPolylineRegion = calculateFitRegion.fitPolyline(decodedCoordinates: decodedCoordinates)
                position = MapCameraPosition.region(fitPolylineRegion)
                    
            }
            .font(.body)
            .padding(.horizontal)
            
            Divider()
            
            ForEach(route.legs[0].steps){ step in
                VStack(alignment: .leading){
//                    Spacer()
                    if (step.travel_mode == .WALKING){
                        HStack{
                            Label(step.travel_mode.rawValue.capitalized, systemImage: "figure.walk")
                                .font(.title2)
                                .labelStyle(.titleAndIcon)
                            VStack(alignment: .trailing){
                                Label(step.duration.text, systemImage: "clock")
                                Text(step.distance.text)
                            }
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        VStack{
                            Text(step.html_instructions ?? "")
                        }
                    }
                    else if (step.travel_mode == .BICLYING){
                        Label(step.travel_mode.rawValue.capitalized, systemImage: "bicycle")
                            .font(.title2)
                            .labelStyle(.titleAndIcon)
                        
                    }
                    else if (step.travel_mode == .DRIVING){
                        Label(step.travel_mode.rawValue.capitalized, systemImage: "car")
                            .font(.title2)
                            .labelStyle(.titleAndIcon)
                    }
                    else{   // TRANSIT
                        HStack{
                            AsyncImage(url: URL(string: "https:\(step.transit_details?.line?.vehicle?.local_icon ?? step.transit_details?.line?.vehicle?.icon ?? "")")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 20, height: 20)
                            Text((step.transit_details?.line?.short_name ?? step.transit_details?.line?.name) ?? "")
                                .padding(8)
                                .foregroundStyle(Color(hex: step.transit_details?.line?.text_color ?? "#FFFFFF"))
                                .background(Color(hex: step.transit_details?.line?.color ?? ""))
                                .cornerRadius(8)
                                .foregroundStyle(Color(.white))
                            Text(step.transit_details?.headsign ?? "")
                        }
                        .font(.subheadline)
                        
                        HStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(hex: step.transit_details?.line?.color ?? ""))
                                .frame(width: 8, height: .infinity)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("\(step.transit_details?.departure_stop.name ?? "")")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(step.transit_details?.departure_time.text ?? "")")
                                        .font(.subheadline)
                                        .frame(maxWidth: 100, alignment: .trailing)
                                }
                                HStack{
                                    Text("Ride \(step.transit_details?.num_stops ?? 0) stops")
                                        .fontWeight(.light)
                                        .padding()
                                    VStack(alignment: .trailing){
                                        Label(step.duration.text, systemImage: "clock")
                                        Text(step.distance.text)
                                    }
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                HStack{
                                    Text("\(step.transit_details?.arrival_stop.name ?? "")")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(step.transit_details?.arrival_time.text ?? "")")
                                        .font(.subheadline)
                                        .frame(maxWidth: 100, alignment: .trailing)
                                }
                            }
                        }
                    }
                    Divider()
                    Spacer()
                }
                .padding(.horizontal)
                .contentShape(Rectangle())
                .onTapGesture {
                    // 1. Move map camera
                    // 2. Add markers & draw polyline on map
                    print("tapped \(step.travel_mode)")
                    selectedDetent = PresentationDetent.fraction(0.3)
                    decodedCoordinates = decodePolyline(step.polyline.points) ?? []
                    colorHex = step.transit_details?.line?.color ?? ""
                    
                    fitPolylineRegion = calculateFitRegion.fitPolyline(decodedCoordinates: decodedCoordinates)
                    position = MapCameraPosition.region(fitPolylineRegion)

                }
            }
            
            Text(route.copyrights)
                .font(.caption)
                .foregroundStyle(Color(.gray))
        }
    }
    
    
}

struct ItinteryView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var destination : Destination = Destination(name: "貝澳泳灘", title: "Pui O Beach Lantau Island", lat: 22.2398019, long: 113.9745063)
        @State var origin : Origin = Origin(lat: 22.32481920, long: 114.16901930)
        
        let getRoutes: GetRoutes = GetRoutes(destination: destination, origin: origin)
        let route = getRoutes.fetchDemo(destination: destination, origin: origin)
        
        ItinteryView(route: route[0])
            .environmentObject(LocationManager())
    }
}
