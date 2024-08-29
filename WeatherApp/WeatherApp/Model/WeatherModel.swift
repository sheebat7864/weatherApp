//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Sheeba Tanveer on 2024-05-14.
//

import Foundation

struct GeocodingData: Codable {
    let lat: Double
    let lon: Double
}

struct WeatherResponse: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let name: String
    
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        
        private enum CodingKeys: String, CodingKey {
            case temp, feelsLike = "feels_like", tempMin = "temp_min", tempMax = "temp_max", pressure, humidity
        }
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}

struct ForecastResponse: Codable {
    let list: [Forecast]
    
    struct Forecast: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        
        struct Main: Codable {
            let temp: Double
        }
        
        struct Weather: Codable {
            let description: String
        }
    }
}

