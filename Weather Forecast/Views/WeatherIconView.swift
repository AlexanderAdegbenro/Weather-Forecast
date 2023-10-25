//
//  WeatherIconView.swift
//  Weather Forecast
//
//  Created by Consultant on 10/25/23.
//

import SwiftUI

struct WeatherIconView: View {
    var iconCode: String
    
    var body: some View {
        Text(weatherIcon(for: iconCode))
            .font(.system(size: 50))
    }
    
    private func weatherIcon(for code: String) -> String {
        let iconMapping: [String: String] = [
            "01d": "☀️", // Clear day
            "01n": "🌙", // Clear night
            "02d": "⛅", // Few clouds day
            "02n": "🌥️", // Few clouds night
            "03d": "🌥️", // Scattered clouds day
            "03n": "🌥️", // Scattered clouds night
            "04d": "☁️", // Broken clouds day
            "04n": "☁️", // Broken clouds night
            "09d": "🌧️", // Shower rain day
            "09n": "🌧️", // Shower rain night
            "10d": "🌦️", // Rain day
            "10n": "🌦️", // Rain night
            "11d": "⛈️", // Thunderstorm day
            "11n": "⛈️", // Thunderstorm night
            "13d": "❄️", // Snow day
            "13n": "❄️", // Snow night
            "50d": "🌫️", // Mist day
            "50n": "🌫️", // Mist night
        ]
        
        return iconMapping[code] ?? "❓"
    }
}

struct WeatherIconView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherIconView(iconCode: "01d")
    }
}
