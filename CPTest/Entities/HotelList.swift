//
//  HotelList.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import Foundation

struct HotelList: Codable {
    let id: Int
    let name: String
    let address: String
    let stars: Int
    let distance: Float
    let suitesAvailability: String

    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance
        case suitesAvailability = "suites_availability"
    }
}
