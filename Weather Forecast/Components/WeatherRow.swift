//
//  WeatherRow.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import SwiftUI

struct WeatherRow: View {
    var logo: String
    var name: String
    var value: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: logo)
                .font(.title2)
                .frame(width: 25, height: 25)
                .padding(10)
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                .cornerRadius(50)

            
            HStack() {
                Text(name)
                    .font(.caption)
                
                Text(value)
                    .bold()
                    .font(.title2)
            }
        }
    }
}


#Preview {
    WeatherRow(logo: "thermometer", name: "Feels like", value: "8°")
}
