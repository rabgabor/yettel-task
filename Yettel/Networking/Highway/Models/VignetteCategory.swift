enum VignetteCategory: String, Codable, CaseIterable {
    case d1 = "D1"
    case d1m = "D1M"
    case d2 = "D2"

    init(from decoder: Decoder) throws {
        self = Self(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
}
