//
//  ContentView.swift
//  M1MacBookBatteryObserver
//
//  Created by Shingo Fukuyama on 2022/02/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var batteryModel = BatteryModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Status
            HStack(alignment: .firstTextBaseline) {
                Text("Current Battery:")
                    .font(.largeTitle)
                Text(batteryModel.batteryLevel)
                    .font(.largeTitle)
                    .foregroundColor(.green)
                Text(batteryModel.isCharging
                     ? "Charging" : "Not charging")
                Spacer()
            }
            
            // Interval
            Slider(value: $batteryModel.batteryCheckTimerInterval, in: 10...60*30, step: 10) {
                HStack {
                    Text("Interval")
                    Text("\(Int(batteryModel.batteryCheckTimerInterval))s")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.green)
                        .frame(minWidth: 50)
                }
            } onEditingChanged: { isChanged in
                if !isChanged {
                    batteryModel.updateInterval()
                }
            }
            
            // Less than action
            VStack {
                Slider(value: $batteryModel.batteryLevelLessThan,
                       in: 10...90,
                       step: 1) {
                    HStack {
                        Text("if battery ")
                        Text("< \(Int(batteryModel.batteryLevelLessThan))%")
                            .foregroundColor(Color.green)
                    }
                }
                TextEditor(text: $batteryModel.batteryLevelLessThanAction)
                    .frame(height: 50)
            }
            
            // Greater than action
            VStack {
                Slider(value: $batteryModel.batteryLevelGreaterThan,
                       in: 10...90,
                       step: 1) {
                    HStack {
                        Text("if battery ")
                        Text("> \(Int(batteryModel.batteryLevelGreaterThan))%")
                            .foregroundColor(Color.green)
                    }
                }
                TextEditor(text: $batteryModel.batteryLevelGreaterThanAction)
                    .frame(height: 50)
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
            .frame(
                minWidth: 500,
                idealWidth: 600,
                maxWidth: 700,
                minHeight: 300,
                idealHeight: 400,
                maxHeight: 500,
                alignment: .center)
    }
}
