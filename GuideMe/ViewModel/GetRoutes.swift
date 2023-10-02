//
//  GetRouteSuggestion.swift
//  GuideMe
//
//  Created by John Chan on 15/9/2023.
//

import Foundation
import SwiftUI
import Swift

class GetRoutes: ObservableObject{
    
    @Published var routes: [Route] = []
    
    //    @Published var destination : Destination
//    @EnvironmentObject var destination: Destination
    
    var destination : Destination
    var origin : Origin
    
    let APIKey : String = Bundle.main.infoDictionary?["DIRECTION_API_KEY"] as! String

    init(destination : Destination, origin : Origin){
        self.destination = destination
        self.origin = origin
    }
    
    func fetchDemo(destination: Destination, origin: Origin) {
        
        let query = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.lat),\(origin.long) &destination=\(destination.lat),\(destination.long)&mode=transit&region=HK&alternatives=true&key=\(APIKey)"

        print("URL\n\(query)")
    }
    
    func fetch(destination: Destination, origin: Origin) {

        let query = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.lat),\(origin.long) &destination=\(destination.lat),\(destination.long)&mode=transit&region=HK&alternatives=true&key=\(APIKey)"
        
        print("URL\n\(query)")
        guard let url = URL(string: query.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? "") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        let decodedJson = try JSONDecoder().decode(Direction.self, from: data)
                        
                        //                            print("API Connection: \(decodedJson.status)")
                        self.routes = decodedJson.routes
                        
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    

    
}
