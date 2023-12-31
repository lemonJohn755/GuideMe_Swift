//
//  RouteSummary.swift
//  GuideMe
//
//  Created by John Chan on 16/10/2023.
//

import Foundation
import SwiftUI
struct ItinerarySummary: View{
    
    var route: Route
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(route.legs[0].steps){step in
                    HStack{
                        if (step.travel_mode == TravelMode.TRANSIT){
                            switch step.transit_details?.line?.vehicle?.type{
                            case .BUS, .INTERCITY_BUS, .OTHER, .TROLLEYBUS:
                                Image(systemName: "bus")
                            case .COMMUTER_TRAIN, .HEAVY_RAIL, .HIGH_SPEED_TRAIN, .LONG_DISTANCE_TRAIN:
                                Image(systemName: "train.side.front.car")
                            case .FERRY:
                                Image(systemName: "ferry")
                            case .CABLE_CAR, .FUNICULAR, .GONDOLA_LIFT:
                                Image(systemName: "cablecar")
                            case .RAIL, .TRAM, .METRO_RAIL:
                                Image(systemName: "tram")
                            case .SHARE_TAXI:
                                Image(systemName: "car")
                            case .SUBWAY:
                                Image(systemName: "tram.fill.tunnel")
                                    .foregroundColor(Color(hex: step.transit_details?.line?.color ?? ""))
                            case .none:
                                Image(systemName: "questionmark.circle")
                            }
                            
                            Text(step.transit_details?.line?.short_name ?? step.transit_details?.line?.name ?? "")
                                .padding(5)
                                .foregroundStyle(Color(hex: step.transit_details?.line?.text_color ?? "#FFFFFF"))
                                .background(Color(hex: step.transit_details?.line?.color ?? ""))
                                .cornerRadius(3)
                                .foregroundStyle(Color(.white))
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: 100)
                                .lineLimit(3)
                            
                        }else if (step.travel_mode == TravelMode.BICLYING){
                            Image(systemName: "bicycle")
                        }
                        else if (step.travel_mode == TravelMode.DRIVING){
                            Image(systemName: "car")
                        }
                        else{
                            VStack{
                                Image(systemName: "figure.walk")
                                Text(String(Int(ceil(Double(step.duration.value/60)))))
                                    .font(.caption2)
                                    .fontWeight(.light)
                            }
                        }
                    }
                    .padding(.vertical)
//                        .frame(maxWidth: 80)

                }
            }
//            HStack{
//                ForEach(route.legs[0].steps){step in
//                    VStack{
//                        if (step.travel_mode == TravelMode.TRANSIT){
//                            switch step.transit_details?.line?.vehicle?.type{
//                            case .BUS, .INTERCITY_BUS, .OTHER, .TROLLEYBUS:
//                                Image(systemName: "bus")
//                            case .COMMUTER_TRAIN, .HEAVY_RAIL, .HIGH_SPEED_TRAIN, .LONG_DISTANCE_TRAIN:
//                                Image(systemName: "train.side.front.car")
//                            case .FERRY:
//                                Image(systemName: "ferry")
//                            case .CABLE_CAR, .FUNICULAR, .GONDOLA_LIFT:
//                                Image(systemName: "cablecar")
//                            case .RAIL, .TRAM, .METRO_RAIL:
//                                Image(systemName: "tram")
//                            case .SHARE_TAXI:
//                                Image(systemName: "car")
//                            case .SUBWAY:
//                                Image(systemName: "tram.fill.tunnel")
//                                    .foregroundColor(Color(hex: step.transit_details?.line?.color ?? ""))
//                            case .none:
//                                Image(systemName: "questionmark.circle")
//                            }
//                            
//                        }else if (step.travel_mode == TravelMode.BICLYING){
//                            Image(systemName: "bicycle")
//                        }
//                        else if (step.travel_mode == TravelMode.DRIVING){
//                            Image(systemName: "car")
//                        }
//                        else{
//                            VStack{
//                                Image(systemName: "figure.walk")
//                                Text(String(Int(ceil(Double(step.duration.value/60)))))
//                                    .font(.caption2)
//                                    .fontWeight(.light)
//                            }
//                        }
//                    }
//                    .padding(.vertical)
//                }
//            }
            
        }
    }
}
