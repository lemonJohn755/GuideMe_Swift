//
//  RouteDetailView.swift
//  GuideMe
//
//  Created by John Chan on 6/10/2023.
//

import Foundation
import SwiftUI

struct RouteDetailView: View {
    @EnvironmentObject var locationManager: LocationManager
    var route : Route
    
    var body: some View {
            VStack{

                Text(route.legs[0].start_address)
//                    .frame(maxWidth: .infinity, alignment: .topLeading)

                Text(route.legs[0].end_address)
//                    .frame(maxWidth: .infinity, alignment: .topLeading)

                Text("Steps: \(route.legs[0].steps.count)")

            }
            .navigationTitle("Route Detail")
            .padding()
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
