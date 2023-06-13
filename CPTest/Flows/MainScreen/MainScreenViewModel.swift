//
//  MainScreenViewModel.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 11.01.2023.
//

import Foundation
import Combine

enum RecieveState {
    case success([HotelListModelView])
    case inProgress
    case failure
}

protocol MainScreenViewModelProtocol: AnyObject {
    var hotelDataPublisher: AnyPublisher<RecieveState, Never> { get }
    var onDetailScreen: ((Int) -> Void)? { get set }
    func loadData()
    func hotelSelected(with id: Int)
    func sortHotels(sortType: HotelsSortType)
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    var hotelDataPublisher: AnyPublisher<RecieveState, Never> {
        return hotelDataUpdater.eraseToAnyPublisher()
    }
    private let hotelDataUpdater = CurrentValueSubject<RecieveState, Never>(.inProgress)
    var onDetailScreen: ((Int) -> Void)?
    private let dataManager: NetworkHandlerProtocol
    init() {
        self.dataManager = NetworkHandler()
    }
    func loadData() {
        hotelDataUpdater.send(.inProgress)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.dataManager.getHotelList { [weak self] result in
                switch result {
                case let .success(recievedData):
                    guard let self = self else { return }
                    let hotelData = self.createHotelListModelView(from: recievedData)
                    self.hotelDataUpdater.send(.success(hotelData))
                case .failure:
                    self?.hotelDataUpdater.send(.failure)
                }
            }
        }
    }
    func hotelSelected(with id: Int) {
        switch hotelDataUpdater.value {
        case let .success(data):
            if data.indices.contains(id) {
                onDetailScreen?(data[id].hotelID)
            }
        default:
            break
        }
    }
    func sortHotels(sortType: HotelsSortType) {
        switch hotelDataUpdater.value {
        case let .success(data):
            let sortedData = getSortedList(for: data, with: sortType)
            hotelDataUpdater.send(.success(sortedData))
        default:
            break
        }
    }
}

private extension MainScreenViewModel {
    func getSortedList(for data: [HotelListModelView], with sortType: HotelsSortType) -> [HotelListModelView] {
        switch sortType {
        case .defaultSorting:
            return data.sorted { $0.itemPos < $1.itemPos }
        case .distanceAsc:
            return data.sorted { $0.distance < $1.distance }
        case .distanceDesc:
            return data.sorted { $0.distance > $1.distance }
        case .roomsAsc:
            return data.sorted { $0.suitesAvailable < $1.suitesAvailable }
        case .roomsDesc:
            return data.sorted { $0.suitesAvailable > $1.suitesAvailable }
        }
    }
    func createHotelListModelView(from data: [HotelList]) -> [HotelListModelView] {
        var dataCounter = 0
        var hotelData = [HotelListModelView]()
        data.forEach { hotel in
            let suitesCount = hotel.suitesAvailability.components(separatedBy: ":").filter { $0 != "" }.count
            hotelData.append(HotelListModelView(
                itemPos: dataCounter,
                hotelID: hotel.id,
                hotelName: hotel.name,
                hotelAdress: hotel.address,
                hotelRating: String(hotel.stars),
                distance: hotel.distance,
                suitesAvailable: suitesCount
            ))
            dataCounter += 1
        }
        return hotelData
    }
}
