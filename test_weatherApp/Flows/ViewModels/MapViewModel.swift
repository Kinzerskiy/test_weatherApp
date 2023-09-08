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
    
    func selectCoordinate(_ coordinate: CLLocationCoordinate2D) {
           didSelectCoordinate?(coordinate)
       }
}
