//
//  MapExtension.swift
//  carowash
//
//  Created by Orlando Ortega on 23/09/21.
//

import UIKit
import MapKit

extension MKPlacemark {
    var address: String? {
        // swiftlint:disable implicit_getter
        get {
            guard let subThoroughfare = subThoroughfare else { return nil }
            guard let thoroughfare = thoroughfare else { return nil }
            guard let locality = locality else { return nil }
            guard let adminArea = administrativeArea else { return nil }

            return "\(subThoroughfare) \(thoroughfare), \(locality), \(adminArea) "
        }
        // swiftlint:enable implicit_getter
    }
}

extension MKMapView {
    func zoomToFit(annotations: [MKAnnotation]) {
        var zoomRect = MKMapRect.null

        annotations.forEach { (annotation) in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y,
                                      width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }

        let insets = UIEdgeInsets(top: 100, left: 100, bottom: 300, right: 100)
        setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
    }

    func addAnnotationAndSelect(forCoordinate coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        addAnnotation(annotation)
        selectAnnotation(annotation, animated: true)
    }
}
