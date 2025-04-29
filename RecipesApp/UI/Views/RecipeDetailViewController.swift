//
//  RecipeDetailViewController.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 29/04/2025.
//

import Foundation
import UIKit

class RecipeDetailViewController: UIViewController {
    private let recipe: Recipe
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let recipeImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let ingredientsTitleLabel = UILabel()
    private let ingredientsListLabel = UILabel()
    
    private var isFavorite = false

    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = recipe.name
        
        setupNavBar()
        setupScrollView()
        setupContent()
        loadRecipeData()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Favorite",
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
    }
    
    @objc private func toggleFavorite() {
        isFavorite.toggle()
        navigationItem.rightBarButtonItem?.title = isFavorite ? "Unfavorite" : "Favorite"
        

        //TODO: ...
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setupContent() {
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        contentView.addArrangedSubview(recipeImageView)
        
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.numberOfLines = 0
        contentView.addArrangedSubview(descriptionLabel)
        
        ingredientsTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        ingredientsTitleLabel.adjustsFontForContentSizeCategory = true
        ingredientsTitleLabel.numberOfLines = 0
        ingredientsTitleLabel.text = "Ingredients"
        contentView.addArrangedSubview(ingredientsTitleLabel)
        
        ingredientsListLabel.font = UIFont.preferredFont(forTextStyle: .body)
        ingredientsListLabel.adjustsFontForContentSizeCategory = true
        ingredientsListLabel.numberOfLines = 0
        contentView.addArrangedSubview(ingredientsListLabel)
    }

    private func loadRecipeData() {
        recipeImageView.backgroundColor = .lightGray
        
        descriptionLabel.text = "A really really really really really really really really really really really really really really really really really really really really really really really really really really really really long description label"
        
        ingredientsListLabel.text = """
        • Ingredient
        • Ingredient
        • Ingredient
        • Ingredient
        • Ingredient
        • Ingredient
        • Ingredient
        • Ingredient
        """
    }
}
