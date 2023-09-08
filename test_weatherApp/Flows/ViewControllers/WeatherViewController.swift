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
        
        prepareTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
        
        viewModel.errorCompletion = { [weak self] error in
            self?.handleError(error: error)
        }
    }
    
    func prepareTableView() {
        tableView.register(HourlyWeatherTableViewCell.nib(), forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        tableView.register(DailyWeatherTableViewCell.nib(), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        tableView.register(HeaderTableViewCell.nib(), forCellReuseIdentifier: HeaderTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func createTableHeader() -> UIView {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier) as? HeaderTableViewCell else {
            return UIView()
        }
        guard let currentWeather = self.viewModel.weather else {
            return UIView()
        }
        cell.configure(with: currentWeather)
        return cell.contentView
    }
    
    func fetchData() {
        viewModel.loadCurrentLocationWeather {
            DispatchQueue.main.async {
                self.tableView.tableHeaderView = self.createTableHeader()
                self.tableView.reloadData()
            }
        }
        
        viewModel.loadhHourlyWeather {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.loadDailyWeather {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func handleError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mapViewController = segue.destination as? MapViewController {
            mapViewController.selectedCoordinateCompletion = { [weak self] coordinate in
                self?.viewModel.currentCoordinate = coordinate
                self?.fetchData()
            }
        }
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
        switch indexPath.section {
        case 0:
            return 150.0
        case 1:
            return 80.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let selectedWeather = viewModel.daylyWeather[indexPath.row]
            
            let selectedWeatherModel = WeatherModel(from: selectedWeather)
            viewModel.updateWeather(by: indexPath.row)
            
            self.tableView.tableHeaderView = self.createTableHeader()
            
            tableView.deselectRow(at: indexPath, animated: true)
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
            
            if let coordinate = currentLocation?.coordinate {
                viewModel.currentCoordinate = coordinate
                fetchData()
            }
        }
    }
}
