//
//  MapView.swift
//  Path
//
//  Created by Kieran on 11/07/2021.
//

import SwiftUI
import MapKit

//--- GPX parsing ---
import CoreGPX

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var searchedArea: Area?
    
    @Binding var tabSelection: Int
    
    @State var gpx: GPXRoot
    
    @State var searchedAreas: [Area] = []
    
    //@State var sourceCord = CLLocationCoordinate2D()
    //@State var destCord = CLLocationCoordinate2D()
    
    class Coordinator: NSObject, MKMapViewDelegate{
        var parent: MapView
        
        init(_ parent: MapView)
        {
            self.parent = parent
        }
        

        
        //--- rendering direction line ---
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
            
            let render = MKPolylineRenderer(overlay: overlay)
            
            render.strokeColor = .blue
            render.lineWidth = 4
            return render
        }
        
        //--- pin point annotation with button ---
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                if annotation is MKUserLocation { return nil }

                if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") {
                    annotationView.annotation = annotation
                    return annotationView
                } else {
                    let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"")
                    annotationView.isEnabled = true
                    annotationView.canShowCallout = true

                    let btn = UIButton(type: .detailDisclosure)
                    //btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                    annotationView.rightCalloutAccessoryView = btn
                    return annotationView
                }
        }
        
        
        //--- changing annotation image ----
        /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let identifier = "MyPin"

            if annotation is MKUserLocation {
                return nil
            }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                var img = UIImage(systemName: "pin")
                annotationView?.image = img

                // if you want a disclosure button, you'd might do something like:
                //
                // let detailButton = UIButton(type: .detailDisclosure)
                // annotationView?.rightCalloutAccessoryView = detailButton
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        
        }*/
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            //print("test")
            //print (view.annotation?.coordinate)
        }
        
        //--- passing coordinates ---
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView)
        {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //@EnvironmentObject var paths: Locations
    
    let locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        
        //--- MAP ---
        let mapView = MKMapView()
        
        //--- pin annotation ---
        //mapView.delegate = context.coordinator
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //        self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.startUpdatingLocation()
         
            switch locationManager.authorizationStatus{
            case .notDetermined:
                sleep(4)
            case .restricted:
                //alert
                sleep(1)
            case .denied:
                //alert
                sleep(1)
                //print("Denied")
            case .authorizedAlways, .authorizedWhenInUse:
                //print("granted")
                
                mapView.showsUserLocation = true
                
                let locValue:CLLocationCoordinate2D = self.locationManager.location!.coordinate
                //print("CURRENT LOCATION = \(locValue.latitude) \(locValue.longitude)")
                
                let coordinate = CLLocationCoordinate2D(
                    latitude: locValue.latitude, longitude: locValue.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                mapView.setRegion(region, animated: true)
            
            }
        }
        //--- returning map object ---
        return mapView
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if(self.searchedArea != nil)
        {
            let overlays = uiView.overlays
            uiView.removeOverlays(overlays)
            
            let annotations = uiView.annotations
            uiView.removeAnnotations(annotations)
            //searchError = false
            for track in gpx.tracks{
                if(track.name!.capitalized.contains(self.searchedArea!.name.capitalized))
                {
                    for segment in track.segments{
                        
                        var annotationPoint = segment.points[segment.points.count/2]
                        var annotationCord = CLLocationCoordinate2D(latitude: annotationPoint.latitude!, longitude: annotationPoint.longitude!)
    
                        
                        
                        /*//--- coordinates from gpx file for name ---
                        var sourceCord = CLLocationCoordinate2D(latitude: segment.points.first!.latitude!, longitude: segment.points.first!.longitude!)
                        var destCord = CLLocationCoordinate2D(latitude: segment.points.last!.latitude!, longitude: segment.points.last!.longitude!)
                        
                        
                        
                        //print("Area valid")
                        //--- COORDINATES FOR PATH ---
                        let sourceLocation = sourceCord
                        
                        let destinationLocation = destCord
                        
                        
                        //--- Coordinate Markers ---
                        let sourceAnnotation = MKPointAnnotation()
                        sourceAnnotation.coordinate = sourceLocation
                        sourceAnnotation.title = "Start"
                        //uiView.addAnnotation(sourceAnnotation)
                        
                        let destAnnotation = MKPointAnnotation()
                        destAnnotation.coordinate = destinationLocation
                        destAnnotation.title = "End"
                        //uiView.addAnnotation(destAnnotation)*/
                        
                        
                        
                        //---- path marker ---
                        let pathAnnotation = MKPointAnnotation()
                        pathAnnotation.coordinate = annotationCord
                        pathAnnotation.title = track.name
                        uiView.addAnnotation(pathAnnotation)
                        
                        
                        //--- delegate ---
                        uiView.delegate = context.coordinator
                    
                        
                        /*//--- direction request ---
                        let directionRequest = MKDirections.Request()
                        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation))
                        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation))
                        //directionRequest.transportType = .walking
                         
                        
                        //--- calculating directions ---
                        let directions = MKDirections(request: directionRequest)
                        
                        directions.calculate { (direct, err) in
                            if err != nil{
                                print((err?.localizedDescription)!)
                                return
                            }
                            let polyline = direct?.routes.first?.polyline
                            
                            //--- adding route to overlay ---
                            uiView.addOverlay(polyline!)
                            
                            //--- setting region ---
                            uiView.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
                                   
                        }*/
                        var pointsToUse: [CLLocationCoordinate2D] = []
                        
                        for point in segment.points{
                            pointsToUse.append(CLLocationCoordinate2D(latitude: point.latitude!, longitude: point.longitude!))
                        }
                        
                        let polyline = MKPolyline(coordinates: &pointsToUse, count: segment.points.count)
                        
                        //uiView.setRegion(MKCoordinateRegion(polyline.boundingMapRect), animated: true)
                               
                        
                        uiView.addOverlay(polyline)
                        //uiView.setRegion(MKCoordinateRegion(polyline.boundingMapRect), animated: true)
                        /*var sourceCord = CLLocationCoordinate2D(latitude: (segment.points.first?.latitude)!, longitude: (segment.points.first?.longitude)!)
                        var destCord = CLLocationCoordinate2D(latitude: (segment.points.last?.latitude)!, longitude: (segment.points.last?.longitude)!)
                        print(sourceCord)
                        print(destCord)*/
                        /*for point in segment.points{
                            print(point.latitude)
                            print(point.longitude)
                        }*/
                    }
                }
                else{
                    
                }
            }
            
            //print(self.sourceCord)
            //print(self.destCord)
            
            
            
            
            
                //print("Area valid")
                /*//--- COORDINATES FOR PATH ---
                let sourceLocation = CLLocationCoordinate2D(latitude: 53.11490, longitude: -4.21066)
                
                let destinationLocation = CLLocationCoordinate2D(latitude: 53.11490, longitude: -4.21066)
                
                
                //--- Coordinate Markers ---
                let sourceAnnotation = MKPointAnnotation()
                sourceAnnotation.coordinate = sourceLocation
                sourceAnnotation.title = "Start"
                uiView.addAnnotation(sourceAnnotation)
                
                let destAnnotation = MKPointAnnotation()
                destAnnotation.coordinate = destinationLocation
                destAnnotation.title = "End"
                uiView.addAnnotation(destAnnotation)
                
                //--- delegate ---
                uiView.delegate = context.coordinator
            
                
                //--- direction request ---
                let directionRequest = MKDirections.Request()
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation))
                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation))
                //directionRequest.transportType = .walking
                
                //--- calculating directions ---
                let directions = MKDirections(request: directionRequest)
                
                directions.calculate { (direct, err) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                    }
                    let polyline = direct?.routes.first?.polyline
                    
                    //--- adding route to overlay ---
                    uiView.addOverlay(polyline!)
                    
                    //--- setting region ---
                    //mapView.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
                           
                }*/
                
        }
        else{
            //searchError = true
        }
    }

}
