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
