//
//  Hike.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 4/5/26.
//

import Foundation

struct Hike: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var distance: Double
    var difficulty: Int
    
    var observations: [Observation]
    
    static var formatter = LengthFormatter() // class của Apple để format khoảng cách
    var distanceText: String {
        Hike.formatter.string(fromValue: distance, unit: .kilometer)
    }
    
    
    struct Observation: Codable, Hashable {
        var distanceFromStart: Double
        
        var elevation: Range<Double>
        var pace: Range<Double>
        var heartRate: Range<Double>
    }
}
