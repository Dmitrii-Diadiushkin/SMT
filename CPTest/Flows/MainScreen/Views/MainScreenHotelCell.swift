//
//  MainScreenHotelCell.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 11.01.2023.
//

import UIKit

final class MainScreenHotelCell: UITableViewCell {
    
    static let reuseIdentifier: String = String(describing: MainScreenHotelCell.self)
    
    private let hotelNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hotelAdressLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hotelDistanceLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12)
        view.textColor = .gray
        view.text = "Distance to hotel:"
        return view
    }()
    
    private let hotelDistanceDataLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    private let hotelRatingLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12)
        view.textColor = .gray
        view.text = "Hotel rating:"
        return view
    }()
    
    private let hotelRatingDataLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    private let hotelRoomsLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12)
        view.textColor = .gray
        view.text = "Rooms available:"
        return view
    }()
    
    private let hotelRoomsDataLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func updateCell(_ data: HotelListModelView) {
        hotelNameLabel.text = data.hotelName
        hotelAdressLabel.text = data.hotelAdress
        hotelDistanceDataLabel.text = String(data.distance)
        hotelRatingDataLabel.text = data.hotelRating
        hotelRoomsDataLabel.text = String(data.suitesAvailable)
    }
    
    private func initialConfiguration() {
        
        contentView.addSubview(hotelNameLabel)
        NSLayoutConstraint.activate([
            hotelNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hotelNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            hotelNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        contentView.addSubview(hotelAdressLabel)
        NSLayoutConstraint.activate([
            hotelAdressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hotelAdressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            hotelAdressLabel.topAnchor.constraint(equalTo: hotelNameLabel.bottomAnchor, constant: 10)
        ])
        
        contentView.addSubview(hotelDistanceLabel)
        contentView.addSubview(hotelDistanceDataLabel)
        NSLayoutConstraint.activate([
            hotelDistanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hotelDistanceLabel.topAnchor.constraint(equalTo: hotelAdressLabel.bottomAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            hotelDistanceDataLabel.leadingAnchor.constraint(equalTo: hotelDistanceLabel.trailingAnchor, constant: 2),
            hotelDistanceDataLabel.centerYAnchor.constraint(equalTo: hotelDistanceLabel.centerYAnchor)
        ])
        
        contentView.addSubview(hotelRatingLabel)
        contentView.addSubview(hotelRatingDataLabel)
        NSLayoutConstraint.activate([
            hotelRatingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hotelRatingLabel.topAnchor.constraint(equalTo: hotelDistanceLabel.bottomAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            hotelRatingDataLabel.leadingAnchor.constraint(equalTo: hotelRatingLabel.trailingAnchor, constant: 2),
            hotelRatingDataLabel.centerYAnchor.constraint(equalTo: hotelRatingLabel.centerYAnchor)
        ])
        
        contentView.addSubview(hotelRoomsLabel)
        contentView.addSubview(hotelRoomsDataLabel)
        NSLayoutConstraint.activate([
            hotelRoomsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hotelRoomsLabel.topAnchor.constraint(equalTo: hotelRatingLabel.bottomAnchor, constant: 10),
            hotelRoomsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            hotelRoomsDataLabel.leadingAnchor.constraint(equalTo: hotelRoomsLabel.trailingAnchor, constant: 2),
            hotelRoomsDataLabel.centerYAnchor.constraint(equalTo: hotelRoomsLabel.centerYAnchor)
        ])
    }
}
