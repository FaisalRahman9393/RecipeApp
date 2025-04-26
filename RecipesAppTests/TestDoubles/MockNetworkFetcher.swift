import Foundation
@testable import RecipesApp

final class MockNetworkFetcher: NetworkFetcher {
    var dataToReturn: Data
    var shouldThrowError: Bool = false
    private(set) var capturedRequest: URLRequest?
    
    init(dataToReturn: Data, shouldThrowError: Bool = false) {
        self.dataToReturn = dataToReturn
        self.shouldThrowError = shouldThrowError
    }
    
    func fetch(request: URLRequest) async throws -> Data {
        self.capturedRequest = request
        
        if shouldThrowError {
            throw NetworkError.failedFailedToFetchData
        }
        
        return dataToReturn
    }
}
