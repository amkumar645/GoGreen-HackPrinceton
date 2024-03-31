import Foundation
import CoreLocation

struct GGDashboardViewViewModel {
    func addTrip(
        tripSpeeds: [CLLocationSpeed],
        transitStops: [Bool],
        totalDistance: CLLocationDistance,
        completion: @escaping (Result<GGDashboardResult, Error>) -> Void
    ) {
        let encoder = JSONEncoder()
        guard let tripSpeedsData = try? encoder.encode(tripSpeeds),
              let transitStopsData = try? encoder.encode(transitStops),
              let totalDistanceData = try? encoder.encode(totalDistance) else {
            completion(.failure(NSError(domain: "Serialization Error", code: 0, userInfo: nil)))
            return
        }
        let tripSpeedsJSON = String(data: tripSpeedsData, encoding: .utf8)!
        let transitStopsJSON = String(data: transitStopsData, encoding: .utf8)!
        let totalDistanceJSON = String(data: totalDistanceData, encoding: .utf8)!
        
        let request = GGRequest(
            endpoint: .dashboard,
            pathComponent: ["newtrip", "amkumar"],
            queryParameters: [
                URLQueryItem(name: "tripSpeeds", value: tripSpeedsJSON),
                URLQueryItem(name: "transitStops", value: transitStopsJSON),
                URLQueryItem(name: "totalDistance", value: totalDistanceJSON)
            ],
            httpRequest: "POST"
        )
        GGService.shared.execute(request, expecting: GGDashboardResult.self) { result in
            switch result {
            case .success(let trip_results):
                completion(.success(trip_results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
