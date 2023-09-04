//
//  WeatherData.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation

struct WeatherResponse: Codable {
    let lat: Float
    let lon: Float
    let currently: CurrentWeather
    //    let hourly: HourlyWeather
    //    let daily: DailyWeather
    //    let offset: Float
}

struct CurrentWeather: Codable {
    let main: Main
    let weather: Weather
}

struct Main: Codable {
    let humidity: Int?
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let description: String?
    let id: Int
}


