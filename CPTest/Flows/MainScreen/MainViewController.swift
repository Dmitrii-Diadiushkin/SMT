//
//  MainViewController.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import Combine
import Foundation
import UIKit

class MainViewController: UIViewController {
    
    private let viewModel: MainScreenViewModelProtocol
    
    private let tableView = UITableView()
    private let updatingView = MainProgressView()
    private let errorView = MainErrorView()
    private var dataSource: UITableViewDiffableDataSource<Int, HotelListModelView>! = nil
    private var sorting: HotelsSortType = .defaultSorting
    
    private var bag = Set<AnyCancellable>()
    
    init(viewModel: MainScreenViewModelProtocol = MainScreenViewModel()) {
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
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
}

private extension MainViewController {
    func binding() {
        viewModel.hotelDataUpdater.dropFirst().sink { updaterState in
            DispatchQueue.main.async {
                switch updaterState {
                case let .success(recievedData):
                    print("Got \(recievedData.count) hotels")
                    self.updatingView.isHidden = true
                    self.errorView.isHidden = true
                    self.tableView.isHidden = false
                    self.configureSortMenu()
                    self.configureUpdateMenu()
                    self.showData(recievedData)
                case .inProgress:
                    print("Updating data")
                    self.updatingView.isHidden = false
                    self.errorView.isHidden = true
                    self.tableView.isHidden = true
                    self.navigationItem.leftBarButtonItem = nil
                    self.navigationItem.rightBarButtonItem = nil
                case .failure:
                    self.errorView.isHidden = false
                    self.updatingView.isHidden = true
                    self.tableView.isHidden = true
                    self.navigationItem.leftBarButtonItem = nil
                    self.configureUpdateMenu()
                    print("Something went wrong")
                }
            }
            
        }.store(in: &bag)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        configureTableView()
        configureUpdatingView()
        configureErrorView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(
            MainScreenHotelCell.self,
            forCellReuseIdentifier: MainScreenHotelCell.reuseIdentifier
        )
        tableView.delegate = self
    }
    
    func configureUpdatingView() {
        view.addSubview(updatingView)
        NSLayoutConstraint.activate([
            updatingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            updatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        updatingView.isHidden = true
    }
    
    func configureErrorView() {
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        errorView.isHidden = true
    }
    
    func configureUpdateMenu() {
        let updateMenuButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise.circle"),
            style: .plain,
            target: self,
            action: #selector(refresh)
        )
        
        self.navigationItem.rightBarButtonItem  = updateMenuButton
    }
    
    func configureSortMenu() {
        let sortMenuButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: nil
        )
        
        let selectedImage = UIImage(systemName: "checkmark")
        
        let noSort = UIAction(
            title: "Default sort",
            image: sorting == .defaultSorting ? selectedImage : nil) { action in
                print("No sort tapped")
                self.sorting = .defaultSorting
                self.viewModel.sortHotels(sortType: .defaultSorting)
            }
        
        let distanceDescending = UIAction(
            title: "Distance descending",
            image: sorting == .distanceDesc ? selectedImage : nil) { action in
                print("Distance descending")
                self.sorting = .distanceDesc
                self.viewModel.sortHotels(sortType: .distanceDesc)
            }
        
        let distanceAscending = UIAction(
            title: "Distance ascending",
            image: sorting == .distanceAsc ? selectedImage : nil) { action in
                print("Distance ascending")
                self.sorting = .distanceAsc
                self.viewModel.sortHotels(sortType: .distanceAsc)
            }
        
        let suitesAvailableDesending = UIAction(
            title: "Free rooms descending",
            image: sorting == .roomsDesc ? selectedImage : nil) { action in
                print("Free rooms descending")
                self.sorting = .roomsDesc
                self.viewModel.sortHotels(sortType: .roomsDesc)
            }
        
        let suitesAvailableAsending = UIAction(
            title: "Free rooms ascending",
            image: sorting == .roomsAsc ? selectedImage : nil) { action in
                print("Free rooms ascending")
                self.sorting = .roomsAsc
                self.viewModel.sortHotels(sortType: .roomsAsc)
            }
        sortMenuButton.menu = UIMenu(
            title: "Select sort type",
            image: nil,
            identifier: nil,
            options: .destructive,
            children: [
                noSort, distanceDescending, distanceAscending, suitesAvailableDesending, suitesAvailableAsending
            ]
        )
        self.navigationItem.leftBarButtonItem  = sortMenuButton
    }
    
    func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource
        <Int, HotelListModelView> (tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: HotelListModelView) -> UITableViewCell? in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MainScreenHotelCell.reuseIdentifier,
                for: indexPath) as? MainScreenHotelCell
            else {
                return UITableViewCell()
            }
            cell.updateCell(item)
            return cell
        }
    }
    
    func showData(_ data: [HotelListModelView]) {
        var currentSnapshot = NSDiffableDataSourceSnapshot<Int, HotelListModelView>()
        currentSnapshot.appendSections([0])
        currentSnapshot.appendItems(data)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    @objc func refresh(){
        sorting = .defaultSorting
        viewModel.loadData()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.hotelSelected(with: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
