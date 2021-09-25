//
//  MyLocationViewController.swift
//  carowash
//
//  Created by Orlando Ortega on 04/09/21.
//

import UIKit
import MapKit
import CoreLocation

private let reuseIdentifier = "LocationCell"

private enum BackButtonConfiguration {
    case dismissMapView
    case dismissActionView

    init() {
        self = .dismissMapView
    }
}

protocol MyLocationViewControllerDelegate: class {
    func passLabel(label: String)
}

class MyLocationViewController: UIViewController {

    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    private let tabBarView = TabBarViewController()
    private let locationBarView = LocationBarView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private var searchResults = [MKPlacemark]()
    private let locationActionView = LocationActionView()
    private var returnButtonConfig = BackButtonConfiguration()
    private var isCentered = false
    weak var delegate: MyLocationViewControllerDelegate?

    private final let locationInputViewHeight: CGFloat = 200
    private final let locationActionViewHeight: CGFloat = 300

    private var returnButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Configurations
    func configureUI() {
        setUpLocation()
        setUpMapView()
        setUpSearchBar()
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

    func setUpSearchBar() {
        configureLocationActionView()

        view.addSubview(returnButton)
        returnButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            paddingTop: 16, paddingLeft: 20, width: 30, height: 30)

        view.addSubview(locationBarView)
        locationBarView.centerX(inView: view)
        locationBarView.setDimensions(height: 50, width: view.frame.width - 64)
        locationBarView.anchor(top: returnButton.bottomAnchor, paddingTop: 32)
        locationBarView.alpha = 0
        locationBarView.delegate = self

        UIView.animate(withDuration: 2) {
            self.locationBarView.alpha = 1
        }
        configureBackButton(config: .dismissMapView)
        configureTableView()
    }

    func configureInputView() {
        locationInputView.delegate = self
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor,
                                 right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0

        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()

        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height,
                                 width: view.frame.width, height: height)

        view.addSubview(tableView)
    }

    func configureLocationActionView() {
        view.addSubview(locationActionView)
        locationActionView.delegate = self
        locationActionView.frame = CGRect(x: 0, y: view.frame.height,
                                          width: view.frame.width, height: locationActionViewHeight)
    }

    func dismissLocationView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.removeFromSuperview()
        }, completion: completion)
    }

    func confirmLocationDissmiss(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.mapView.alpha = 0
            self.locationActionView.alpha = 0
        }, completion: completion)
    }

    func animateConfirmActionView(shouldShow: Bool, pin: MKPlacemark? = nil) {
        let yOrigin = shouldShow ? self.view.frame.height -
            self.locationActionViewHeight : self.view.frame.height

        if shouldShow {
            guard let pin = pin else { return }
            locationActionView.placemark = pin
        }

        UIView.animate(withDuration: 0.3) {
            self.locationActionView.frame.origin.y = yOrigin
        }
    }

    fileprivate func configureBackButton(config: BackButtonConfiguration) {
        switch config {
        case .dismissMapView:
            self.returnButton.setImage(#imageLiteral(resourceName: "Xicon").withRenderingMode(.alwaysOriginal), for: .normal)
            self.returnButtonConfig = .dismissMapView
        case .dismissActionView:
            returnButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            returnButtonConfig = .dismissActionView
        }
    }

    func removeView() {
        self.tabBarView.modalPresentationStyle = .fullScreen
        self.present(self.tabBarView, animated: true, completion: nil)
    }

    // MARK: - Selector
    @objc func backButtonPressed() {
        switch returnButtonConfig {
        case .dismissMapView:
            removeView()
        case .dismissActionView:
            mapView.annotations.forEach { (annotation) in
                if let pin = annotation as? MKPointAnnotation {
                    mapView.removeAnnotation(pin)
                }
            }

            UIView.animate(withDuration: 0.3) {
                self.locationBarView.alpha = 1
                self.animateConfirmActionView(shouldShow: false)
            }

            mapView.showAnnotations(mapView.annotations, animated: true)
        }
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

private extension MyLocationViewController {
    func searchBy(naturalLanguageQry: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()

        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQry

        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else { return }
            response.mapItems.forEach({ (item) in
                results.append(item.placemark)
            })
            completion(results)
        }
    }
}

// MARK: - MKMapViewDelegate
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
        self.mapView.removeOverlays(overl)
        print(overlay)
        return MKOverlayRenderer(overlay: overlay)
    }
}

// MARK: - LocationBarViewDelegate
extension MyLocationViewController: LocationBarViewDelegate {
    func presentBarView() {
        locationBarView.alpha = 0
        configureInputView()
    }
}

// MARK: - LocationInputViewDelegate
extension MyLocationViewController: LocationInputViewDelegate {
    func executeSearch(query: String) {
        searchBy(naturalLanguageQry: query) { (results) in
            self.searchResults = results
            self.tableView.reloadData()
        }
    }

    func dismissLocationInputView() {
        dismissLocationView { (_) in
            UIView.animate(withDuration: 0.5) {
                self.locationBarView.alpha = 1
            }
        }
    }
}

// MARK: - TableView [Delegate/DataSource]
extension MyLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Saved Locations" : "Results"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? LocationCell

        if indexPath.section == 1 {
            cell?.placemark = searchResults[indexPath.row]
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchResults[indexPath.row]

        configureBackButton(config: .dismissActionView)

        dismissLocationView { (_) in
            self.mapView.addAnnotationAndSelect(forCoordinate: selectedPlacemark.coordinate)

            let annotations = self.mapView.annotations.filter({ $0.isKind(of: MKPointAnnotation.self) })
            self.mapView.zoomToFit(annotations: annotations)
            self.animateConfirmActionView(shouldShow: true, pin: selectedPlacemark)
        }
    }
}

// MARK: - LocationActionView
extension MyLocationViewController: LocationActionViewDelegate {
    func confirmLocation(_ view: LocationActionView) {
        UIView.animate(withDuration: 0.3) {
            guard let ubicacion = view.placemark?.address else { return }
            self.confirmLocationDissmiss { (_) in
                let tbvc = TabBarViewController()
                tbvc.passLabel(label: ubicacion)
                tbvc.modalPresentationStyle = .fullScreen
                self.present(tbvc, animated: true, completion: nil)
            }
        }
    }
}
