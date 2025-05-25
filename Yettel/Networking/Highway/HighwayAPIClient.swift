import Foundation

final class HighwayAPIClient: HighwayAPIService {
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    private struct EmptyBody: Codable {
        init() {}
    }
    
    private let baseURL: URL
    private let http: HTTPClient
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(baseURL: URL = URL(string: "http://localhost:8080")!,
         http: HTTPClient = URLSessionHTTPClient(),
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.baseURL = baseURL
        self.http = http
        self.jsonDecoder = decoder
        self.jsonEncoder = encoder
    }
    
    func fetchHighwayInfo() async throws -> HighwayInfoResponse {
        try await send(.info)
    }

    func fetchVehicleInfo() async throws -> VehicleInfoResponse {
        try await send(.vehicle)
    }

    func placeHighwayOrder(_ order: HighwayOrderRequest) async throws -> HighwayOrderResponse {
        try await send(.order, method: .post, body: order)
    }
    
    private func send<Response: Decodable>(_ endpoint: HighwayEndpoint) async throws -> Response {
        try await send(endpoint, method: .get, body: Optional<EmptyBody>.none)
    }
    
    private func send<Body: Encodable, Response: Decodable>(_ endpoint: HighwayEndpoint,
                                                            method: HTTPMethod,
                                                            body: Body) async throws -> Response {
        try await send(endpoint, method: method, body: Optional(body))
    }
    
    private func send<Body: Encodable, Response: Decodable>(_ endpoint: HighwayEndpoint,
                                                            method: HTTPMethod = .get,
                                                            body: Body? = nil) async throws -> Response {
        var request = URLRequest(url: endpoint.url(relativeTo: baseURL))
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let body = body {
            request.httpBody = try jsonEncoder.encode(body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
#if DEBUG
        print("REQUEST: [\(method.rawValue)] \(request.url?.absoluteString ?? "")")
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers:")
            headers.forEach { print("  \($0.key): \($0.value)") }
        }
        
        if let body = request.httpBody,
           let string = String(data: body, encoding: .utf8),
           !string.isEmpty {
            print("Body:\n\(string)\n")
        }
#endif
        let (data, response) = try await http.perform(request: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HighwayAPIError.invalidStatus(-1)
        }
#if DEBUG
        print("RESPONSE: [\(httpResponse.statusCode)] \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        
        if let body = String(data: data, encoding: .utf8), !body.isEmpty {
            print("Body:\n\(body)\n")
        }
#endif
        guard 200 ..< 300 ~= httpResponse.statusCode else {
            throw HighwayAPIError.invalidStatus(httpResponse.statusCode)
        }
        
        do {
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            throw HighwayAPIError.decoding(error)
        }
    }
}
