//
//  RunMapView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/3/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import MapKit
import Polyline

struct RunMapView: View {
    var workoutItem: RunLogged
    
    var body: some View {
        VStack {
            MapView(workoutItem: workoutItem)
        }
    }
    

}

final class MapViewCoordinator: NSObject, MKMapViewDelegate {
  private let map: MapView
  
  init(_ control: MapView) {
    self.map = control
  }
  
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    if let annotationView = views.first, let annotation = annotationView.annotation {
      if annotation is MKUserLocation {
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
      }
    }
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .red
    renderer.lineWidth = 3.0
    return renderer
  }
}


struct MapView: UIViewRepresentable {
  private let mapZoomEdgeInsets = UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0)
    
  var workoutItem: RunLogged
  func makeCoordinator() -> MapViewCoordinator {
    MapViewCoordinator(self)
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.showsUserLocation = true
    mapView.delegate = context.coordinator
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    updateOverlays(from: uiView)
  }
  
  private func updateOverlays(from mapView: MKMapView) {
    
    mapView.removeOverlays(mapView.overlays)
    
    let polyline = MKPolyline(coordinates: workoutItem.coreLocationArray, count: workoutItem.coreLocationArray.count)
    mapView.addOverlay(polyline)
    setMapZoomArea(map: mapView, polyline: polyline, edgeInsets: mapZoomEdgeInsets, animated: true)
  }
  
  private func setMapZoomArea(map: MKMapView, polyline: MKPolyline, edgeInsets: UIEdgeInsets, animated: Bool = false) {
      map.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgeInsets, animated: animated)
  }
}



