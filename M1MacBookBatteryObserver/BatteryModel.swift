//
//  BatteryModel.swift
//  M1MacBookBatteryObserver
//
//  Created by Shingo Fukuyama on 2022/02/26.
//

import SwiftUI
import Combine

enum BatteryError: String, Error {
    case couldNotRead = "Invalid battery level extracted"
}

class BatteryModel: ObservableObject {
    
    @AppStorage("batteryCheckTimerInterval") var batteryCheckTimerInterval: TimeInterval = 10
    
    @AppStorage("batteryLevelLessThan") var batteryLevelLessThan: Double = 40
    
    @AppStorage("batteryLevelGreaterThan") var batteryLevelGreaterThan: Double = 80
    
    @AppStorage("batteryLevelLessThanAction") var batteryLevelLessThanAction: String = ""
    
    @AppStorage("batteryLevelGreaterThanAction") var batteryLevelGreaterThanAction: String = ""
    
    @Published var batteryLevel: String = "---"
    
    private var subscription: AnyCancellable?
    
    private var lastBatteryLevel: Int?
    
    init() {
        updateBatteryLevel()
        updateInterval()
    }
    
    func updateInterval() {
        subscription?.cancel()
        subscription = Timer.publish(every: batteryCheckTimerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                print("--------------------------")
                self?.updateBatteryLevel()
            }
    }
    
    func updateBatteryLevel() {
        do {
            let level = try currentBatteryLevel
            defer { lastBatteryLevel = level }
            batteryLevel = "\(level)%"
            guard let lastBatteryLevel = lastBatteryLevel else {
                return
            }
            if level < Int(batteryLevelLessThan),
               lastBatteryLevel >= Int(batteryLevelLessThan),
               !batteryLevelLessThanAction.isEmpty {
                batteryLevelLessThanAction.runAsCommand()
            } else if level > Int(batteryLevelGreaterThan),
                      lastBatteryLevel <= Int(batteryLevelGreaterThan),
                      !batteryLevelGreaterThanAction.isEmpty {
                batteryLevelGreaterThanAction.runAsCommand()
            }
        } catch {
            batteryLevel = "---"
            print(error)
        }
    }
    
    var currentBatteryLevel: Int {
        get throws {
            let command = #"pmset -g batt | perl -ne 'print "$1" if /([0-9]+)\%/'"#
            guard let level = Int(command.runAsCommand()) else {
                throw BatteryError.couldNotRead
            }
            return level
        }
    }
    
    var isCharging: Bool {
        !#"pmset -g batt | grep '\bcharging\b'"#.runAsCommand().isEmpty
    }
}
