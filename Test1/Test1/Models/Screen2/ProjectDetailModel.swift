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
    var id: UUID
    var url: String
    var frame: Frame
    var rotation: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case frame
        case rotation
    }
    
    init(id: UUID = UUID(), url: String, frame: Frame, rotation: Double? = nil) {
        self.id = id
        self.url = url
        self.frame = frame
        self.rotation = rotation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        self.frame = try container.decode(Frame.self, forKey: .frame)
        self.rotation = try container.decodeIfPresent(Double.self, forKey: .rotation)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    }
}

struct Frame: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
}
