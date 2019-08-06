//
//  WeatherService.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherService {
    func requestWeatherWith(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        completion: @escaping (Result<WeatherData, Error>) -> Void
    )
}
