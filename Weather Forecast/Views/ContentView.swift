//
//  ContentView.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    @State private var isRefreshing: Bool = false

    
    var body: some View {
        VStack {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                LoadingView()
            case .restricted, .denied:
                PermissionsDeniedView()
            case .authorizedWhenInUse, .authorizedAlways:
                if let location = locationManager.location {
                    if let weather = weather {
                        WeatherView(weather: weather)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                    weather = try await weatherManager.getCurrentWeather(latitude:location.latitude,longitude: location.longitude)
                                    
                                } catch {
                                    print("Error getting weather: \(error)")
                                }
                            }
                    }
                } else {
                    LoadingView()
                }
            case .none:
                Text("Unknown Location Status")
            @unknown default:
                Text("Unknown Location Status")
            }
            
        }
        .background(Color(red: 0.28627450980392155, green: 0.33725490196078434, blue: 0.4470588235294118))
        .preferredColorScheme(.dark)
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    ContentView()
}
