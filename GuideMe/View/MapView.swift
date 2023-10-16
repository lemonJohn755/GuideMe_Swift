import SwiftUI
import MapKit
import _CoreLocationUI_SwiftUI

struct MapView: View{
    @EnvironmentObject var locationManager: LocationManager
    //    @State var region : MKCoordinateRegion = MKCoordinateRegion()
    @State private var region : MKCoordinateRegion = MKCoordinateRegion()
    private let gradient = LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
    private let stroke = StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
    @Binding var colorHex : String
    @State private var position = MapCameraPosition.automatic


    var points : [CLLocationCoordinate2D]
    
    var body: some View {
        ZStack (alignment: .topTrailing){
            Map(position: $position){
                MapPolyline(coordinates: points)
                    .strokeStyle(style: stroke)
                    .stroke(Color(hex: colorHex), lineWidth: 8)
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
             }
            .controlSize(.small)
        }
        
    }
}
