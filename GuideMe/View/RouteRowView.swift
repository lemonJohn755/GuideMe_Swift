//
//  RouteCellView.swift
//  GuideMe
//
//  Created by John Chan on 24/9/2023.
//

import SwiftUI

struct RouteRowView: View{
    
    @State var route: Route
    
    var body: some View {
        
        HStack{
            // Summary
            ForEach(route.legs[0].steps){step in
                VStack{
                    if (step.travel_mode == TravelMode.TRANSIT){
                        switch step.transit_details?.line?.vehicle?.type{
                        case .BUS:
                            Image(systemName: "bus")
                        case .CABLE_CAR:
                            Image(systemName: "cablecar")
                        case .COMMUTER_TRAIN:
                            Image(systemName: "train.side.front.car")
                        case .FERRY:
                            Image(systemName: "ferry")
                        case .FUNICULAR:
                            Image(systemName: "cablecar")
                        case .GONDOLA_LIFT:
                            Image(systemName: "cablecar")
                        case .HEAVY_RAIL:
                            Image(systemName: "train.side.front.car")
                        case .HIGH_SPEED_TRAIN:
                            Image(systemName: "train.side.front.car")
                        case .INTERCITY_BUS:
                            Image(systemName: "bus")
                        case .LONG_DISTANCE_TRAIN:
                            Image(systemName: "train.side.front.car")
                        case .METRO_RAIL:
                            Image(systemName: "tram")
                        case .OTHER:
                            Image(systemName: "bus")
                        case .RAIL:
                            Image(systemName: "tram")
                        case .SHARE_TAXI:
                            Image(systemName: "car")
                        case .SUBWAY:
                            Image(systemName: "tram.fill.tunnel")
                        case .TRAM:
                            Image(systemName: "tram")
                        case .TROLLEYBUS:
                            Image(systemName: "bus")
                        case .none:
                            Image(systemName: "questionmark.circle")
                        }
                        Text(((step.transit_details?.line?.short_name ?? step.transit_details?.line?.name) ?? "") )
                            .font(.caption)
                    }else if (step.travel_mode == TravelMode.BICLYING){
                        Image(systemName: "bickcle")
                    }
                    else if (step.travel_mode == TravelMode.DRIVING){
                        Image(systemName: "car")
                    }
                    else{
                        Image(systemName: "figure.walk")
                    }
                    
                }
                .frame(alignment: .leading)
            }
            
            // Time and distance
            VStack{
                Image(systemName: "clock")
                Text("\(String(route.legs[0].duration.value/60)) min")
                Text(String(route.legs[0].distance.text))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.callout)
            .lineLimit(1)
            
            Image(systemName: "chevron.right")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.title2)
        .padding()
    }
}

//struct RouteRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        RouteRowView(route: route)
//    }
//}
