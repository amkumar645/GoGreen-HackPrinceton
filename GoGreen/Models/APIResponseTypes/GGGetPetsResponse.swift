//
//  GetPetsResponse.swift
//  GoGreen
//
//  Created by Arnav Kumar on 3/27/24.
//

import Foundation

struct GGGetPetsResponse: Codable {
    let username: String
    let pets: [String]
}
