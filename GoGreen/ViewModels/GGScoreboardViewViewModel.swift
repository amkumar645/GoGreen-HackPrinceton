import Foundation

struct GGScoreboardViewViewModel {
    func fetchScoreboard(completion: @escaping (Result<[GGProfile], Error>) -> Void) {
        let request = GGRequest(
            endpoint: .user,
            pathComponent: ["all"],
            httpRequest: "GET"
        )
        GGService.shared.execute(request, expecting: [GGProfile].self) { result in
            switch result {
            case .success(let profiles):
                completion(.success(profiles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
