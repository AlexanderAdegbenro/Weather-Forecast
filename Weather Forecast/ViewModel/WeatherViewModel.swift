//
//  WeatherViewModel.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import Foundation
import CoreLocation
import SwiftUI

class WeatherViewModel: NSObject, ObservableObject {
    
    @Published var weather: ResponseBody?
    @Published var isRefreshing = false
    private var weatherManager = WeatherManager()
    private var locationManager = CLLocationManager()
    public var currentLocation: CLLocation?
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
        
        Task {
            do {
                let fetchedWeather = try await weatherManager.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                DispatchQueue.main.async {
                    self.weather = fetchedWeather
                    self.isRefreshing = false
                }
            } catch {
                print("Error fetching weather:", error)
                self.isRefreshing = false
            }
        }
    }
    func fetchForecast() {
        print("Fetching forecast...")
        guard let location = currentLocation else {
            print("Location not available.")
            return
        }

        Task {
            do {
                let fetchedForecast = try await weatherManager.getFiveDayForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                DispatchQueue.main.async { [self] in
                    self.forecast = fetchedForecast.list
                    self.isRefreshing = false
        
                }
            } catch {
                print("Error fetching forecast:", error)
                self.isRefreshing = false
            }
        }
    }

}


