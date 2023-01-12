//
//  DetailsViewController.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 12.01.2023.
//

import Combine
import UIKit

final class DetailsViewController: UIViewController {
    
    private let hotelNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "photo")
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
    
    private let viewModel: DetailsScreenViewModelProtocol
    
    private var bag = Set<AnyCancellable>()
    
    init(viewModel: DetailsScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
}

private extension DetailsViewController {
    func binding() {
        viewModel.hotelDetailsImageUpdater.sink { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.store(in: &bag)
        
        viewModel.hotelDetailsDataUpdater.sink { [weak self] hotelDetails in
            DispatchQueue.main.async {
                self?.hotelNameLabel.text = hotelDetails.hotelName
                self?.hotelRatingDataLabel.text = hotelDetails.rating
                self?.hotelRoomsDataLabel.text = hotelDetails.freeRoomsCount
            }
        }.store(in: &bag)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        view.addSubview(hotelNameLabel)
        NSLayoutConstraint.activate([
            hotelNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            hotelNameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            hotelNameLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -10)
        ])
        
        view.addSubview(hotelRatingLabel)
        view.addSubview(hotelRatingDataLabel)
        NSLayoutConstraint.activate([
            hotelRatingLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            hotelRatingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            hotelRatingDataLabel.leadingAnchor.constraint(equalTo: hotelRatingLabel.trailingAnchor, constant: 2),
            hotelRatingDataLabel.centerYAnchor.constraint(equalTo: hotelRatingLabel.centerYAnchor)
        ])
        
        view.addSubview(hotelRoomsLabel)
        view.addSubview(hotelRoomsDataLabel)
        NSLayoutConstraint.activate([
            hotelRoomsLabel.trailingAnchor.constraint(equalTo: hotelRoomsDataLabel.leadingAnchor, constant: -2),
            hotelRoomsLabel.centerYAnchor.constraint(equalTo: hotelRoomsDataLabel.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            hotelRoomsDataLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            hotelRoomsDataLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
    }
}
