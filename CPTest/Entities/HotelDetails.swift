//
//  HotelDetails.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 12.01.2023.
//

import Foundation

struct HotelDetails: Codable {
    let id: Int
    let name: String
    let address: String
    let stars: Int
    let distance: Double
    let image: String?
    let suitesAvailability: String
    let lat: Double
    let lon: Double

    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance, image
        case suitesAvailability = "suites_availability"
        case lat, lon
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        stars = try container.decode(Int.self, forKey: .stars)
        distance = try container.decode(Double.self, forKey: .distance)
        suitesAvailability = try container.decode(String.self, forKey: .suitesAvailability)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        let imageName = try container.decode(String?.self, forKey: .image)
        if let img = imageName,
           img == "" {
            image = nil
        } else {
            image = imageName
        }
      }
}
