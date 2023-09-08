//
//  WeatherViewModel.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewModel {
    
    var weather: WeatherModel?
    var hourlyWeather: [HourlyWeatherItem] = []
    var daylyWeather: [DailyWeatherItem] = []
    
    var errorCompletion: ((Error) -> Void)?
    
    var currentCoordinate: CLLocationCoordinate2D?
    
    func loadCurrentLocationWeather(completion: @escaping () -> Void) {
        guard let coordinate = currentCoordinate else { return }
        WeatherManager.fetchWeather(latitude: coordinate.latitude,
                                    longitude: coordinate.longitude) { [weak self] weatherModel, error in
            if let error = error {
                self?.errorCompletion?(error)
            }
            self?.weather = weatherModel
            completion()
        }
    }
    
    func loadhHourlyWeather(completion: @escaping () -> Void) {
        guard let coordinate = currentCoordinate else { return }
        WeatherManager.fetchHourlyWeather(latitude: coordinate.latitude,
                                          longitude: coordinate.longitude) { [weak self] weatherItems, error in
            if let error = error {
                self?.errorCompletion?(error)
            } else if let weatherItems = weatherItems {
                self?.hourlyWeather = weatherItems
                completion()
            }
        }
    }
    
    func  loadDailyWeather(completion: @escaping () -> Void) {
        guard let coordinate = currentCoordinate else { return }
        WeatherManager.fetchDailyWeather(latitude: coordinate.latitude,
                                         longitude: coordinate.longitude) { [weak self] weatherItems, error in
            if let error = error {
                self?.errorCompletion?(error)
            } else if let weatherItems = weatherItems {
                self?.daylyWeather = weatherItems
                completion()
            }
        }
    }
    
    func updateWeather(by index: Int) {
        let selectedWeather = daylyWeather[index]
        
        weather = selectedWeather.getWeatherModel(for: weather?.cityName ?? "")
    }
}
