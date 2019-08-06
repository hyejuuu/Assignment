//
//  EndPoint.swift
//  weatherApp
//
//  Created by 이혜주 on 07/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation

class EndPoint {
    static let shared = EndPoint()
    let baseURL = "https://api.openweathermap.org"
    let appID = "9da3ad8a03f0757943105b118dc14e63"
    
    private init() {
    }
}

public enum WeatherAPI: String {
    case weather
    
    public var urlComponents: URLComponents? {
        
        get {
            guard var components = URLComponents(string: EndPoint.shared.baseURL) else {
                return nil
            }
            
            components.path = "/data/2.5/weather"
            components.queryItems = [
                URLQueryItem(name: "APPID", value: EndPoint.shared.appID)
            ]
            return components
        }
        
        set {}
    }
}
