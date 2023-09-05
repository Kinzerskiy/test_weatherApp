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
    let cod: String
    let message: Int
    let cnt: Int
    let list: [HourlyWeatherItem]
    let city: City
}

struct HourlyWeatherItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dt_txt: String
}

struct Clouds: Codable {
    let all: Int
}

struct Rain: Codable {
    let h1: Double?
    
    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
    }
}

struct Sys: Codable {
    let pod: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
