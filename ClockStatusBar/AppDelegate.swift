//
//  AppDelegate.swift
//  ClockStatusBar
//
//  Created by Marcus Chiu on 6/23/20.
//  Copyright © 2020 Marcus Chiu. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    var detailedDateMenuItem: NSMenuItem!

    override func awakeFromNib() {
        super.awakeFromNib()

        statusItem = NSStatusBar.system.statusItem(withLength: 40)
        let statusMenu = NSMenu(title: "Clock Status Bar Menu")
        statusItem.menu = statusMenu
        statusMenu.addItem(
            withTitle: "",
            action: nil,
            keyEquivalent: "")
        statusMenu.addItem(
            withTitle: "Quit",
            action: #selector(AppDelegate.ExitNow(sender:)),
            keyEquivalent: "")
        detailedDateMenuItem = statusMenu.item(at: 0)

        updateDetailedDate()
        updateClock()
        
        scheduledTimerWithTimeInterval()
    }

    func scheduledTimerWithTimeInterval() {
        // Scheduling timer to Call the function "updateClock" with the interval of 1 seconds
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateClock), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(self.updateDetailedDate), userInfo: nil, repeats: true)
    }
    
    @objc func updateDetailedDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        detailedDateMenuItem?.title =  dateFormatter.string(from: date)
    }

    @objc func updateClock() {
        let _date = Date()
        var hour = Calendar.current.component(.hour, from: _date) % 12
        let minute = Calendar.current.component(.minute, from: _date)
        if (hour == 0) {
            hour = 12
        }
        let hourHexString = convertHourToHex(hour: hour)
        let minuteString = String(format: "%02d", minute)
        statusItem?.button?.title = "\(hourHexString):\(minuteString)"
    }
    
    func convertHourToHex(hour: Int) -> String {
        var hourHex = ""
        switch hour {
        case 10:
            hourHex = "A"
        case 11:
            hourHex = "B"
        case 12:
            hourHex = "C"
        default:
            hourHex = String(hour)
        }
        return hourHex
    }
    
    @objc func ExitNow(sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
}
