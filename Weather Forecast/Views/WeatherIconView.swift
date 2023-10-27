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
            "01d": "☀️",
            "01n": "🌙",
            "02d": "⛅",
            "02n": "🌥️",
            "03d": "🌥️",
            "03n": "🌥️",
            "04d": "☁️",
            "04n": "☁️",
            "09d": "🌧️",
            "09n": "🌧️",
            "10d": "🌦️",
            "10n": "🌦️",
            "11d": "⛈️",
            "11n": "⛈️",
            "13d": "❄️",
            "13n": "❄️",
            "50d": "🌫️",
            "50n": "🌫️", 
        ]
        
        return iconMapping[code] ?? "❓"
    }
}

struct WeatherIconView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherIconView(iconCode: "01d")
    }
}
