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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel = MapViewModel()
    var searchResults: [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupSearchBar()
        setupGesture()
        setupSearchResultsTableView()
        setupSearchResultsHandler()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.isTranslucent = true
        searchBar.backgroundColor = UIColor.clear
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
            
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
            let toolBar = UIToolbar()
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
            toolBar.sizeToFit()
            textField.inputAccessoryView = toolBar
        }
    }
    
    
    func setupSearchResultsTableView() {
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.isHidden = true
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        searchResultsTableView.backgroundColor = UIColor.white
        searchResultsTableView.alpha = 0.5
    }
    
    func setupSearchResultsHandler() {
        viewModel.didUpdateSearchResults = { [weak self] items in
            self?.searchResults = items
            self?.searchResultsTableView.reloadData()
            self?.searchResultsTableView.isHidden = items.isEmpty
        }
    }
    
    
    
    func setupMapView() {
        //        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
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
    
    func showSelectedLocation(at indexPath: IndexPath) {
        let selectedItem = searchResults[indexPath.row]
        searchResultsTableView.isHidden = true
        
        let coordinate = selectedItem.placemark.coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = selectedItem.placemark.name
        mapView.addAnnotation(annotation)
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
    
    @objc func doneButtonTapped() {
        searchBar.resignFirstResponder()
    }
}


extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchForCity(searchText, in: mapView.region)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResultsTableView.isUserInteractionEnabled = false
         searchResultsTableView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResultsTableView.isUserInteractionEnabled = true
    }
}

extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].placemark.name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showSelectedLocation(at: indexPath)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
            showWeatherPopupFor(coordinate: coordinate)
        }
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
}



