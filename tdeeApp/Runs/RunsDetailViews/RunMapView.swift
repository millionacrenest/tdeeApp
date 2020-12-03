//
//  RunMapView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/3/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import MapKit

struct RunMapView: View {
    
    var body: some View {
        VStack {
            MapView()
        }
    }
}

struct RunMapView_Previews: PreviewProvider {
    static var previews: some View {
        RunMapView()
    }
}

struct MapView: UIViewRepresentable {
  typealias UIViewType = MKMapView
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()

    let region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 47.528549273491635, longitude: -122.3737970022891),
      span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    mapView.setRegion(region, animated: true)

    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {}
}
