@testable import Yettel
import Foundation

final class MockHTTPClient: HTTPClient {
    var nextData: Data
    var nextStatus: Int
    private(set) var lastRequest: URLRequest?
    
    init(nextData: Data, status: Int = 200) {
        self.nextData = nextData
        self.nextStatus = status
    }
    
    func perform(request: URLRequest) async throws -> (Data, URLResponse) {
        lastRequest = request
        let resp = HTTPURLResponse(
            url: request.url!,
            statusCode: nextStatus,
            httpVersion: nil,
            headerFields: nil
        )!
        return (nextData, resp)
    }
}
