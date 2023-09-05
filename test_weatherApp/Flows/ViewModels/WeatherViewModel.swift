//
//  WeatherViewModel.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation
import UIKit

class WeatherViewModel {
    let manager = WeatherManager()
    var hourlyWeather: [HourlyWeatherItem] = []
    var daylyWeather: [DailyWeatherItem] = []
}
