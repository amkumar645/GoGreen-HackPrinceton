import Foundation

struct GGProfileViewViewModel {
    func fetchProfile(completion: @escaping (Result<GGProfile, Error>) -> Void) {
        let request = GGRequest(
            endpoint: .user,
            pathComponent: ["amkumar"],
            httpRequest: "GET"
        )
        GGService.shared.execute(request, expecting: GGProfile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
