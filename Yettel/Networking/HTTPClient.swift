import Foundation

protocol HTTPClient {
    func perform(request: URLRequest) async throws -> (Data, URLResponse)
}
