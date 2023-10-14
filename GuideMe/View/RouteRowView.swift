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
//            let rows = [
//                GridItem(.fixed(50)),
//                GridItem(.fixed(50))
//            ]
//            
//            LazyHGrid(rows: rows, alignment: .center) {
//            }
            
            ForEach(route.legs[0].steps){step in
                VStack{
                    if (step.travel_mode == TravelMode.TRANSIT){
                        switch step.transit_details?.line?.vehicle?.type{
                        case .BUS, .INTERCITY_BUS, .OTHER, .TROLLEYBUS:
                            Image(systemName: "bus")
                            Text(step.transit_details?.line?.short_name ?? "")
                                .padding(8)
                                .background(Color(hex: step.transit_details?.line?.color ?? ""))
                                .cornerRadius(8)
                                .foregroundStyle(Color(.white))
                                .font(.caption)
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
                            Text(step.transit_details?.line?.name ?? "")
                                .padding(3)
                                .background(Color(hex: step.transit_details?.line?.color ?? ""))
                                .cornerRadius(8)
                                .foregroundStyle(Color(.white))
                                .font(.caption)
                                .frame(maxWidth: 50)
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
            
            //            Image(systemName: "chevron.right")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.title2)
        .padding()
        .foregroundColor(Color(.black))

        Divider()
        
    }
}

//struct RouteRowView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        RouteRowView(route: route)
//    }
//}
