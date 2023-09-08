//
//  WeatherManager.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case invalidUrl
}


class WeatherManager {
    
    static func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherModel?, Error?) -> Void) {
        
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: "64a9508f6f5e235e99b38adb50fd82ea")
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            completion(nil, NetworkError.invalidUrl)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    
                    
                    completion(decodedResponse.weatherModel, nil)
                    
                } catch {
                    print("Failed to decode: \(error)")
                    completion(nil, error)
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, error)
            }
        }.resume()
    }
    
    
    
    
    static func fetchHourlyWeather(latitude: Double, longitude: Double, completion: @escaping ([HourlyWeatherItem]?, Error?) -> Void) {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast?")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: "64a9508f6f5e235e99b38adb50fd82ea")
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            completion(nil, NetworkError.invalidUrl)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    let decodedResponse = try JSONDecoder().decode(HourlyWeatherResponse.self, from: data)
                    completion(decodedResponse.list, nil)
                } catch {
                    print("Failed to decode hourly data: \(error)")
                    completion(nil, error)
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, error)
            }
        }.resume()
    }
    
    static func fetchDailyWeather(latitude: Double, longitude: Double, completion: @escaping ([DailyWeatherItem]?, Error?) -> Void) {
        
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast?")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "cnt", value: "7"),
            URLQueryItem(name: "appid", value: "64a9508f6f5e235e99b38adb50fd82ea")
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            completion(nil, NetworkError.invalidUrl)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(DailyWeatherResponse.self, from: data)
                    
                    print(String(data: data, encoding: .utf8) ?? "Invalid data")
                    
                    completion(decodedResponse.list, nil)
                } catch {
                    print("Failed to decode hourly data: \(error)")
                    completion(nil, error)
                }
                
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, error)
            }
        }.resume()
    }
}
