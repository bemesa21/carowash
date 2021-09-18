//
//  MyLocationViewController.swift
//  carowash
//
//  Created by Orlando Ortega on 04/09/21.
//

import UIKit
import MapKit
import CoreLocation

class MyLocationViewController: UIViewController {

    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    let mySearchBar = LocationBarView()
    let locationInputView = LocationInputView()
    var isCentered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocation()
        setUpMapView()
        setUpSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setUpLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func setUpMapView() {
        mapView.delegate = self

        mapView.frame = view.bounds
        let noLocation = self.mapView.userLocation.coordinate
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let pinLocation = MKCoordinateRegion(center: noLocation, span: span)
        mapView.setRegion(pinLocation, animated: true)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(_:)))
        self.mapView.addGestureRecognizer(longPress)

        view.addSubview(mapView)
    }

    @objc func addAnnotation(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.began {
            return
        }

        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let newCoordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)

        let annotation = MKPointAnnotation()

        annotation.coordinate = newCoordinates
        annotation.title = "Virtual Location"
        annotation.subtitle = "Dropped Pin"

        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.removeAnnotation(annotation)

        let cent = newCoordinates
        let rad: Double = 500
        let circle = MKCircle(center: cent, radius: rad)

        self.mapView.addAnnotation(annotation)

        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.addOverlay(circle)

        print(newCoordinates)
        print(circle)
    }

    func setUpSearchBar() {
        view.addSubview(mySearchBar)
        mySearchBar.centerX(inView: view)
        mySearchBar.setDimensions(height: 50, width: view.frame.width - 64)
        mySearchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        mySearchBar.alpha = 0
        mySearchBar.delegate = self

        UIView.animate(withDuration: 2) {
            self.mySearchBar.alpha = 1
        }
    }

    func configureInputView() {
        locationInputView.delegate = self
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor,
                                 right: view.rightAnchor, height: 200)
        locationInputView.alpha = 0

        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            print("present table view")
        }

    }
}

extension MyLocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let location = locations[0]

        if !isCentered {
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                              longitude: location.coordinate.longitude)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation, span: span)
            mapView.setRegion(region, animated: true)
            isCentered = true
        }
        self.mapView.showsUserLocation = true
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension MyLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.CarOWash.mistyRose
            circleRenderer.strokeColor = UIColor.CarOWash.mistyRose
            circleRenderer.lineWidth = 0.5

            return circleRenderer
        }
        let overl = mapView.overlays
//        self.mapView.removeOverlays(overlay as? [MKCircle])
        self.mapView.removeOverlays(overl)
        print(overlay)
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension MyLocationViewController: LocationBarViewDelegate {
    func presentBarView() {
        mySearchBar.alpha = 0
        configureInputView()
    }
}

extension MyLocationViewController: LocationInputViewDelegate {
    func dismissLocationInputView() {
        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 0
        } completion: { (_) in
            UIView.animate(withDuration: 0.3) {
                self.mySearchBar.alpha = 1
            }
        }
    }
}
