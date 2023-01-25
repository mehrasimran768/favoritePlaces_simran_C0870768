//
//  mapViewVC.swift
//  favoritePlaces_simran_C0870768
//
//  Created by simran mehra on 2023-01-24.
//

import Foundation
import UIKit
import MapKit

class mapViewVC :UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var zoomIn: UIButton!
    
    @IBOutlet weak var zoomOut: UIButton!
    
    @IBOutlet weak var search: UITextField!
    
    var locationManager: CLLocationManager!
    var destination1: CLLocationCoordinate2D!
    let geocoder = CLGeocoder()
    var pinnedAnnotations: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        map.isZoomEnabled = false
        singleTap()
        doubletap()
    }
    
    @IBAction func searchAddress(_ sender: UIButton) {
            //searchAddress()
            let address = search.text!
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = address
                let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start { [self] (response, error) in
                    if error == nil {
                        let coordinates = response?.boundingRegion.center
                        let lat = coordinates?.latitude
                        let lon = coordinates?.longitude
                        let location = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                        self.displayLocation(latitude: lat!, longitude: lon!)
                        let annotationCity = city(title: "", coordinate: location)
                        self.map.addAnnotation(annotationCity)
                  
                    }
                    else {
                        print(error?.localizedDescription ?? "Error")
                    }
                }
            
        }

    //for zooming In
    @IBAction func zoomIn(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta*0.5, longitudeDelta: map.region.span.longitudeDelta*0.5)
        let region = MKCoordinateRegion(center: map.region.center, span: span)
        
        map.setRegion(region, animated: true)
    }
    
    //for zoom out
    @IBAction func zoomOut(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta*2, longitudeDelta: map.region.span.longitudeDelta*2)
        let region = MKCoordinateRegion(center: map.region.center, span: span)
        
        map.setRegion(region, animated: true)
    }
    // display user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let userLocation = locations[0]
            
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            
            
            displayLocation(latitude: latitude, longitude: longitude)
        }
        
        func displayLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
            
            //DEFINE SPAN
            let latdelta: CLLocationDegrees = 0.05
            let lngdelta: CLLocationDegrees = 0.05
            
            let span = MKCoordinateSpan(latitudeDelta: latdelta, longitudeDelta: lngdelta)
            
            
            //DEFINE LOCATION
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            
            //DEFINE REGION
            let region = MKCoordinateRegion(center: location, span: span)
            
            
            //SET REGION ON MAP
            map.setRegion(region, animated: true)
            
        }
    
    
 
    //adding an annotation
    @objc func dropPin(sender: UITapGestureRecognizer){
        
        pinnedAnnotations = map.annotations.count
        
        let touchPoint = sender.location(in: map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: {(placemarks, error) in
            
            if self.pinnedAnnotations >= 1 {
                self.removePin()
                
            }
            else {
                DispatchQueue.main.async {
                    if let placeMark = placemarks?[0] {
                        
                        if placeMark.locality != nil {
                            
                            let place = city(title:"",coordinate: coordinate)
                            
                            if self.pinnedAnnotations < 1 {
                                
                                self.map.addAnnotation(place)
                            }
                            
                        }
                    }
                }
            }
            
        })
        
    }
    
    func singleTap(){
        let single = UITapGestureRecognizer(target: self, action: #selector(dropPin))
        single.numberOfTapsRequired = 1
        map.addGestureRecognizer(single)
    }
    func doubletap(){
        let double = UITapGestureRecognizer(target: self, action: #selector(removePin))
        double.numberOfTapsRequired = 2
        map.addGestureRecognizer(double)
    }
    
    
    @objc func removePin() {
        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }
    }
    @objc func removeAnnotation(point: UITapGestureRecognizer) {
        
        let pointTouched: CGPoint = point.location(in: map)
        
        let coordinate =  map.convert(pointTouched, toCoordinateFrom: map)
        let location: CLLocationCoordinate2D = coordinate
        
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
            }
        })
    }
}
//configure the appearence of overlays
    extension ViewController: MKMapViewDelegate {
        
                
      

                func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                    if overlay is MKCircle {
                        let rendrer = MKCircleRenderer(overlay: overlay)
                        rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
                        rendrer.strokeColor = UIColor.green
                        rendrer.lineWidth = 2
                        return rendrer
                    } else if overlay is MKPolyline {
                        let rendrer1 = MKPolylineRenderer(overlay: overlay)
                        rendrer1.strokeColor = UIColor.blue
                        rendrer1.lineWidth = 3
                        return rendrer1
                    }
                    else if overlay is MKPolygon {
                        let rendrer = MKPolygonRenderer(overlay: overlay)
                        rendrer.fillColor = UIColor.red.withAlphaComponent(0.6)
                        rendrer.strokeColor = UIColor.green
                        rendrer.lineWidth = 2
                        return rendrer}
                    
                    return MKOverlayRenderer()
                }
            //callout Accessory views
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
               guard let annotation = annotation as? city else { return nil }

               let identifier = "marker"
               var view: MKMarkerAnnotationView
               if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                 as? MKMarkerAnnotationView {
                   dequeuedView.annotation = annotation
                   view = dequeuedView
               } else {
                   view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                   view.canShowCallout = true
                   view.calloutOffset = CGPoint(x: -5, y: 5)
                   view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
               }
               //print(locationManager.location)
//               if let currentLocation = locationManager.location {
//                   let distance = currentLocation.distance(from: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
//                   let distanceinkms = round(distance * 0.001)
//                   view.detailCalloutAccessoryView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//                   (view.detailCalloutAccessoryView as! UILabel).text = "\(distanceinkms) kms away from your location"
//               }
               return view
           }
            }


