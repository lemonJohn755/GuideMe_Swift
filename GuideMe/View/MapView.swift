import SwiftUI
import MapKit
import _CoreLocationUI_SwiftUI

struct MapView: View{
    @EnvironmentObject var locationManager: LocationManager
    //    @State var region : MKCoordinateRegion = MKCoordinateRegion()
    @State private var region : MKCoordinateRegion = MKCoordinateRegion()
    private let gradient = LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
    private let stroke = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [8, 8])

    var points : [CLLocationCoordinate2D]
    
    var body: some View {
        ZStack (alignment: .topTrailing){
//            Map(coordinateRegion: $region, showsUserLocation: true)
            Map{
                MapPolyline(coordinates: points)
//                    .stroke(gradient, style: stroke)
                    .stroke(.blue, lineWidth: 8)

            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
             }
            .controlSize(.small)
//            .tint(.orange)
        }
        
    }
}
