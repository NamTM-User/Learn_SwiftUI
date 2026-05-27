//
//  ProjectDetailModel.swift
//  Test1
//
//  Created by Hai Nam on 14/5/26.
//

import Foundation

struct ProjectDetail: Codable {
    let name: String
    let id: Int
    var photos: [Photo]
}

struct Photo: Codable, Identifiable {
    var id: UUID = UUID()
    var url: String
    var frame: Frame
    var rotation: Double?
    var opacity: Double? = 1.0
}

struct Frame: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
}
