//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Sheeba Tanveer on 2024-05-14.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = ""
    @Published var condition: String = ""
    @Published var cityName: String = ""
    @Published var forecast: [ForecastResponse.Forecast] = []

    private var cancellables = Set<AnyCancellable>()
    private let apiKey = "dafb3a05a3314807e94ab4c64a3a1409"

    func fetchWeather(for city: String) {
        fetchCoordinates(for: city)
            .flatMap { (latitude, longitude) in
                self.fetchWeatherData(latitude: latitude, longitude: longitude)
            }
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching weather: \(error)")
                }
            }, receiveValue: { weatherData in
                self.temperature = "\(weatherData.main.temp)°C"
                self.condition = weatherData.weather.first?.description ?? "N/A"
                self.cityName = weatherData.name
            })
            .store(in: &cancellables)
    }
    
    func fetchForecast(for city: String) {
        fetchCoordinates(for: city)
            .flatMap { (latitude, longitude) in
                self.fetchForecastData(latitude: latitude, longitude: longitude)
            }
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching forecast: \(error)")
                }
            }, receiveValue: { forecastResponse in
                self.forecast = forecastResponse.list
            })
            .store(in: &cancellables)
    }

    private func fetchCoordinates(for city: String) -> AnyPublisher<(Double, Double), Error> {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [GeocodingData].self, decoder: JSONDecoder())
            .tryMap { geocodingData in
                guard let location = geocodingData.first else {
                    throw URLError(.badServerResponse)
                }
                return (location.lat, location.lon)
            }
            .eraseToAnyPublisher()
    }

    private func fetchWeatherData(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func fetchForecastData(latitude: Double, longitude: Double) -> AnyPublisher<ForecastResponse, Error> {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ForecastResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension WeatherResponse {
    struct Forecast: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
    }
}

extension String {
    var capitalizedFirstLetterOfEachWord: String {
        return self.split(separator: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}
