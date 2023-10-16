import SwiftUI
import MapKit
import _CoreLocationUI_SwiftUI

struct ItineraryMapView: View{
    @EnvironmentObject var locationManager: LocationManager
    //    @State var region : MKCoordinateRegion = MKCoordinateRegion()
    @State private var region : MKCoordinateRegion = MKCoordinateRegion()
    private let gradient = LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
    private let stroke = StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
    @Binding var colorHex : String
    @Binding var position : MapCameraPosition
    @State private var defaultMarker = CLLocationCoordinate2D(latitude: 22.30, longitude: 114.17)


    var points : [CLLocationCoordinate2D]
    
    var body: some View {
        ZStack (alignment: .topTrailing){
            Map(position: $position){
                // Draw line on map
                MapPolyline(coordinates: points)
                    .strokeStyle(style: stroke)
                    .stroke(Color(hex: colorHex), lineWidth: 8)
                
                // Add start & end markers on map
                Annotation("Start", coordinate: points.first ?? defaultMarker) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.accentColor)
                        HStack{
                            Image(systemName: "flag")
                            Text("Start")
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.white))
                        .padding(8)
                    }
                    .shadow(radius: 3)
                }


                Annotation("End", coordinate: points.last ?? defaultMarker) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.accentColor)
                        HStack{
                            Image(systemName: "flag.fill")
                            Text("End")
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.white))
                        .padding(8)
                    }
                    .shadow(radius: 3)
                }
                

            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
             }
            .controlSize(.small)
        }
        
    }
}
