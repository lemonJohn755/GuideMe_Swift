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

            }
            
            // Time
            VStack(alignment: .trailing){
                Image(systemName: "clock")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.orange)
                HStack{
                    Text("\(String(Int(ceil(Double(route.legs[0].duration.value/60)))))")
                        .fontWeight(.bold)
                        .font(.title2)
                    Text("min")
                        .font(.caption)
                }
                
            }
//            .foregroundStyle(Color.black)
            .frame(alignment: .trailing)
            .font(.callout)
            .lineLimit(1)
            
        }
        .frame(alignment: .leading)
        .font(.title2)
        .padding(.horizontal)
        
    }
}

//struct RouteRowView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        RouteRowView(route: route)
//    }
//}
