//
//  ViewController.swift
//  location
//
//  Created by Labuser on 4/2/17.
//  Copyright © 2017 wustl. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

var justOnce: Bool = true

class LocationViewController : UIViewController {
    
    
    var mapView: MKMapView!
    var locationSearchTable: LocationSearchTable!
    
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    var longitude = 0.0
    var latitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupMapView()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //let locationSearchTable = locationSearchTable()
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Choose a location"
        
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = self.mapView
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if justOnce {
            showSetCurrentAlert()
            justOnce = false
        }
        
    }
    
    func setupMapView() {
        self.mapView = MKMapView()
        self.mapView.frame = self.view.frame
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        self.view.addSubview(self.mapView)
        mapView.showsUserLocation = true
    }
    
    func setupTableView() {
        self.locationSearchTable = LocationSearchTable()
        self.locationSearchTable.view.frame = self.view.frame
        self.view.addSubview(self.locationSearchTable.view)
    }
    
    func showSetCurrentAlert() {
        let alert = UIAlertController(title: "Choose a location", message: "Would you like to set location to your current location?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: setToCurrentLocation))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setToCurrentLocation(alert: UIAlertAction!) {
        
        while (self.latitude == 0.0) {
            //wait  
        }
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        //myAnnotation.coordinate = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude);
        myAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.addAnnotation(myAnnotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(myAnnotation.coordinate, span)
        mapView.setRegion(region, animated: true)
        let count = self.navigationController?.viewControllers.count;
        let menuVC = self.navigationController?.viewControllers[count!-2] as! MenuViewController
        menuVC.latitude = String(describing: myAnnotation.coordinate.latitude)
        menuVC.longitude = String(describing: myAnnotation.coordinate.longitude)
        YourLocationIsSet()
    }
    
    func YourLocationIsSet() {
        let alert = UIAlertController(title: "Success", message: "Your location is sucessfully set", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: gotoMenuPage))
        //alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotoMenuPage(alert: UIAlertAction!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}



extension LocationViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue:CLLocationCoordinate2D = locationManager.location?.coordinate {
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension LocationViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.YourLocationIsSet()
        }
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        let count = self.navigationController?.viewControllers.count;
        let menuVC = self.navigationController?.viewControllers[count!-2] as! MenuViewController
        menuVC.latitude = String(describing: selectedPin!.coordinate.latitude)
        menuVC.longitude = String(describing: selectedPin!.coordinate.longitude)
        
    }
    
}


