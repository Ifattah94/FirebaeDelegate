//
//  MainMapViewController.swift
//  FirebaeDelegate
//
//  Created by C4Q on 11/19/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainMapViewController: UIViewController {

    //MARK: UI Objects
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.mapType = .standard
        return mv
    }()
    
    // MARK: Private Properties
    private let locationManager = CLLocationManager()
    private let initialLocation = CLLocationCoordinate2D(latitude: 40.742054, longitude: -73.769417)
    private let searchRadius: CLLocationDistance = 2000
    
    private var pins = [Pin]() {
        didSet {
            mapView.addAnnotations(pins)
            mapView.showAnnotations(pins, animated: true)
        }
    }
      
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setupMapView()
        setupMap()
        requestLocationAndAuthorizeIfNeeded()
        setupLongPressGesture()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPins()
    }
    
    
    
    //MARK: Private Methods

    private func requestLocationAndAuthorizeIfNeeded() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
            default:
                locationManager.requestWhenInUseAuthorization()
            }
        }
    

    
    
    private func zoomIntoUserLocation() {
        if let userLocation = locationManager.location?.coordinate {
                               let coordinateRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: searchRadius, longitudinalMeters: searchRadius)
                               mapView.setRegion(coordinateRegion, animated: true)
                   }
    }
    
    private func zoomIntoInitialLocation(){
        let initialRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: searchRadius, longitudinalMeters: searchRadius)
                  mapView.setRegion(initialRegion, animated: true)
    }
    
    
    private func loadPins() {
        FirestoreService.manager.getAllPins { (result) in
            switch result {
            case .success(let pins):
                self.pins = pins
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addAnnotation(location: CLLocationCoordinate2D, title: String){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            self.mapView.addAnnotation(annotation)
    }

    private func showAlertForAddingNewPoint(location: CLLocationCoordinate2D) {
        let alertController = UIAlertController(title: "New Point", message: "Enter Info for new Point", preferredStyle: .alert)
               
               alertController.addTextField { (texField) in
                   texField.placeholder = "Title"
            
               }
        
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let title = alertController.textFields?[0].text else {return}
            
            guard let user = FirebaseAuthService.manager.currentUser else {
                print("You must be logged in to create a pin")
                return
            }
            let lat = Double(location.latitude)
            let long = Double(location.longitude)
            let newPin = Pin(title: title, creatorID: user.uid, lat: lat, long: long)
            
            FirestoreService.manager.createPin(pin: newPin) {[weak self] (result)
                in
                self?.handleCreatePinResponse(location: location, title: title, with: result)
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    private func handleCreatePinResponse( location: CLLocationCoordinate2D, title: String, with result: Result<Void, Error>) {
        switch result {
        case .success:
            self.addAnnotation(location: location, title: title)
        case .failure(let error):
            print(error)
        }
    }
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(sender:)))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    
    
    private func setupMap() {
         mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    
    //MARK: Obj C Methods
    
    @objc func handleLongTap(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            showAlertForAddingNewPoint(location: locationOnMap)
        }
    }
    
    
    
    //MARK: Constraint Methods
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    

  

}


extension MainMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Pin else {return nil}
        
        let identifier = "marker"
        
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
             view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Pin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.getMapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
}

extension MainMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New locations \(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("An error occurred: \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            self.zoomIntoUserLocation()
        case .denied:
            self.zoomIntoInitialLocation()
        default:
            break
        }
    }
}
