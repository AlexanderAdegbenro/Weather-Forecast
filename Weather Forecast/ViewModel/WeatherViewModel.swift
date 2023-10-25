import Foundation
import CoreLocation
import SwiftUI

class WeatherViewModel: NSObject, ObservableObject {
    
    @Published var weather: ResponseBody?
    @Published var isRefreshing = false
    private var weatherManager = WeatherManager()
    private var locationManager = CLLocationManager()
    public var currentLocation: CLLocation?
    @Published var forecastData: Welcome?
    @Published var forecast: [ResponseBody.ForecastResponse]?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func fetchWeather() {
        guard let location = currentLocation else {
            print("Location not available.")
            return
        }
        
        isRefreshing = true
        Task {
            do {
                let fetchedWeather = try await weatherManager.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                DispatchQueue.main.async {
                    self.weather = fetchedWeather
                    self.isRefreshing = false
                }
            } catch {
                print("Error fetching weather:", error)
                DispatchQueue.main.async {
                    self.isRefreshing = false
                }
            }
        }
    }

    func fetchForecast() {
        guard let location = currentLocation else {
            print("Location not available.")
            return
        }
        
        isRefreshing = true
        Task {
            do {
                let fetchedForecast = try await weatherManager.getFiveDayForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                DispatchQueue.main.async {
                    self.forecastData = fetchedForecast
                    self.isRefreshing = false
                }
            } catch {
                print("Error fetching forecast:", error)
                DispatchQueue.main.async {
                    self.isRefreshing = false
                }
            }
        }
    }
}
