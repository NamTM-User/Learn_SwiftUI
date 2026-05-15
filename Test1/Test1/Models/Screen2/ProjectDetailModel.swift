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
    let photos: [Photo]
}

struct Photo: Codable {
    let url: String
    let frame: Frame
}

struct Frame: Codable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}
