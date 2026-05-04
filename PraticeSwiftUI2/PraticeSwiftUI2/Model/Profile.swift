//
//  Profile.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 4/5/26.
//

import Foundation


struct Profile {
    var username: String
    var prefersNotifications = true
    var goalDate = Date()
    var seasonalPhoto = Season.winter
    
    static let `default` = Profile(username: "g_kumar")
    
    enum Season: String, CaseIterable, Identifiable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
        
        var id: String {
            rawValue
        }
    }
}
