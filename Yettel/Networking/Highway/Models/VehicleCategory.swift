enum VehicleCategory: String, Codable, CaseIterable {
    case car = "CAR"
    case motorcycle = "MOTORCYCLE"
    case truck = "TRUCK"

    init(from decoder: Decoder) throws {
        self = Self(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
}
