import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var headerContent: some View {
        VStack {
            Text(viewModel.weatherName)
                .font(.largeTitle)
                .fontWeight(.regular)
                .foregroundColor(.white)
            Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }

    var mainWeatherContent: some View {
        VStack {
            WeatherIconView(iconCode: viewModel.weatherIconCode)
                .font(.system(size: 70))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                .padding()
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.weatherMain)
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(String(format: "%.1f°", viewModel.feelsLikeTemperature))
                        .font(.system(size: 70))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width * 0.7)
                .frame(height: UIScreen.main.bounds.width * 0.3)
            }
            .padding(.horizontal)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
        }
    }
    
    func fiveDayForecastContent() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5-DAY FORECAST")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.bottom, 10)

            switch viewModel.loadingState {
            case .fetchedWeatherAndForecast(_, let forecastData):
                let groupedForecasts = Dictionary(grouping: forecastData.list, by: { Date(timeIntervalSince1970: TimeInterval($0.dt)).formatted(.dateTime.day()) })

                let currentDate = Calendar.current.startOfDay(for: Date())
                let filteredKeys = groupedForecasts.keys.filter { dateKey in
                    return DateFormatter.localizedString(from: currentDate, dateStyle: .short, timeStyle: .none) != dateKey
                }.sorted()
                
                ForEach(filteredKeys.prefix(5), id: \.self) { day in
                    if let dailyForecasts = groupedForecasts[day], let firstForecast = dailyForecasts.first {
                        let averageTemp = dailyForecasts.reduce(0, { $0 + $1.main.temp }) / Double(dailyForecasts.count)
                        
                        HStack {
                            Text(Date(timeIntervalSince1970: TimeInterval(firstForecast.dt)).formatted(.dateTime.month().day()))
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            WeatherIconView(iconCode: firstForecast.weather[0].icon)
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            
                            Text("\(averageTemp.roundedString)°")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                }
            default:
                Text("Loading forecast...")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
    }


    
    
    var body: some View {
        ZStack {
            switch viewModel.loadingState {
            case .idle, .fetchingLocation, .fetchingWeather, .fetchingForecast:
                ProgressView()
                    .scaleEffect(1.5)
                    .animation(.easeInOut(duration: 0.5), value: viewModel.loadingState)

            case .fetchedLocation(let location):
                Text("Fetched Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            case .fetchedWeatherAndForecast:
                VStack(spacing: 10) {
                    headerContent
                    mainWeatherContent
                    ScrollView {
                        LazyVStack {
                            fiveDayForecastContent()
                        }
                        .padding(.top, 80)
                    }
                }
                .padding(.horizontal)
            case .error(let message):
                Text(message)
                    .foregroundColor(.red)
            }
        }
    }



}


struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel())
    }
}

