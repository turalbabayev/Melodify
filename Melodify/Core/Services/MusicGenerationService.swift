import Foundation

enum MusicGenerationError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case unauthorized
    case timeoutError
    case customError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized: Please check your API key"
        case .timeoutError:
            return "Request timed out after maximum attempts"
        case .customError(let message):
            return message
        }
    }
}

class MusicGenerationService {
    static let shared = MusicGenerationService()
    private let baseURL = APIConfig.baseURL
    private let callbackURL = APIConfig.callbackURL
    private let apiKey = APIConfig.apiKey
    
    private init() {}
    
    func generateMusic(
        prompt: String,
        style: String? = nil,
        title: String? = nil,
        customMode: Bool,
        instrumental: Bool
    ) async throws -> String {
        print("\n📡 Making API Call to: \(baseURL)/generate")
        
        guard let url = URL(string: "\(baseURL)/generate") else {
            print("❌ Invalid URL")
            throw MusicGenerationError.invalidURL
        }
        
        let request = MusicGenerationRequest(
            prompt: prompt,
            style: style,
            title: title,
            customMode: customMode,
            instrumental: instrumental,
            model: .V3_5,
            callBackUrl: callbackURL
        )
        
        print("\n📤 Request Payload:")
        print(String(data: try JSONEncoder().encode(request), encoding: .utf8) ?? "")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        print("\n🔑 Request Headers:")
        print("Content-Type: application/json")
        print("Authorization: Bearer \(apiKey)")
        
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        print("\n⏳ Waiting for API Response...")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid Response Type")
            throw MusicGenerationError.invalidResponse
        }
        
        print("\n📥 Response Status Code: \(httpResponse.statusCode)")
        print("📥 Response Data:")
        print(String(data: data, encoding: .utf8) ?? "")
        
        guard httpResponse.statusCode == 200 else {
            print("❌ API Error: Status code \(httpResponse.statusCode)")
            print("❌ Response Headers:")
            for (key, value) in httpResponse.allHeaderFields {
                print("\(key): \(value)")
            }
            
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("❌ Error Details:", errorJson)
            }
            
            if httpResponse.statusCode == 401 {
                print("❌ Unauthorized: Please check your API key")
                throw MusicGenerationError.unauthorized
            }
            
            throw MusicGenerationError.invalidResponse
        }
        
        let taskResponse = try JSONDecoder().decode(MusicGenerationResponse.self, from: data)
        print("\n✅ Successfully decoded response")
        print("📋 Task ID: \(taskResponse.data.taskId)")
        
        return taskResponse.data.taskId
    }

    func checkTaskStatus(taskId: String) async throws -> TaskData {
        print("\n📡 Checking task status for ID: \(taskId)")
        
        guard let url = URL(string: "\(baseURL)/generate/record-info?taskId=\(taskId)") else {
            print("❌ Invalid URL")
            throw MusicGenerationError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        print("\n🔑 Request Headers:")
        print("Authorization: Bearer \(apiKey)")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid Response Type")
            throw MusicGenerationError.invalidResponse
        }
        
        print("\n📥 Response Status Code: \(httpResponse.statusCode)")
        print("📥 Response Data:")
        print(String(data: data, encoding: .utf8) ?? "")
        
        if httpResponse.statusCode == 401 {
            throw MusicGenerationError.unauthorized
        }
        
        let taskResponse = try JSONDecoder().decode(TaskStatusResponse.self, from: data)
        return taskResponse.data
    }
} 