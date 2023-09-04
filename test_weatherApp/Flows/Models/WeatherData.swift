//
//  WeatherData.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation

struct WeatherData: Codable {
    
    let city: City
    let currently: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
    
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coordinate
        let country: String
        let timezone: Int
        
        struct Coordinate: Codable {
            let lon: Double
            let lat: Double
        }
    }
    
    struct CurrentWeather: Codable {
        let temp: Double
        let humidity: Int
        let windSpeed: Double
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case temp
            case humidity
            case windSpeed = "speed"
            case weather
        }
    }
    
    struct HourlyWeather: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        
        struct Main: Codable {
            let temp: Double
        }
    }
    
    struct DailyWeather: Codable {
        let dt: Int
        let temp: Temperature
        let weather: [Weather]
        
        struct Temperature: Codable {
            let min: Double
            let max: Double
        }
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let icon: String
    }
}
