//
//  String+Extension.swift
//  M1MacBookBatteryObserver
//
//  Created by Shingo Fukuyama on 2022/02/24.
//

import Foundation

extension String {
    @discardableResult
    func runAsCommand() -> String {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", self]
        task.standardOutput = pipe
        task.launch()
        let file = pipe.fileHandleForReading
        if let result = String(data: file.readDataToEndOfFile(), encoding: .utf8) {
            print(result)
            return result
        } else {
            return "\(#function) error"
        }
    }
}
