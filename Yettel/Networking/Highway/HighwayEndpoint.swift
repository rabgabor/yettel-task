import Foundation

enum HighwayEndpoint: String {
    case info = "info"
    case vehicle = "vehicle"
    case order = "order"

    private static let basePath = "v1/highway"
    
    func url(relativeTo baseURL: URL) -> URL {
        baseURL.appendingPathComponent(Self.basePath).appendingPathComponent(rawValue)
    }
    
    var method: String {
        switch self {
        case .info, .vehicle:
            return "GET"
        case .order:
            return "POST"
        }
    }
}
