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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    static let identifier = "DailyWeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyWeatherTableViewCell",
                     bundle: nil)
    }
    
    
    func configure(with model: DailyWeatherItem) {

        self.dayOfTheWeekLabel.text = model.dt_txt
        self.tempMax.text = String(format: "%.1f", model.main.temp) + "°C"
        
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
                
            self.conditionImage.image = UIImage(systemName: weatherModel.conditionName)
        }
    }

}
