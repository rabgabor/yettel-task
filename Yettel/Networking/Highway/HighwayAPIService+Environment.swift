import SwiftUI

struct HighwayAPIServiceKey: EnvironmentKey {
    static let defaultValue: HighwayAPIService = HighwayAPIClient()
}

extension EnvironmentValues {
    var apiService: HighwayAPIService {
        get {
            self[HighwayAPIServiceKey.self]
        }
        set {
            self[HighwayAPIServiceKey.self] = newValue
        }
    }
}
