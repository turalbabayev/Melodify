import Foundation

// Request Model
struct MusicGenerationRequest: Codable {
    let prompt: String
    let style: String?
    let title: String?
    let customMode: Bool
    let instrumental: Bool
    let model: ModelVersion
    let callBackUrl: String
    
    enum ModelVersion: String, Codable {
        case V3_5
        case V4
    }
}

// API Response Models
struct MusicGenerationResponse: Codable {
    let code: Int
    let msg: String
    let data: InitialTaskResponse
}

struct InitialTaskResponse: Codable {
    let taskId: String
}

struct TaskStatusResponse: Codable {
    let code: Int
    let msg: String
    let data: TaskData
}

struct TaskData: Codable {
    let taskId: String
    let parentMusicId: String
    let param: String
    let response: TaskDetailResponse?
    let status: TaskStatus
    let type: String
    let errorCode: Int?
    let errorMessage: String?
    let createTime: String?
    
    enum CodingKeys: String, CodingKey {
        case taskId
        case parentMusicId
        case param
        case response
        case status
        case type
        case errorCode
        case errorMessage
        case createTime
    }
}

struct TaskDetailResponse: Codable {
    let taskId: String
    let sunoData: [GeneratedMusic]
}

struct GeneratedMusic: Codable, Identifiable {
    let id: String
    var title: String
    let audioUrl: String
    let sourceAudioUrl: String?
    let streamAudioUrl: String
    let sourceStreamAudioUrl: String
    let imageUrl: String
    let sourceImageUrl: String
    let prompt: String
    let modelName: String
    let tags: String
    let createTime: Double
    let duration: Double?
    var status: TaskStatus
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case audioUrl
        case sourceAudioUrl
        case streamAudioUrl
        case sourceStreamAudioUrl
        case imageUrl
        case sourceImageUrl
        case prompt
        case modelName
        case tags
        case createTime
        case duration
        case status
    }
    
    // API'den gelen yanıt için decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        audioUrl = try container.decode(String.self, forKey: .audioUrl)
        sourceAudioUrl = try container.decodeIfPresent(String.self, forKey: .sourceAudioUrl)
        streamAudioUrl = try container.decode(String.self, forKey: .streamAudioUrl)
        sourceStreamAudioUrl = try container.decode(String.self, forKey: .sourceStreamAudioUrl)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        sourceImageUrl = try container.decode(String.self, forKey: .sourceImageUrl)
        prompt = try container.decode(String.self, forKey: .prompt)
        modelName = try container.decode(String.self, forKey: .modelName)
        tags = try container.decode(String.self, forKey: .tags)
        createTime = try container.decode(Double.self, forKey: .createTime)
        duration = try container.decodeIfPresent(Double.self, forKey: .duration)
        status = .SUCCESS // API'den gelen müzikler her zaman SUCCESS durumunda
    }
    
    // Generating durumundaki şarkılar için manuel init
    init(id: String, title: String, prompt: String, status: TaskStatus) {
        self.id = id
        self.title = title
        self.audioUrl = ""
        self.sourceAudioUrl = nil
        self.streamAudioUrl = ""
        self.sourceStreamAudioUrl = ""
        self.imageUrl = ""
        self.sourceImageUrl = ""
        self.prompt = prompt
        self.modelName = ""
        self.tags = ""
        self.createTime = Date().timeIntervalSince1970
        self.duration = nil
        self.status = status
    }
}

enum TaskStatus: String, Codable {
    case PENDING
    case TEXT_SUCCESS
    case FIRST_SUCCESS
    case SUCCESS
    case CREATE_TASK_FAILED
    case GENERATE_AUDIO_FAILED
    case CALLBACK_EXCEPTION
    case SENSITIVE_WORD_ERROR
}

struct CallbackData: Codable {
    let callbackType: String
    let taskId: String
    let data: [GeneratedMusic]
    
    enum CodingKeys: String, CodingKey {
        case callbackType = "callbackType"
        case taskId = "task_id"
        case data
    }
}

enum GenerationStep: String {
    case pending = "Waiting to start..."
    case textProcessing = "Processing text..."
    case firstVersion = "Creating first version..."
    case finalizing = "Finalizing..."
    case completed = "Completed"
    case failed = "Failed"
}

extension TaskStatus {
    var generationStep: GenerationStep {
        switch self {
        case .PENDING: return .pending
        case .TEXT_SUCCESS: return .textProcessing
        case .FIRST_SUCCESS: return .firstVersion
        case .SUCCESS: return .completed
        case .CREATE_TASK_FAILED, .GENERATE_AUDIO_FAILED,
             .CALLBACK_EXCEPTION, .SENSITIVE_WORD_ERROR:
            return .failed
        }
    }
} 
