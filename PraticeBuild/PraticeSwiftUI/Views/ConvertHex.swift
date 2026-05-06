//
//  ConvertHex.swift
//  PraticeSwiftUI
//
//  Created by Hai Nam on 5/5/26.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let cleanedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let scanner = Scanner(string: cleanedHex)
        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)
        
        let r, g, b, a: Double
        
        switch cleanedHex.count {
        case 6: // RGB (24-bit)
            r = Double((hexValue & 0xFF0000) >> 16) / 255.0
            g = Double((hexValue & 0x00FF00) >> 8) / 255.0
            b = Double((hexValue & 0x0000FF)) / 255.0
            a = 1.0
        case 8: // RGBA (32-bit)
            r = Double((hexValue & 0xFF000000) >> 24) / 255.0
            g = Double((hexValue & 0x00FF0000) >> 16) / 255.0
            b = Double((hexValue & 0x0000FF00) >> 8) / 255.0
            a = Double((hexValue & 0x000000FF)) / 255.0
        default:
            (r, g, b, a) = (0, 0, 0, 1)
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
