//
//  HeaderTableViewCell.swift
//  test_weatherApp
//
//  Created by Mac Pro on 06.09.2023.
//

import UIKit


class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var cinditionImage: UIImageView!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var humadity: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    var models: WeatherResponse?
    var updateModel: DailyWeatherItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    static let identifier = "HeaderTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HeaderTableViewCell",
                     bundle: nil)
    }
    
    func updateTemperature(max: Double, min: Double) {
        tempMax.text = String(format: "%.1f°C", max)
        tempMin.text = String(format: "%.1f°C", min)
    }
    
    
    func configure(with model: WeatherModel) {
        cityName.text = model.cityName
        day.text = model.dateString
        cinditionImage.image = UIImage(systemName: model.conditionName)
        tempMax.text = String(format: "%.1f°C", model.tempMaxCelsius)
        tempMin.text = String(format: "%.1f°C", model.tempMinCelsius)
        humadity.text = "\(model.humidity) %"
        wind.text = model.windSpeed.map { "\($0) km/h" } ?? "N/A"
    }
}
