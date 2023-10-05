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
    
    var destination : Destination
    var origin : Origin
    
    let APIKey : String = Bundle.main.infoDictionary?["DIRECTION_API_KEY"] as! String
    
    init(destination : Destination, origin : Origin){
        self.destination = destination
        self.origin = origin
    }
    
    func fetchDemo(destination: Destination, origin: Origin) -> [Route] {
        
        let query = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.lat),\(origin.long) &destination=\(destination.lat),\(destination.long)&mode=transit&region=HK&alternatives=true&key=\(APIKey)"
        
        print("[TEST] URL:\n\(query)")
        
        let jsonData = readLocalJSONFile(forName: "/sample_responses/response")
        if let data = jsonData {
            if let decodedJson = parse(jsonData: data) {
                print("JSON read: \(decodedJson.status)")
                
                do {
                    let decodedJson = try JSONDecoder().decode(Direction.self, from: data)
                    
//                    print("API Connection: \(decodedJson.status)")
                    self.routes = decodedJson.routes
                    
                    return self.routes
                    
                } catch let error {
                    print("Error decoding: ", error)
                }
            }
        }
        else{
            print("File not found")
        }
        return self.routes
    }
    
    private func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    private func parse(jsonData: Data) -> Direction? {
        do {
            let decodedData = try JSONDecoder().decode(Direction.self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
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
                        
                        print("API Connection: \(decodedJson.status)")
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
