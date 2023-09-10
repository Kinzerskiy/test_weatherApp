//
//  WeatherModel.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation

struct WeatherModel {
    
    var conditionId: Int
    var cityName: String?
    var temperature: Double
    var tempMin: Double
    var tempMax: Double
    var humidity: Int
    var description: String?
    var windSpeed: Double?
    var date: Date?
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, d MMM"
        return dateFormatter.string(from: date ?? Date())
    }
    
    var tempeMinString: String {
        return String(format: "%.1f", tempMin)
    }
    
    var tempeMaxString: String {
        return String(format: "%.1f", tempMax)
    }
    
    var temperatureCelsius: Double {
        return temperature - 273.15
    }
    
    var tempMinCelsius: Double {
        return tempMin - 273.15
    }
    
    var tempMaxCelsius: Double {
        return tempMax - 273.15
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.rain"
        case 511:
            return "cloud.sleet"
        case 520...531:
            return "cloud.heavyrain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}

extension WeatherModel {
    init(from dailyWeather: DailyWeatherItem) {
        self.conditionId = dailyWeather.weather.first?.id ?? 0
        self.cityName = nil
        self.temperature = dailyWeather.main.temp
        self.tempMin = dailyWeather.main.tempMin
        self.tempMax = dailyWeather.main.tempMax
        self.humidity = dailyWeather.main.humidity
        self.description = dailyWeather.weather.first?.description
        self.windSpeed = dailyWeather.wind.speed
        self.date = Date(timeIntervalSince1970: TimeInterval(dailyWeather.dt))
    }
}
