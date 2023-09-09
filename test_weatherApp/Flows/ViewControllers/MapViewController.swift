//
//  MapViewController.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var mapView: MKMapView!
    var viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupGesture()
    }
    
    func setupMapView() {
        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }
    
    func selectCoordinate(_ coordinate: CLLocationCoordinate2D) {
        viewModel.didSelectCoordinate?(coordinate)
    }
    
    func setupGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressGesture.delegate = self
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    func showWeatherPopupFor(coordinate: CLLocationCoordinate2D) {
        let alertController = UIAlertController(title: "Confirm", message: "Show weather for this location?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default) { [weak self] _ in
            alertController.dismiss(animated: true) {
                self?.viewModel.selectCoordinate(coordinate)
                self?.navigationController?.popViewController(animated: true)
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            showWeatherPopupFor(coordinate: coordinate)
        }
    }
}
