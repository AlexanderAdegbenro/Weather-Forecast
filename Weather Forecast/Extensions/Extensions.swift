//  Extensions.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import Foundation
import CoreLocation
import SwiftUI

// MARK: - Double Extensions
extension Double {
    /// Rounds the double and returns it as a string with 0 decimal places.
    var roundedString: String {
        return String(format: "%.0f", self)
    }
}

// MARK: - SwiftUI View Extensions
extension View {
    /// Adds rounded corners to specific corners of a SwiftUI View.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - WeatherViewModel Extensions for CLLocationManagerDelegate
extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            Task {
                await fetchWeatherAndForecast(for: location)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        loadingState = .error("Error fetching location: \(error.localizedDescription)")
    }
}


// MARK: - WeatherViewModel Data Extraction Extensions
extension WeatherViewModel {
    var weatherName: String {
        if case .fetchedWeatherAndForecast(let weatherData, _) = loadingState {
            return weatherData.name
        }
        return "Loading.."
    }

    var weatherIconCode: String {
        if case .fetchedWeatherAndForecast(let weatherData, _) = loadingState,
           let icon = weatherData.weather.first?.icon {
            return icon
        }
        return ""
    }

    var weatherMain: String {
        if case .fetchedWeatherAndForecast(let weatherData, _) = loadingState,
           let main = weatherData.weather.first?.main {
            return main
        }
        return "Loading.."
    }

    var feelsLikeTemperature: Double {
        if case .fetchedWeatherAndForecast(let weatherData, _) = loadingState {
            return weatherData.main.feelsLike
        }
        return 0.0
    }
}

// MARK: - DispatchQueue Extensions
extension DispatchQueue {
    /// Ensures the provided work is executed on the main thread.
    static func updateUI(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async {
                work()
            }
        }
    }
}
