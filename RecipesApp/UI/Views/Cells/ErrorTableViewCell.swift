//
//  ErrorTableViewCell.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 01/05/2025.
//

import UIKit

final class ErrorTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ErrorTableViewCell"

    private let messageLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(message: String) {
        messageLabel.text = message
    }

    private func setupLayout() {
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textColor = .systemRed
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
