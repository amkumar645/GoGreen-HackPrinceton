import Foundation

final class GGService {
    static let shared = GGService()
    
    private init() {}
    
    enum GGServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    public func execute<T: Codable>(
        _ request: GGRequest, 
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(GGServiceError.failedToCreateRequest))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(GGServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func request(from ggRequest: GGRequest) -> URLRequest? {
        guard let url = ggRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = ggRequest.httpRequest
        return request
    }
}
