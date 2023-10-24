//
//  PermissionsDeniedView.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import SwiftUI

struct PermissionsDeniedView: View {
    
    var body: some View {
        VStack(spacing: 20){
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
            
            Text("Location Permission Denied")
                .font(.title)
            
            Text("To use this app, please enable location permissions in Settings")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: openAppSettings) {
                Text("Open Settings")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url,options: [:], completionHandler: nil)
            }
        }
    }
}

#Preview {
    PermissionsDeniedView()
}
