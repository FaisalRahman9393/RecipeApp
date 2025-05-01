//
//  RecipeTableViewCell.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 01/05/2025.
//

import Foundation

import UIKit

final class RecipeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RecipeTableViewCell"

    private let nameLabel = UILabel()
    private let calorieLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with recipe: Recipe) {
        nameLabel.text = recipe.name
        calorieLabel.text = "Calories: \(recipe.calories)"
    }

    private func setupLayout() {
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        calorieLabel.font = .preferredFont(forTextStyle: .subheadline)
        calorieLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [nameLabel, calorieLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
