// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let directions = try Directions(json)

import Foundation
import SwiftUI

struct Direction : Decodable {
//    let geocoded_waypoints: [GeocodedWaypoint]
    let routes: [Route]
    let status: String
}

struct GeocodedWaypoint : Decodable{
    let geocoder_status: String
    let partial_match: Bool
    let place_id: String
    let types: [String]
}

struct Route : Decodable, Identifiable{
    var id: UUID {
        return UUID()
    }
    let bounds: Bounds
    let copyrights: String
    let legs: [Leg]
    let overview_polyline: Polyline
    let summary: String
    let warnings: [String]
//    let waypointOrder: [Any?]

}

struct Bounds : Decodable{
    let northeast: Coordinate
    let southwest: Coordinate
}

struct Coordinate : Decodable{
    let lat: Double
    let lng: Double
}

struct Leg : Decodable, Identifiable{
    var id: UUID {
        return UUID()
    }
    let arrival_time: Time
    let departure_time: Time
    let distance: Distance
    let duration: Distance
    let end_address: String
    let end_location: Coordinate
    let start_address: String
    let start_location: Coordinate
    let steps: [Step]
//    let traffic_speed_entry: [Any?]
//    let via_waypoint: [Any?]
}

struct Polyline : Decodable{
    let points: String
}

struct Time : Decodable{
    let text: String
    let time_zone: String
    let value: Int
}

struct Distance : Decodable{
    let text: String
    let value: Int
}

struct Step : Decodable, Identifiable{
    var id: UUID {
        return UUID()
    }
    let distance: Distance
    let duration: Distance
    let end_location: Coordinate
    let html_instructions: String?
    let polyline: Polyline
    let start_location: Coordinate
    let steps: [Step]?
    let travel_mode: TravelMode
    let transit_details: TransitDetails?
    let maneuver: String?
}

struct TransitDetails : Decodable{
    let arrival_stop: Stop
    let arrival_time: Time
    let departure_stop: Stop
    let departure_time: Time
    let headsign: String
    let line: Line?
    let num_stops: Int
}

struct Line : Decodable{
    let agencies: [Agency]
    let color: String?
    let name: String
    let text_color: String?
    let vehicle: Vehicle?
    let short_name: String?
}

struct Stop : Decodable{
    let location: Coordinate
    let name: String
}

struct Agency : Decodable{
//    var id = UUID()
    let name: String
    let phone: String?
    let url: String
}

struct Vehicle : Decodable{
    let icon: String?
    let local_icon: String?
    let name: String?
    let type: TypeEnum?
}

enum TypeEnum: String, Decodable {
    case BUS
    case CABLE_CAR
    case COMMUTER_TRAIN
    case FERRY
    case FUNICULAR
    case GONDOLA_LIFT
    case HEAVY_RAIL
    case HIGH_SPEED_TRAIN
    case INTERCITY_BUS
    case LONG_DISTANCE_TRAIN
    case METRO_RAIL
    case OTHER
    case RAIL
    case SHARE_TAXI
    case SUBWAY
    case TRAM
    case TROLLEYBUS
}

enum TravelMode: String, Decodable {
    case TRANSIT
    case WALKING
    case BICLYING
    case DRIVING
}
