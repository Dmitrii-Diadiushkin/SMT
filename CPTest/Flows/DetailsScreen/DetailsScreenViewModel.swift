//
//  DetailsScreenViewModel.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 12.01.2023.
//

import Combine
import Foundation
import UIKit

protocol DetailsScreenViewModelProtocol: AnyObject {
    var hotelDetailsImageUpdater: PassthroughSubject<UIImage, Never> { get set }
    var hotelDetailsDataUpdater: PassthroughSubject<HotelDetailsModelView, Never> { get set }
    func loadData()
}

final class DetailsScreenViewModel: DetailsScreenViewModelProtocol {
    var hotelDetailsImageUpdater = PassthroughSubject<UIImage, Never>()
    var hotelDetailsDataUpdater = PassthroughSubject<HotelDetailsModelView, Never>()
    
    private let hotelID: Int
    private let dataManager: NetworkHandlerProtocol
    
    init(hotelID: Int) {
        self.hotelID = hotelID
        self.dataManager = NetworkHandler()
    }
    
    func loadData() {
        dataManager.getHotelDetails(for: hotelID) { [weak self] result in
            switch result {
            case let .success(recievedData):
                guard let self = self else { return }
                let hotelDetailsModel = self.createHotelDetails(data: recievedData)
                self.hotelDetailsDataUpdater.send(hotelDetailsModel)
                if let imageAdress = recievedData.image {
                    self.getImage(with: imageAdress)
                }
            case .failure(_):
                print("Error")
            }
        }
    }
}

private extension DetailsScreenViewModel {
    func getImage(with imageAdress: String) {
        dataManager.getImage(for: imageAdress) { [weak self] result in
            switch result {
            case let .success(recievedData):
                if let recievedImage = UIImage(data: recievedData) {
                    self?.createAndSendCroppedImage(recievedImage)
                }
            case .failure(_):
                print("Error")
            }
        }
    }
    
    func createAndSendCroppedImage(_ sourceImage: UIImage) {
        let sourceSize = sourceImage.size
        let cropRect = CGRect(
            x: 1,
            y: 1,
            width: sourceSize.width - 2,
            height: sourceSize.height - 2
        )
        let sourceCGImage = sourceImage.cgImage!
        if let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        ) {
            let resultImage = UIImage(cgImage: croppedCGImage)
            hotelDetailsImageUpdater.send(resultImage)
        }
    }
    
    func createHotelDetails(data: HotelDetails) -> HotelDetailsModelView {
        let suitesCount = data.suitesAvailability.components(separatedBy: ":").filter { $0 != "" }.count
        return HotelDetailsModelView(
            hotelName: data.name,
            rating: String(data.stars),
            freeRoomsCount: String(suitesCount))
    }
}
