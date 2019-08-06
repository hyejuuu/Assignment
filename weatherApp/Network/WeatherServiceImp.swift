//
//  WeatherServiceImp.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherServiceImp: WeatherService {
    let requestMaker: RequestMaker
    let network: Network
    
    init(requestMaker: RequestMaker,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestWeatherWith(latitude: CLLocationDegrees,
                            longitude: CLLocationDegrees,
                            completion: @escaping (Result<WeatherData, Error>) -> Void) {
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.path = "/data/2.5/weather"
        urlComponent?.queryItems = [URLQueryItem(name: "lat",
                                                 value: String(latitude)),
                                    URLQueryItem(name: "lon",
                                                 value: String(longitude)),
                                    URLQueryItem(name: "APPID",
                                                 value: "9da3ad8a03f0757943105b118dc14e63")]
        
        guard let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: nil,
                                       body: nil) else {
            completion(.failure(NSError(domain: "request error",
                                        code: 0,
                                        userInfo: nil)))
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(WeatherData.self,
                                               from: data)
                    
                    completion(.success(decodedData))
                } catch let error {
                    completion(.failure(error))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
