import Foundation

struct GGPetsViewViewModel {
    func fetchPets(completion: @escaping (Result<GGPets, Error>) -> Void) {
        let request = GGRequest(
            endpoint: .pets,
            pathComponent: ["amkumar"],
            httpRequest: "GET"
        )
        GGService.shared.execute(request, expecting: GGPets.self) { result in
            switch result {
            case .success(let pets):
                completion(.success(pets))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addPet(name: String, completion: @escaping (Result<GGPets, Error>) -> Void) {
        let request = GGRequest(
            endpoint: .pets,
            pathComponent: ["amkumar", "add", name],
            httpRequest: "POST"
        )
        GGService.shared.execute(request, expecting: GGPets.self) { result in
            switch result {
            case .success(let pets):
                completion(.success(pets))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func levelUpPet(name: String, completion: @escaping (Result<GGPets, Error>) -> Void) {
        let request = GGRequest(
            endpoint: .pets,
            pathComponent: ["amkumar", "levelup", name],
            httpRequest: "POST"
        )
        GGService.shared.execute(request, expecting: GGPets.self) { result in
            switch result {
            case .success(let pets):
                completion(.success(pets))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
