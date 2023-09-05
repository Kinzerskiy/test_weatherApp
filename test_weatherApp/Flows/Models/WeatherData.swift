//
//  WeatherData.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
 
    let tempMin: Double
    let tempMax: Double
    
    let humidity: Int
   

    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Wind: Codable {
    let speed: Double
}


struct HourlyWeatherResponse: Codable {
    let list: [HourlyWeatherItem]
    let city: City
}

struct HourlyWeatherItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
    let pop: Double
    let dt_txt: String
}

struct DailyWeatherResponse: Codable {
    let list: [DailyWeatherItem]
    let city: City
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
}

struct DailyWeatherItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
    let pop: Double
    let dt_txt: String
    
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
