import Foundation

struct Frame: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
}

struct Photo: Codable {
    var id: UUID?
    var url: String
    var frame: Frame
    var rotation: Double?
}

struct ProjectDetail: Codable {
    var name: String
    var id: Int
    var photos: [Photo]
}

func testAPI() async {
    let url = URL(string: "https://tapuniverse.com/xprojectdetail")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = ["id": 21]
    request.httpBody = try! JSONEncoder().encode(body)
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonStr = String(data: data, encoding: .utf8)
        print(jsonStr ?? "")
    } catch {
        print("Error: \(error)")
    }
}

Task {
    await testAPI()
    exit(0)
}
RunLoop.main.run()
