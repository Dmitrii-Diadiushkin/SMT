//
//  MainProgressView.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 12.01.2023.
//

import UIKit

final class MainProgressView: UIView {
    private let updatingLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Updating hotel info"
        view.textColor = .black
        return view
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(updatingLabel)
        NSLayoutConstraint.activate([
            updatingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            updatingLabel.topAnchor.constraint(equalTo: self.topAnchor),
            updatingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.topAnchor.constraint(equalTo: updatingLabel.bottomAnchor, constant: 20),
            activityView.centerXAnchor.constraint(equalTo: updatingLabel.centerXAnchor),
            activityView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        activityView.startAnimating()
    }
}
