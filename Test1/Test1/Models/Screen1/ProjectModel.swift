//
//  ProjectStore.swift
//  Test1
//
//  Created by Hai Nam on 12/5/26.
//

import Foundation
import SwiftUI
import Combine


@Observable 
class ProjectModel {
    // state project list
    var projects: [Project] = []
    
    // api
     private let apiService: APIService = APIService()
    
    //1. fetch project
    func fetchProjects() async throws  {
        
        guard projects.isEmpty else {
            return
        }
        
        do {
            let resAPI =  try await apiService.getAPI()
            self.projects = resAPI.projects
        } catch {
            throw error
        }
    }
    
    //2. add project
    func addProject(name: String){
        let name1 = name.trimmingCharacters(in: .whitespaces)
        
        guard !name1.isEmpty else {
            return
        }
        
        let newId = (
        projects.map { $0.id }.max()
        ?? 0) + 1
        
        let newProject = Project(id: newId, name: name1)
        
        projects.append(newProject)
    }
    
    //3. delete project
    func deleteProject(project: Project) {
            projects.removeAll {
                $0.id == project.id
            }
    }
    
    
}
