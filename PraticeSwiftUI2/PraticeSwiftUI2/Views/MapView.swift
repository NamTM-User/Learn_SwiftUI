/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that presents a map of a landmark.
*/

import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 34.011286,
        longitude: -116.166868
    )
    
    var p: MapCameraPosition = .automatic

    var body: some View {
//        Map(position: .constant(.region(region)))
        Map(position: .constant(p))
        
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

#Preview {
    MapView()
}
