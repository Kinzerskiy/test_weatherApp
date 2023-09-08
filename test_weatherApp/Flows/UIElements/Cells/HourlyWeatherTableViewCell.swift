//
//  HourlyWeatherTableViewCell.swift
//  test_weatherApp
//
//  Created by Mac Pro on 05.09.2023.
//

import UIKit


class HourlyWeatherTableViewCell: UITableViewCell {
    
    var hourlyWeatherData: [HourlyWeatherItem] = []
    
    
    static let identifier = "HourlyWeatherTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyWeatherTableViewCell",
                     bundle: nil)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(HourlyWeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configure(with data: [HourlyWeatherItem]) {
        self.hourlyWeatherData = data
        collectionView.reloadData()
    }
    
}

extension HourlyWeatherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyWeatherData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as! HourlyWeatherCollectionViewCell
        let hourlyItem = hourlyWeatherData[indexPath.row]
        cell.configure(with: hourlyItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}
