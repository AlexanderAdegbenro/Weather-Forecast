//
//  ContentView.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//
import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    
    @StateObject var viewModel = WeatherViewModel()
    
    // MARK: - Computed Properties
    
    struct WeatherContentView: View {
        @ObservedObject var viewModel: WeatherViewModel

        var body: some View {
            content
                .task {
                    if case .fetchedLocation(let location) = viewModel.loadingState {
                        await viewModel.fetchWeatherAndForecast(for: location)
                    }
                }
        }

        var content: some View {
            switch viewModel.loadingState {
            case .idle, .fetchingLocation, .fetchingWeather, .fetchingForecast, .fetchedLocation:
                return AnyView(LoadingView())
                
            case .fetchedWeatherAndForecast:
                return AnyView(WeatherView(viewModel: viewModel))
                
            case .error(let message):
                return AnyView(Text(message))
            }
        }
    }

    
    var backgroundColor: Color {
        return Color(red: 0.286, green: 0.337, blue: 0.447)
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    WeatherContentView(viewModel: viewModel)
                }
                .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
            }
            .background(backgroundColor)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - ContentView Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

