//
//  M1MacBookBatteryObserverApp.swift
//  M1MacBookBatteryObserver
//
//  Created by Shingo Fukuyama on 2022/02/24.
//

import SwiftUI

@main
struct M1MacBookBatteryObserverApp: App {
    var body: some Scene {
        WindowGroup {
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
}
