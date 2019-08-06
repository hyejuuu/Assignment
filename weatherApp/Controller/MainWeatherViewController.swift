//
//  ViewController.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit
import CoreLocation

class MainWeatherViewController: UIViewController {
    let locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D()
    var weatherData: WeatherData?
    
    private let weatherDetailString = [["sunrise", "sunset"],
                                       ["wind", "humidity"],
                                       ["precipitation", "pressure"],
                                       ["Cloudiness", ""]]
    
    private let weatherService: WeatherService
        = DependencyContainer.shared.getDependency(key: .weatherService)
    
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        return formatter
    }()
    
    private let indicatorView: CustomIndicatorView = {
        let customIndicator = CustomIndicatorView()
        customIndicator.translatesAutoresizingMaskIntoConstraints = false
        return customIndicator
    }()
    
    private let safeAreaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let bottomBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var moveToListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("LIST", for: .normal)
        button.addTarget(self,
                         action: #selector(touchUpMoveToListButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var weatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupLayout()
        setupCollectionView()
    }
    
    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }

    private func setupLayout() {
        view.addSubview(weatherCollectionView)
        view.addSubview(safeAreaView)
        view.addSubview(bottomBarView)
        view.addSubview(indicatorView)
        bottomBarView.addSubview(moveToListButton)
        
        indicatorView.topAnchor.constraint(
            equalTo: view.topAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
        
        weatherCollectionView.topAnchor.constraint(
            equalTo: view.topAnchor).isActive = true
        weatherCollectionView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        weatherCollectionView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        weatherCollectionView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
        
        safeAreaView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        safeAreaView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        safeAreaView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
        safeAreaView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bottomBarView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        bottomBarView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        bottomBarView.bottomAnchor.constraint(
            equalTo: safeAreaView.topAnchor).isActive = true
        bottomBarView.heightAnchor.constraint(
            equalToConstant: 50).isActive = true
        
        moveToListButton.centerYAnchor.constraint(
            equalTo: bottomBarView.centerYAnchor).isActive = true
        moveToListButton.trailingAnchor.constraint(
            equalTo: bottomBarView.trailingAnchor,
            constant: -15).isActive = true
    }
    
    private func setupCollectionView() {
        
        // header
        let mainTemperatureHeader
            = UINib(nibName: "MainTemperatureCollectionReusableView",
                    bundle: nil)
        weatherCollectionView.register(mainTemperatureHeader,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: "mainTemperatureHeader")
        
        weatherCollectionView.register(TempCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: "tempHeader")
        
        // footer
        weatherCollectionView.register(TempCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                       withReuseIdentifier: "tempFooter")
        
        // cell
        weatherCollectionView.register(WeatherExplainCollectionViewCell.self,
                                       forCellWithReuseIdentifier: "weatherExplainCell")
        
        let weatherDetailNib = UINib(nibName: "WeatherDetailCollectionViewCell",
                                     bundle: nil)
        
        weatherCollectionView.register(weatherDetailNib,
                                       forCellWithReuseIdentifier: "weatherDetailCell")
        
        weatherCollectionView.register(UICollectionViewCell.self,
                                       forCellWithReuseIdentifier: "cell")
        
    }
    
    private func requestData() {
        indicatorView.indicatorStartAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        weatherService.requestWeatherWith(latitude: location.latitude,
                                          longitude: location.longitude) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.weatherData = weatherData
                DispatchQueue.main.async {
                    self?.weatherCollectionView.reloadData()
                    self?.indicatorView.indicatorStopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func reloadSubview() {
        weatherCollectionView.reloadData()
    }
    
    @objc private func touchUpMoveToListButton() {
        present(CitiesViewController(), animated: true)
    }

}

extension MainWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherExplainCell",
                                                    for: indexPath)
                    as? WeatherExplainCollectionViewCell else {
                        return .init()
            }
            
            guard let description = weatherData?.weather?[0].description else {
                return cell
            }
            
            cell.explainLabel.text = "Today: \(description)"
            
            return cell
        case 1:
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherDetailCell",
                                                     for: indexPath)
                    as? WeatherDetailCollectionViewCell else {
                        return .init()
            }
            
            cell.titleString = weatherDetailString[indexPath.item]
            
            switch indexPath.item {
            case 0:
                guard let sunrise = weatherData?.sys?.sunrise,
                    let sunset = weatherData?.sys?.sunset else {
                    return cell
                }
                let sunriseDate = Date(timeIntervalSince1970: sunrise)
                let sunriseTime = timeFormatter.string(from: sunriseDate)
                
                let sunsetDate = Date(timeIntervalSince1970: sunset)
                let sunsetTime = timeFormatter.string(from: sunsetDate)
                cell.valueString = [sunriseTime, sunsetTime]
            case 1:
                guard let deg = weatherData?.wind?.deg,
                    let speed = weatherData?.wind?.speed,
                    let humidity = weatherData?.main?.humidity else {
                    return cell
                }
                
                cell.valueString = ["\(deg)° \(Int(speed))m/s", "\(humidity)%"]
            case 2:
                guard let precipitation = weatherData?.rain?.threeHour,
                    let pressure = weatherData?.main?.pressure else {
                    return cell
                }
                cell.valueString = ["\(Int(precipitation / 10))cm", "\(pressure)hPa"]
            case 3:
                guard let cloudiness = weatherData?.clouds?.all else {
                    return cell
                }
                cell.valueString = ["\(cloudiness)%", ""]
            default:
                print("")
            }
            
            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                     for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header
                = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: "mainTemperatureHeader",
                                                                  for: indexPath) as? MainTemperatureCollectionReusableView else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "tempHeader",
                                                                       for: indexPath)
            }
            
            header.cityNameLabel.text = weatherData?.name
            header.weatherLabel.text = weatherData?.weather?[0].main
            if let temp = weatherData?.main?.temp,
                let minTemp = weatherData?.main?.tempMin,
                let maxTemp = weatherData?.main?.tempMax,
                let timezone = weatherData?.timezone {
                
                header.temperatureLabel.text = "\(Int(temp - 273.15))°"
                header.minTemperatureLabel.text = "\(Int(minTemp - 273.15))"
                header.maxTemperatureLabel.text = "\(Int(maxTemp - 273.15))"
                
                let date = Date(timeIntervalSince1970: timezone)
                let weekday = weekdayFormatter.string(from: date)
                
                header.weekdayLabel.text = weekday
            }
            
            return header
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "tempFooter",
                                                                   for: indexPath)
        }
    }
}

extension MainWeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: view.frame.width,
                          height: 200)
        default:
            return CGSize(width: view.frame.width,
                          height: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,
                      height: 80)
    }
}

extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let locationValue = manager.location?.coordinate else {
            return
        }
        manager.stopUpdatingLocation()
        
        location = locationValue
        requestData()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted, .denied:
            let alertController
                = UIAlertController(title: "Notice",
                                    message: "위치 서비스를 사용할 수 없습니다. 위치 서비스를 켜주세요",
                                    preferredStyle: .alert)
            
            let moveToSettingAction
                = UIAlertAction(title: "설정으로 이동",
                                style: .destructive) { (_) in
                guard let settingURL
                    = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(settingURL) {
                    UIApplication.shared.open(settingURL)
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소",
                                             style: .cancel)
            
            alertController.addAction(moveToSettingAction)
            alertController.addAction(cancelAction)
            
            present(alertController,
                    animated: true)
            break
        default:
            break
        }
    }
}
