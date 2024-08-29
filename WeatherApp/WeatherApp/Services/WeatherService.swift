//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Sheeba Tanveer on 2024-04-22.
//

import Foundation
class WeatherService {
    private let apiKey = "dafb3a05a3314807e94ab4c64a3a1409"
    
    func fetchWeather(completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let lat = -75.0
        let lon = 43.0
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"

        // Construct the URL with parameters
        guard var urlComponents = URLComponents(string: baseUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "London"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        // Perform the network request
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }
            
            do {
                // Decode the JSON response into a WeatherResponse object
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
                print(weatherResponse)
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

