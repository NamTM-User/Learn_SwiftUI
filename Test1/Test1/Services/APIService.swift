//
//  APIService.swift
//  Test1
//
//  Created by Hai Nam on 11/5/26.
//

import Foundation

struct APIService {
    
    // 1. GET API
    func getAPI() async throws -> ProjectLists {
        guard let url = URL(string: "https://tapuniverse.com/xproject") else {
            // URLError là một kiểu lỗi có sẵn của Apple dành cho networking , .badURL là URL sai
            throw URLError(.badURL)
        }
        // get
        let (data , _) = try await URLSession.shared.data(from: url)
        
        // parse JSON
        let res = try JSONDecoder().decode(ProjectLists.self, from: data)
        return res
    }
    
    // 2. POST
    
    
}

