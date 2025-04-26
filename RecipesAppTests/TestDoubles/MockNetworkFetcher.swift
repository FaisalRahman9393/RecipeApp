import Foundation
@testable import RecipesApp

struct MockNetworkFetcher: NetworkFetcher {
    var dataToReturn: Data
    var shouldThrowError: Bool = false
    
    func fetch(request: URLRequest) async throws -> Data {
        if shouldThrowError {
            throw NetworkError.failedFailedToFetchData
        }
        return dataToReturn
    }
}
