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
        self.hoursLabel.text = model.dt_txt
        self.tempLabel.text = String(format: "%.1f", model.main.temp ?? 0) + "°C"
        
        if let firstWeather = model.weather.first {
            let weatherModel = WeatherModel(
                conditionId: firstWeather.id,
                cityName: "",
                temperature: model.main.temp ?? 0,
                tempMin: model.main.tempMin,
                tempMax: model.main.tempMax,
                humidity: model.main.humidity,
                description: firstWeather.description)
            
            self.conditionImage.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
}
