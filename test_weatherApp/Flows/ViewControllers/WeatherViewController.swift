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
        tableView.register(HeaderTableViewCell.nib(), forCellReuseIdentifier: HeaderTableViewCell.identifier)


        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    
    
    
    func createTableHeader() -> UIView {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier) as? HeaderTableViewCell else {
            return UIView()
        }
        guard let currentWeather = self.viewModel.manager.weather else {
            return UIView()
        }
        cell.configure(with: currentWeather)
        return cell.contentView
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
