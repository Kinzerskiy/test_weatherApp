//
//  HourlyWeatherCollectionViewCell.swift
//  test_weatherApp
//
//  Created by Mac Pro on 05.09.2023.
//

import UIKit


class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var models: HourlyWeatherResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static let identifier = "HourlyWeatherCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyWeatherCollectionViewCell",
                     bundle: nil)
    }
    
    func configure(with model: HourlyWeatherItem) {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = inputFormatter.date(from: model.dt_txt) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            self.hoursLabel.text = outputFormatter.string(from: date)
        } else {
            self.hoursLabel.text = "Unknown"
        }
        
        let weatherModel = WeatherModel(
            conditionId: model.weather.first?.id ?? 0,
            cityName: "",
            temperature: model.main.temp,
            tempMin: model.main.tempMin,
            tempMax: model.main.tempMax,
            humidity: model.main.humidity,
            description: model.weather.first?.description,
            windSpeed: nil,
            date: nil
        )
        
        self.tempLabel.text = String(format: "%.1f", weatherModel.tempMaxCelsius) + "°C"
        if let _ = model.weather.first {
            self.conditionImage.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
}
