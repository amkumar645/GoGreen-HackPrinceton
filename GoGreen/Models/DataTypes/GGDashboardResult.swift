import Foundation

struct GGDashboardResult: Codable {
    let emissions_saved: Float
    let total_distance: Float
    let mode_of_transport: String
    let xp_awarded: Int
}
