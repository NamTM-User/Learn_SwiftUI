//
//  ModelData.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 28/4/26.
//


import Foundation
// Decodable:  chỉ đọc JSON → Swift
// Encodable = chỉ ghi Swift → JSON
// Codable = cả hai luôn

var landmarks: [Landmark] = load("landmarkData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do{
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
           let decoder = JSONDecoder() // JSONDecoder(): Chuyển JSON -> Object Swift (struct/class)
           return try decoder.decode(T.self, from: data)
       } catch {
           fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
       }
}
