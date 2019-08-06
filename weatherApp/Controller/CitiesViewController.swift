//
//  CitysViewController.swift
//  weatherApp
//
//  Created by 이혜주 on 03/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit
import CoreLocation

class CitiesViewController: UIViewController {
    private var citys: [WeatherData] = []
    
    private let semaphore = DispatchSemaphore(value: 1)
    private let serialQueue = DispatchQueue(label: "com.weatherApp.serialQueue")
    
    private let weatherService: WeatherService
        = DependencyContainer.shared.getDependency(key: .weatherService)
    
    private let indicatorView: CustomIndicatorView = {
        let customIndicator = CustomIndicatorView()
        customIndicator.translatesAutoresizingMaskIntoConstraints = false
        return customIndicator
    }()
    
    private lazy var citysTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupCitys()
        setupTableView()
    }
    
    private func setupCitys() {
        LocationCache.locations.forEach {
            requestData($0)
        }
    }

    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(citysTableView)
        view.addSubview(indicatorView)
        
        indicatorView.topAnchor.constraint(
            equalTo: view.topAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
        
        citysTableView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        citysTableView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        citysTableView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        citysTableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupTableView() {
        let cityNib = UINib(nibName: "CityTableViewCell", bundle: nil)
        citysTableView.register(cityNib,
                                forCellReuseIdentifier: "cityCell")
        
        citysTableView.register(SearchTableViewCell.self,
                                forCellReuseIdentifier: "SearchCell")
    }
    
    private func requestData(_ location: Location) {
        indicatorView.indicatorStartAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        serialQueue.async {
            self.semaphore.wait()
            self.weatherService.requestWeatherWith(latitude: location.latitude,
                                                   longitude: location.longitude) { [weak self] result in
                switch result {
                case .success(let weatherData):
                    self?.citys.append(weatherData)
                    DispatchQueue.main.async {
                        self?.citysTableView.reloadData()
                        self?.indicatorView.indicatorStopAnimating()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self?.semaphore.signal()
                    }
                case .failure(let error):
                    print(error)
                    self?.indicatorView.indicatorStopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self?.semaphore.signal()
                    return
                }
            }
        }
       
    }
    
    func reloadSubview() {
        requestData(LocationCache.locations[LocationCache.locations.endIndex - 1])
    }
    
    func presentSearchController() {
        present(SearchViewController(),
                animated: true)
    }
}

extension CitiesViewController: UITableViewDelegate {
}

extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return citys.count + 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case citys.count:
            guard let cell
                = tableView.dequeueReusableCell(withIdentifier: "SearchCell",
                                                for: indexPath) as? SearchTableViewCell else {
                                                    return .init()
            }
            
            cell.searchButtonDelegate = presentSearchController
            
            return cell
        default:
            guard let cell
                = tableView.dequeueReusableCell(withIdentifier: "cityCell",
                                                for: indexPath) as? CityTableViewCell else {
                return .init()
            }
            
            cell.cityNameLabel?.text = citys[indexPath.row].name
            
            guard let temp = citys[indexPath.row].main?.temp else {
                return cell
            }

            cell.temperatureLabel?.text = "\(Int(temp - 273.15))°"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != citys.count {
            guard let presenting = presentingViewController as? MainWeatherViewController else {
                return
            }
            
            presenting.weatherData = citys[indexPath.row]
            presenting.reloadSubview()
            dismiss(animated: true)
        }
    }
}
