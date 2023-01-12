//
//  NetworkHandlerProtocol.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import Foundation

protocol NetworkHandlerProtocol: AnyObject {
    func getHotelList(completion: ((Swift.Result<[HotelList], NetworkError>) -> Void)?)
    func getHotelDetails(
        for hotelID: Int,
        completion: ((Swift.Result<HotelDetails, NetworkError>) -> Void)?
    )
    func getImage(
        for imageAdress: String,
        completion: ((Result<Data, NetworkError>) -> Void)?
    )
}
