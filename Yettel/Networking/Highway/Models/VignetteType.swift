enum VignetteType: String, Codable, CaseIterable {
    case day = "DAY"
    case week = "WEEK"
    case month = "MONTH"
    case year = "YEAR"
    case year11 = "YEAR_11"
    case year12 = "YEAR_12"
    case year13 = "YEAR_13"
    case year14 = "YEAR_14"
    case year15 = "YEAR_15"
    case year16 = "YEAR_16"
    case year17 = "YEAR_17"
    case year18 = "YEAR_18"
    case year19 = "YEAR_19"
    case year20 = "YEAR_20"
    case year21 = "YEAR_21"
    case year22 = "YEAR_22"
    case year23 = "YEAR_23"
    case year24 = "YEAR_24"
    case year25 = "YEAR_25"
    case year26 = "YEAR_26"
    case year27 = "YEAR_27"
    case year28 = "YEAR_28"
    case year29 = "YEAR_29"

    init(from decoder: Decoder) throws {
        self = Self(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
}
