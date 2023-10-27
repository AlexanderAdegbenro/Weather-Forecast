import Foundation
import CoreLocation
import SwiftUI

enum WeatherLoadingState {
    case idle
    case fetchingLocation
    case fetchedLocation
    case error(Error)
}

class WeatherViewModel: NSObject, ObservableObject {
    
    @Published var weather: ResponseBody?
    @Published var isRefreshing = false
    @Published var forecastData: Welcome?
    @Published var errorMessage: String? = nil
    @Published var loadingState: WeatherLoadingState = .idle
    
    private var weatherManager = WeatherManager()
    private var locationManager = CLLocationManager()
    public var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        loadingState = .fetchingLocation
    }
    
    private func checkRefreshingStatus() {
        if weather == nil || forecastData == nil {
            isRefreshing = true
        } else {
            isRefreshing = false
        }
    }
    
    
    func requestLocation() {
        isRefreshing = true
        locationManager.requestLocation()
    }
    
    func fetchWeather() {
        guard let location = currentLocation else {
            print("Location not available.")
            return
        }
        
        Task {
            do {
                let fetchedWeather = try await weatherManager.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                DispatchQueue.main.async {
                    self.weather = fetchedWeather
                    self.checkRefreshingStatus()
                }
            } catch {
                print("Error fetching weather:", error)
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching weather: \(error.localizedDescription)"
                    self.checkRefreshingStatus()
                }
            }
        }
    }
    
    func fetchForecast() {
        guard let location = currentLocation else {
            print("Location not available.")
            return
        }
        
        Task {
            do {
                let fetchedForecast = try await weatherManager.getFiveDayForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                DispatchQueue.main.async {
                    self.forecastData = fetchedForecast
                    self.checkRefreshingStatus()
                }
            } catch {
                print("Error fetching forecast:", error)
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching forecast: \(error.localizedDescription)"
                    self.checkRefreshingStatus()
                }
            }
        }
    }
}

