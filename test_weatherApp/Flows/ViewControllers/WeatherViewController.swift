//
//  WeatherViewController.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HourlyWeatherTableViewCell.nib(), forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        tableView.register(DailyWeatherTableViewCell.nib(), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    
    
    
    func createTableHeader() -> UIView {
        let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))

        headerVIew.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/2))

        headerVIew.addSubview(locationLabel)
        headerVIew.addSubview(tempLabel)
        headerVIew.addSubview(summaryLabel)

        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center

        locationLabel.text = "Current Location"

        guard let currentWeather = self.viewModel.manager.weather else {
            return UIView()
        }

        tempLabel.text = "\(currentWeather.temperature)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        locationLabel.text = currentWeather.cityName
        summaryLabel.text = currentWeather.description ?? "No description available"

        return headerVIew
    }
    

}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherTableViewCell.identifier, for: indexPath) as! HourlyWeatherTableViewCell
            cell.configure(with: viewModel.hourlyWeather)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as! DailyWeatherTableViewCell
            cell.configure(with: viewModel.daylyWeather[indexPath.row])
            return cell
        default:
            fatalError("Unknown section")
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.daylyWeather.count
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250.0
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil  {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()

            if let lat = currentLocation?.coordinate.latitude, let long = currentLocation?.coordinate.longitude {
                
               
                viewModel.manager.fetchWeather(latitude: Float(lat), longitude: Float(long)) {
                    DispatchQueue.main.async {
                        self.tableView.tableHeaderView = self.createTableHeader()
                        self.tableView.reloadData()
                    }
                }
                
                viewModel.manager.fetchHourlyWeather(latitude: Float(lat), longitude: Float(long)) { hourlyData in
                    DispatchQueue.main.async {
                        self.viewModel.hourlyWeather = hourlyData
                        self.tableView.reloadData()
                    }
                }
                
                viewModel.manager.fetchDailyWeather(latitude: Float(lat), longitude: Float(long)) { dailyData in
                    DispatchQueue.main.async {
                        self.viewModel.daylyWeather = dailyData
                        self.tableView.reloadData()
                    }
                }

                
            }
        }
    }

}
