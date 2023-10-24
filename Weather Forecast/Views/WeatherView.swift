import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.weather?.name ?? "Unknown")
                        .bold().font(.title)
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                VStack {
                    HStack {
                        VStack(spacing:20) {
                            Image(systemName: "sun.max")
                                .font(.system(size: 40))
                            
                            Text(viewModel.weather?.weather[0].main ?? "Unknown")
                        }
                        .frame(width:150, alignment: .leading)
                        
                        Spacer()
                        
                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                    }
                    Spacer()
                        .frame(height: 10)
                    AsyncImage(url: URL(string: "https://thumbs.dreamstime.com/b/vector-park-sunny-day-illustration-flowers-swans-104691947.jpg")) {
                        image in image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300,height: 200)
                        
                    } placeholder: {
                        ProgressView()
                    }
                    Spacer()
                }
                .frame(maxWidth:.infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Spacer()
                
                VStack(alignment:.leading, spacing: 30) {
                    Text("5-DAY FORECAST")
                        .bold()
                    
                    VStack(spacing: 5) {
                        let nonOptionalForecast = viewModel.forecast ?? []

                        let groupedForecasts = Dictionary(grouping: nonOptionalForecast, by: { Date(timeIntervalSince1970: TimeInterval($0.dt)).formatted(.dateTime.day()) })

                        let sortedKeys = Array(groupedForecasts.keys.sorted().prefix(5))

                        ForEach(sortedKeys, id: \.self) { day in
                 
                            if let dailyForecasts = groupedForecasts[day] {
                    
                                let averageTemp = dailyForecasts.reduce(0, { $0 + $1.main.temp }) / Double(dailyForecasts.count)

                                WeatherRow(logo: "thermometer", name: day, value: "\(averageTemp.roundDouble())°")
                            }
                            Spacer()
                        }
                    }
                    .frame(maxHeight: 250)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(red: 0.28627450980392155, green: 0.33725490196078434, blue: 0.4470588235294118))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft,.topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(red: 0.28627450980392155, green: 0.33725490196078434, blue: 0.4470588235294118))
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.fetchWeather()
            viewModel.fetchForecast()
        }

    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
