import Foundation

final class GGRequest {
    private struct Constants {
        static let baseUrl = "https://gogreen-s3m3.onrender.com"
    }
    
    private let endpoint: GGEndpoint
    private let pathComponent: [String]
    private let queryParameters: [URLQueryItem]
    public let httpRequest: String
    
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        if !pathComponent.isEmpty {
            pathComponent.forEach({
                string += "/\($0)"
            })
        }
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return "" }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public init(endpoint: GGEndpoint,
         pathComponent: [String] = [],
         queryParameters: [URLQueryItem] = [],
         httpRequest: String
    ) {
        self.endpoint = endpoint
        self.pathComponent = pathComponent
        self.queryParameters = queryParameters
        self.httpRequest = httpRequest
    }
}
