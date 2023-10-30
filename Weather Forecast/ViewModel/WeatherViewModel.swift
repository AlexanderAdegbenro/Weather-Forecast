import Foundation
import CoreLocation
import SwiftUI

// MARK: - WeatherLoadingState
enum WeatherLoadingState: Equatable {
    case idle
    case fetchingLocation
    case fetchedLocation(CLLocation)
    case fetchingWeather
    case fetchingForecast
    case fetchedWeatherAndForecast(ResponseBody, Welcome)
    case error(String)
    
    static func == (lhs: WeatherLoadingState, rhs: WeatherLoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.fetchingLocation, .fetchingLocation),
             (.fetchingWeather, .fetchingWeather),
             (.fetchingForecast, .fetchingForecast):
            return true
        case let (.fetchedLocation(lhsLocation), .fetchedLocation(rhsLocation)):
            return lhsLocation == rhsLocation
        case let (.fetchedWeatherAndForecast(lhsWeather, lhsForecast), .fetchedWeatherAndForecast(rhsWeather, rhsForecast)):
            return lhsWeather == rhsWeather && lhsForecast == rhsForecast
        case let (.error(lhsError), .error(rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

// MARK: - WeatherViewModel
@MainActor
class WeatherViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    @Published var loadingState: WeatherLoadingState = .idle
    private var weatherManager = WeatherManager()
    var fetchedLocation: CLLocation?
    private var locationManager = CLLocationManager()
    
    // MARK: - Initializer
    override init() {
        super.init()
        configureLocationManager()
    }
    
    // MARK: - Configuration
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        requestLocation()
    }
    
    // MARK: - Actions
    func requestLocation() {
        loadingState = .fetchingLocation
        locationManager.requestLocation()
    }
    
    func fetchWeatherAndForecast(for location: CLLocation) async {
        fetchedLocation = location
        loadingState = .fetchingWeather

        do {
            let fetchedWeather = try await weatherManager.getCurrentWeather(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )

            let fetchedForecast = try await weatherManager.getFiveDayForecast(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )

            loadingState = .fetchedWeatherAndForecast(fetchedWeather, fetchedForecast)
        } catch {
            loadingState = .error("Error fetching weather data: \(error.localizedDescription)")
        }
    }
}

