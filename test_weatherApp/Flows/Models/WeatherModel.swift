//
//  WeatherModel.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation

struct WeatherModel {
    
    let conditionId: Int
    let cityName: String
    let tempMin: Double
    let tempMax: Double
    let humidity: Int?
    let description: String?
    
    var tempeMinString: String {
        return String(format: "%.1f", tempMin)
    }
    
    var tempeMaxString: String {
        return String(format: "%.1f", tempMax)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
