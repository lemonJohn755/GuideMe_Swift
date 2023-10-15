//
//  RouteSummary.swift
//  GuideMe
//
//  Created by John Chan on 16/10/2023.
//

import Foundation
import SwiftUI
struct routeSummary: View{
    
    var route: Route
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(route.legs[0].steps){step in
                    VStack{
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
                }
            }
            
        }
    }
}
