//
//  MapViewModel.swift
//  test_weatherApp
//
//  Created by Mac Pro on 08.09.2023.
//

import Foundation
import MapKit


class MapViewModel {
    
    var didSelectCoordinate: ((CLLocationCoordinate2D) -> Void)?
    var didUpdateSearchResults: (([MKMapItem]) -> Void)?
    
    func selectCoordinate(_ coordinate: CLLocationCoordinate2D) {
        didSelectCoordinate?(coordinate)
    }
    
    func searchForCity(_ searchText: String, in region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            guard let items = response?.mapItems else { return }
            self?.didUpdateSearchResults?(items)
        }
    }
    
}
