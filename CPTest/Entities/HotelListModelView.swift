//
//  HotelListModelView.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 11.01.2023.
//

import Foundation

struct HotelListModelView: Hashable {
    let itemPos: Int
    let hotelID: Int
    let hotelName: String
    let hotelAdress: String
    let hotelRating: String
    let distance: Float
    let suitesAvailable: Int
}
