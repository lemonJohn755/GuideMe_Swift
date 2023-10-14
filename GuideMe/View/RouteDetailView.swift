//
//  RouteDetailView.swift
//  GuideMe
//
//  Created by John Chan on 6/10/2023.
//

import SwiftUI
import MapKit
import _CoreLocationUI_SwiftUI

struct RouteDetailView: View {
    
    var route : Route
    
    var body: some View {
        GeometryReader { proxy in
            VStack{
                MapView()
                    .frame(height: proxy.size.height * 0.4)
                StepView(route: route)
                
            }
        }
        .navigationTitle("Route Detail")
    }
}



struct StepView: View{
    var route : Route
    
    var body: some View {
        ScrollView{
            ForEach(route.legs[0].steps){ step in
                VStack(alignment: .leading){
                    Spacer()
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
                            switch step.transit_details?.line?.vehicle?.type{
                            case .BUS, .INTERCITY_BUS, .OTHER, .TROLLEYBUS:
                                Label(step.transit_details?.line?.vehicle?.name ?? "", systemImage: "bus.doubledecker")
                                    .font(.title2)
                                    .labelStyle(.titleAndIcon)
                                
                            case .CABLE_CAR, .FUNICULAR, .GONDOLA_LIFT:
                                Label(step.transit_details?.line?.vehicle?.name ?? "", systemImage: "cablecar")
                                    .font(.title2)
                                    .labelStyle(.titleAndIcon)
                                
                            case .COMMUTER_TRAIN, .HEAVY_RAIL, .HIGH_SPEED_TRAIN, .LONG_DISTANCE_TRAIN:
                                Label(step.transit_details?.line?.vehicle?.name ?? "", systemImage: "train.side.front.car")
                                    .font(.title2)
                                    .labelStyle(.titleAndIcon)
                                
                            case .FERRY:
                                Label(step.transit_details?.line?.vehicle?.name ?? "", systemImage: "ferry")
                                    .font(.title2)
                                    .labelStyle(.titleAndIcon)
                                
                            case .RAIL, .TRAM, .METRO_RAIL:
                                Label(step.transit_details?.line?.vehicle?.name ?? "", systemImage: "tram")
                                    .font(.title2)
                                    .labelStyle(.titleAndIcon)
                                
                            case .SHARE_TAXI:
                                Label(step.transit_details?.line?.vehicle?.name ?? "", systemImage: "car")
                                    .font(.title2)
                                    .labelStyle(.titleAndIcon)
                                
                            case .SUBWAY:
                                Label(step.transit_details?.line?.vehicle?.name ?? "", systemImage: "tram.fill.tunnel")
                                    .font(.title2)
                                    .labelStyle(.titleAndIcon)
                                
                            case .none:
                                Label(step.transit_details?.line?.vehicle?.name ?? "", systemImage: "questionmark.circle")
                                    .font(.title2)
                                    .labelStyle(.titleAndIcon)
                            }
                            
                            VStack(alignment: .trailing){
                                Label(step.duration.text, systemImage: "clock")
                                Text(step.distance.text)
                            }
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        
                        Text("\(step.transit_details?.departure_stop.name ?? "")")
                            .font(.headline)
                        HStack{
                            Text((step.transit_details?.line?.short_name ?? step.transit_details?.line?.name) ?? "")
                                .padding(8)
                                .background(Color(hex: step.transit_details?.line?.color ?? ""))
                                .cornerRadius(8)
                                .foregroundStyle(Color(.white))
                            Text(step.transit_details?.headsign ?? "")
                        }
                        .font(.subheadline)

                        Text("Ride \(step.transit_details?.num_stops ?? 0) stops")
                        Text("\(step.transit_details?.arrival_stop.name ?? "")")
                            .font(.headline)
                    }
                    
                    Divider()
                    Spacer()
                    
                }
                .padding(.horizontal)
                
            }
            
            Text(route.copyrights)
                .font(.caption)
                .foregroundStyle(Color(.gray))
        }
        VStack{
            HStack{
                Text("\(route.legs[0].arrival_time.text)")
                    .font(.subheadline)
                    .foregroundStyle(Color(.gray))
                Text("\(route.legs[0].duration.text)")
                    .font(.body)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

        }
        .padding(.horizontal)
    }
}

struct RouteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var destination : Destination = Destination(name: "貝澳泳灘", title: "Pui O Beach Lantau Island", lat: 22.2398019, long: 113.9745063)
        @State var origin : Origin = Origin(lat: 22.32481920, long: 114.16901930)
        
        let getRoutes: GetRoutes = GetRoutes(destination: destination, origin: origin)
        let route = getRoutes.fetchDemo(destination: destination, origin: origin)
        
        RouteDetailView(route: route[0])
            .environmentObject(LocationManager())
    }
}
