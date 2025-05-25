enum LanguageCode: String {
    case hu, en
}

struct LocalizedString: Codable {
    let hu: String
    let en: String

    subscript(lang: LanguageCode) -> String {
        switch lang {
        case .hu:
            return hu;
        case .en:
            return en
        }
    }
}
