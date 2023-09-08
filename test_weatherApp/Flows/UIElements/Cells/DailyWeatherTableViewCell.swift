//
//  DailyWeatherTableViewCell.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    var models: DailyWeatherItem?
    var onCellSelected: ((Double, Double) -> Void)?
    
    static let identifier = "DailyWeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyWeatherTableViewCell",
                     bundle: nil)
    }
    
    func configure(with model: DailyWeatherItem) {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = inputFormatter.date(from: model.dt_txt) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            self.dayOfTheWeekLabel.text = outputFormatter.string(from: date)
        } else {
            self.dayOfTheWeekLabel.text = "Unknown"
        }
        
        if let firstWeather = model.weather.first {
            let weatherModel = WeatherModel(
                conditionId: firstWeather.id,
                cityName: "",
                temperature: model.main.temp,
                tempMin: model.main.tempMin,
                tempMax: model.main.tempMax,
                humidity: model.main.humidity,
                description: firstWeather.description,
                windSpeed: nil,
                date: nil
            )
            
            onCellSelected = { [weak self] max, min in
                self?.tempMax.text = String(format: "%.1f°C", max)
                self?.tempMin.text = String(format: "%.1f°C", min)
            }
            
            self.tempMax.text = String(format: "%.1f°C", weatherModel.tempMaxCelsius)
            self.tempMin.text = String(format: "%.1f°C", weatherModel.tempMinCelsius)
            
            self.conditionImage.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
}
