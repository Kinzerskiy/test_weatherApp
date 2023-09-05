//
//  WeatherManager.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import Foundation
import CoreLocation


class WeatherManager {
    
    var weather: WeatherModel?
    
    func fetchWeather(latitude: Float, longitude: Float, completion: @escaping () -> Void) {
        
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: "64a9508f6f5e235e99b38adb50fd82ea")
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    
                    
                    let main = decodedResponse.main
                    let weatherItem = decodedResponse.weather.first
                    let name = decodedResponse.name

                    self.weather = WeatherModel(
                        conditionId: weatherItem?.id ?? 0,
                        cityName: name,
                        temperature: main.temp,
                        tempMin: main.tempMin,
                        tempMax: main.tempMax,
                        humidity: main.humidity,
                        description: weatherItem?.description
                    )
                    completion()
                } catch {
                    print("Failed to decode: \(error)")
                    completion()
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion()
            }
        }.resume()
    }
    
    
    func fetchHourlyWeather(latitude: Float, longitude: Float, completion: @escaping ([HourlyWeatherItem]) -> Void) {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast?")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: "64a9508f6f5e235e99b38adb50fd82ea")
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    let decodedResponse = try JSONDecoder().decode(HourlyWeatherResponse.self, from: data)
                    completion(decodedResponse.list)
                } catch {
                    print("Failed to decode hourly data: \(error)")
                    completion([])
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
            }
        }.resume()
    }
    
    func fetchDailyWeather(latitude: Float, longitude: Float, completion: @escaping ([DailyWeatherItem]) -> Void) {
        
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast?")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "cnt", value: "7"),
            URLQueryItem(name: "appid", value: "64a9508f6f5e235e99b38adb50fd82ea")
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(DailyWeatherResponse.self, from: data)
                    
                    print(String(data: data, encoding: .utf8) ?? "Invalid data")

                    completion(decodedResponse.list)
                }
            
            catch DecodingError.keyNotFound(let key, let context) {
                print("Key not found: \(key.stringValue) in \(context.debugDescription)")
            } catch DecodingError.typeMismatch(_, let context) {
                print("Type mismatch: \(context.debugDescription)")
            } catch {
                print("Other decoding error: \(error)")
            }
              
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
            }
        }.resume()
    }


}
