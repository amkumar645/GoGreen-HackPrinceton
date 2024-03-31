import Foundation

struct GGProfile: Codable {
    let date_started: String
    let distance: Float
    let emissions_saved: Float
    let num_pets: Int
    let username: String
    let user_current_xp: Int
    let total_xp: Int
    let distance_breakdown_walk: Float
    let distance_breakdown_subway: Float
    let distance_breakdown_drive: Float
}
