enum StatusCode: String, Codable {
    case ok = "OK"
    case error = "ERROR"
    
    init(from decoder: Decoder) throws {
        self = Self(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
}
