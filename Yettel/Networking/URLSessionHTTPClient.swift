import Foundation

struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func perform(request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
