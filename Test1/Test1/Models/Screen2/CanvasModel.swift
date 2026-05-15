//
//  Canvas.swift
//  Test1
//
//  Created by Hai Nam on 14/5/26.
//

import Foundation

@Observable
class CanvasModel {
    // state project list
    var projectDetail: ProjectDetail?
    
    // api
    private let apiService = APIService()
    
    // 1. fetch
    func fetchData(_ id: Int) async throws {
        
        do {
            let data = try await apiService.postAPI(projectId: id)
            self.projectDetail = data
        } catch {
            throw error
        }
    }
    
    // ===================================== logic feature =======================================
    
    // 2. add photo
    func addPhoto() {
        
    }
    
    // 3. delete photo
    
    func deletePhoto() {
        
    }
    
    // 4. Save & back
    func saveChanges() {
        
    }
    
    
    // ==================================== logic gestures =======================================
    
    // 5. move photo
    func movePhoto() {
        
    }
    
    // 6. turn photo
    func turnPhoto() {
        
    }
    
    // 7. zoom
    func zoom() {
        
    }
    
    
}
