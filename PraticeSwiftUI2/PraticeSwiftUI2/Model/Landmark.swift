//
//  Landmark.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 28/4/26.
//


import Foundation
import SwiftUI
import CoreLocation

// 1.Codable: biến dữ liệu Swift -> JSON , JSON -> Swift , dùng để đọc/ghi dữ liệu
// 2.Hashable: Kiểu dữ liệu này có thể được chuyển thành một giá trị số duy nhất (hash value) để so sánh nhanh , để dùng được Set , Dictionary cho object

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite: Bool


    private var imageName: String
    
    var image: Image {
        Image(imageName)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
    private var coordinates: Coordinates
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }


    
}
