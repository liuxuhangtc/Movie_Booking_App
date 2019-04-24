//
//  MapViewController.swift
//  MovelRater
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit
import MapKit
class GoogleMapViewController: MTBaseViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet var distancePicker: DistancePicker!
    @IBOutlet var mapView: MKMapView!
    var searchRadiusOverlay: MKOverlay?
    var searchRadiusActive: Bool {
        return distancePicker.selectedValue != .greatestFiniteMagnitude //&& isValidAuthorizationStatus(authorizationStatus)
    }
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    var locationManager = CLLocationManager()
    
    // MARK: - Configuration
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set map center
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        //use current location
        if let center: CLLocation = locationManager.location {
            let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                                                                      span: currentLocationSpan)
            
            //set display
            self.mapView.setRegion(currentRegion, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movie Map"
        // Every time the user manipulates the distance picker, an action is
        // sent when the pan animation stops. We use this opportunity to update
        // the map rect and search radius to match the selected distance.
        distancePicker.target = self
        distancePicker.action = #selector(updateUI)
        
        mapView.delegate = self
        //mapView.isHidden = true
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        
        
        locationManager.startUpdatingLocation()
        
    }
    
    var tocoor : CLLocationCoordinate2D {
        return mapView.userLocation.coordinate
    }
    
    func isValidAuthorizationStatus(_ status: CLAuthorizationStatus) -> Bool {
        // For iOS 7, AuthorizedAlways corresponds to Authorized
        return status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        authorizationStatus = status
        
        if isValidAuthorizationStatus(status) {
            mapView.showsUserLocation = true
        }
        updateUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //tocoor = locations.last?.coordinate
        search()
    }
    
    // MARK: - Updating UI
    
    @IBAction func updateUI() {
        updateSearchRadiusOverlay()
        updateVisibleMapRect()
        
        search()
    }
    func search() {
        //        guard let coor = tocoor else {
        //            return
        //        }
        

        let region = MKCoordinateRegion(center: tocoor, latitudinalMeters: distancePicker.selectedValue, longitudinalMeters: distancePicker.selectedValue)

        let req = MKLocalSearch.Request()

        req.region=region

        req.naturalLanguageQuery = "cinema"

        let ser = MKLocalSearch(request: req)

        ser.start { (response, error) in

            let array = response?.mapItems
            array?.forEach({ (item) in
                let point = MKPointAnnotation()
                point.title=item.name
                point.subtitle=item.phoneNumber
                point.coordinate=item.placemark.coordinate
                self.mapView.addAnnotation(point)
            })
        }
        
    }
    func updateSearchRadiusOverlay() {
        if let overlay = searchRadiusOverlay {
            mapView.removeOverlay(overlay)
            searchRadiusOverlay = nil
        }
        
        if searchRadiusActive {
            searchRadiusOverlay = MKCircle(center: mapView.userLocation.coordinate,
                                           radius: distancePicker.selectedValue)
            mapView.addOverlay(searchRadiusOverlay!)
        }
    }
    
    func updateVisibleMapRect() {
        if searchRadiusActive {
            let overlayInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            let mapRect = mapView.mapRectThatFits(searchRadiusOverlay!.boundingMapRect, edgePadding: overlayInset)
            
            mapView.setVisibleMapRect(mapRect, animated: false)
        }
        else if isValidAuthorizationStatus(authorizationStatus) {
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        }
        // On launch, hide the map until we know the user location, otherwise
        // the map is briefly centered on another location.
        mapView.isHidden = false
    }
    
    // MARK: - Map View Delegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateUI()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            
            let circle = MKCircleRenderer(overlay: overlay)
            
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor.red.withAlphaComponent(0.1)
            circle.lineWidth = 1
            
            return circle
        }
        else {
            fatalError("Unexpected overlay type")
        }
    }
}

