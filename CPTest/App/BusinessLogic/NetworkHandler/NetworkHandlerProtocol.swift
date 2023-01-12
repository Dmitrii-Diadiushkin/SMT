//
//  NetworkHandlerProtocol.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import Foundation

protocol NetworkHandlerProtocol: AnyObject {
    func getHotelList(completion: ((Swift.Result<[HotelList], NetworkError>) -> Void)?)
}
