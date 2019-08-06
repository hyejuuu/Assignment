//
//  Weather.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation

// MARK: - Weather
struct WeatherData: Codable {
    let coord: Coord?
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Double?
    let id: Int?
    let name: String?
    let cod: Int?
    let rain: Rain?
}

// MARK: - Coord
struct Coord: Codable {
    let lon: Double?
    let lat: Double?
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

// MARK: - Main
struct Main: Codable {
    let temp: Double?
    let pressure: Double?
    let humidity: Int?
    let tempMin: Double?
    let tempMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Double?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Sys
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}

// MARK: - Rain
struct Rain: Codable {
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}
