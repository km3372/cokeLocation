//
//  MapViewController.swift
//  
//
//  Created by Ken Moody on 3/25/17.
//  Copyright © 2017 iMoodyStudios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView :MKMapView?
    @IBOutlet weak var addressTextField :UITextField?
    
    var 📡 :CLLocationManager = CLLocationManager()
    var 👨🏾‍💻 :CLLocation?
    var 🇺🇸 :CLGeocoder = CLGeocoder()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        
        self.📡.delegate = self
        self.📡.distanceFilter = kCLHeadingFilterNone
        self.📡.desiredAccuracy = kCLLocationAccuracyBest
        
        self.📡.requestAlwaysAuthorization()
        self.📡.startUpdatingLocation()
        self.mapView!.showsUserLocation = true
        
        // dropFavoriteAnnotation()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let address = self.addressTextField?.text
        
        openDirections(address)
        
        return textField.resignFirstResponder()
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer! {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
        
    }
    
    
    func openDirections(_ address :String?) {
        
        self.🇺🇸.geocodeAddressString(address!, completionHandler: { (placemarks :[CLPlacemark]?, error :NSError?) -> Void in
            
            let placemark = placemarks![0] as? CLPlacemark
            
            let destinationPlacemark = MKPlacemark(coordinate: placemark!.location!.coordinate, addressDictionary: placemark?.addressDictionary as? [String:NSObject])
            
            let startingMapItem = MKMapItem.forCurrentLocation()
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let directionsRequest = MKDirectionsRequest()
            directionsRequest.transportType = .automobile
            directionsRequest.source = startingMapItem
            directionsRequest.destination = destinationMapItem
            
            let directions = MKDirections(request: directionsRequest)
            
            directions.calculate(completionHandler: { (response :MKDirectionsResponse?, error :NSError?) -> Void in
                
                let route = response!.routes[0] as? MKRoute
                
                if route!.steps.count > 0 {
                    
                    for step in route!.steps {
                        
                        print(step.instructions)
                        
                    }
                }
                
                self.mapView!.add((route?.polyline)!, level: MKOverlayLevel.aboveRoads)
                } as! MKDirectionsHandler)
            
            
            //            let mapItems = [destinationMapItem]
            //
            //            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            //
            //            let success = MKMapItem.openMapsWithItems(mapItems, launchOptions: launchOptions)
            
            } as! CLGeocodeCompletionHandler)
        
        
        
    }
    
    func dropFavoriteAnnotation() {
        
        let googleCoordinate = CLLocationCoordinate2D(latitude: 37.422, longitude: -122.084058)
        
        let favAnnotation = CokeAnnotation(coordinate: googleCoordinate, title: "Coke Location", subtitle: nil)
        
        self.mapView?.addAnnotation(favAnnotation)
        
        // register to monitor region
        let region = CLCircularRegion(center: googleCoordinate, radius: 1000, identifier: "FavoriteCokeRegion")
        
        self.mapView?.add(MKCircle(center: googleCoordinate, radius: 1000))
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        self.📡.startMonitoring(for: region)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Region Entered")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Region Exited")
    }
    
    
    //    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
    //        if overlay is MKCircle {
    //            var circleRenderer = MKCircleRenderer(overlay: overlay)
    //            circleRenderer.lineWidth = 1.0
    //            circleRenderer.strokeColor = UIColor.purpleColor()
    //            circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
    //            return circleRenderer
    //        }
    //        return nil
    //    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("didStartMonitoringForRegion")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        self.👨🏾‍💻 = userLocation.location
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250)
        self.mapView!.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView! {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView = self.mapView?.dequeueReusableAnnotationView(withIdentifier: "CokeAnnotationView")
        
        if(annotationView == nil) {
            
            annotationView = CokeAnnotationView(annotation: annotation, reuseIdentifier: "CokeAnnotationView")
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
        
    }
    
    func addAnnotationToMap() {
        
        
        
        
        self.🇺🇸.reverseGeocodeLocation(self.👨🏾‍💻!) { (placemarks :[CLPlacemark]?, error :Error?) in
            
            if error != nil { return }
            
            let placemark = placemarks![0]
            
            if let streetName = placemark.addressDictionary!["Street"] as? String {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    let cokeAnnotation = CokeAnnotation(coordinate: self.👨🏾‍💻!.coordinate, title: "Coke Location", subtitle: streetName)
                    
                    self.mapView!.addAnnotation(cokeAnnotation)
                    
                })
                
            }
            
            
        }
        
        
        //        self.geocoder.reverseGeocodeLocation(self.currentLocation!) { (placemarks :[CLPlacemark]?, error :NSError?) in
        //
        //            if error != nil { return }
        //
        //                        let placemark = placemarks![0] as? CLPlacemark
        //
        //                        if let streetName = placemark!.addressDictionary!["Street"] as? String {
        //
        //                            DispatchQueue.main.async(execute: { () -> Void in
        //
        //                                let pizzaAnnotation = PizzaAnnotation(coordinate: self.currentLocation!.coordinate, title: "Pizza Hunters", subtitle: streetName)
        //
        //                                self.mapView!.addAnnotation(pizzaAnnotation)
        //
        //                            })
        //
        //                        }
        //
        //        } as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler as! CLGeocodeCompletionHandler
        
        
        //        self.geocoder.reverseGeocodeLocation(self.currentLocation!, completionHandler: { (placemarks :[AnyObject]!, error :NSError!) -> Void in
        //
        //            if error != nil { return }
        //
        //            let placemark = placemarks[0] as! CLPlacemark
        //
        //            if let streetName = placemark.addressDictionary!["Street"] as? String {
        //
        //                dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //
        //                    let pizzaAnnotation = PizzaAnnotation(coordinate: self.currentLocation!.coordinate, title: "Pizza Hunters", subtitle: streetName)
        //
        //                    self.mapView!.addAnnotation(pizzaAnnotation)
        //                    
        //                })
        //                
        //            }
        //            
        //        })
        
        
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if(motion == .motionShake) {
            
            addAnnotationToMap()
            
        }
        
    }
    
}
