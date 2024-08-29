//
//  WeatherAppView.swift
//  WeatherApp
//
//  Created by Sheeba Tanveer on 2024-04-22.
//

import SwiftUI

struct WeatherAppView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""
    
    // Create a date formatter instance outside of the view body
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // Adjust the format as needed
        return formatter
    }

    var body: some View {
        ZStack {
            WeatherAnimationView(condition: viewModel.condition)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                TextField("Enter city name", text: $city, onCommit: {
                    viewModel.fetchWeather(for: city)
                    viewModel.fetchForecast(for: city)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                Text(viewModel.condition.capitalizedFirstLetterOfEachWord)
                    .font(.headline)
                    .padding(.top, 20)
                
                Spacer()
                
                Text("Today")
                    .font(.caption)
                
                Text(viewModel.temperature)
                    .font(.system(size: 100))
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(viewModel.cityName)
                    .font(.system(size: 60))
                    .fontWeight(.thin)
                
                Spacer()
                
                // Forecast display
                HStack(spacing: 20) {
                    ForEach(viewModel.forecast.prefix(7), id: \.dt) { forecast in
                        VStack {
                            let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                            
                            Text(dateFormatter.string(from: date))
                                .font(.caption)
                            
                            Circle()
                                .fill(Color.black)
                                .frame(width: 5, height: 5)
                            
                            Text("\(Int(forecast.main.temp))°C")
                                .font(.caption)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchWeather(for: "Toronto")
            viewModel.fetchForecast(for: "Toronto")
        }
    }
}

struct WeatherAnimationView: View {
    var condition: String
    
    var body: some View {
        ZStack {
            if condition.lowercased().contains("cloud") {
                Image("Cloudy")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else if condition.lowercased().contains("rain") {
                Image("Rainy")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else if condition.lowercased().contains("clear") {
                Image("Sunny")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else if condition.lowercased().contains("mist") {
                Image("Mist")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
            else if condition.lowercased().contains("smoke") {
                Image("Smoke")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
            else if condition.lowercased().contains("snow") {
                Image("Snowy")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }else {
                Color.gray // Default background color
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    WeatherAppView()
}


