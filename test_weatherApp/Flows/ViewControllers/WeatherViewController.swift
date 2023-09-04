//
//  WeatherViewController.swift
//  test_weatherApp
//
//  Created by Mac Pro on 04.09.2023.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var model = [Weathers]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.dataSource = self
    }


}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
}

struct Weathers {
    
}
