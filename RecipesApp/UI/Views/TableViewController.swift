//
//  TableViewController.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//

import UIKit
import Combine

class TableViewController: UITableViewController {
    
    private let viewModel = RecipesViewModel()
    private var cancellables: [AnyCancellable] = []
    
    private var recipeSections: [RecipeSection] = []
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipes"
        registerCells()
        setupLoadingSpinner()
        bindViewModel()
        fetchRecipes()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        recipeSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch recipeSections[section].type {
        case .error:
            return 1
        case .favourited, .other:
            return recipeSections[section].recipes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case .error = recipeSections[indexPath.section].type {
            return 200
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        recipeSections[section].type.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = recipeSections[indexPath.section]
        
        switch section.type {
        case .error: fetchRecipes()
        case .favourited, .other:
            let recipe = section.recipes[indexPath.row]
            let detailVC = RecipeDetailViewController(recipe: recipe, viewModel: viewModel)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = recipeSections[indexPath.section]
        
        switch section.type {
        case .error(let message):
            return makeErrorCell(message, at: indexPath)
            
        case .favourited, .other:
            let recipe = section.recipes[indexPath.row]
            return makeRecipeCell(for: recipe, at: indexPath)
        }
    }
}

// MARK: - Private Helpers

private extension TableViewController {
    func bindViewModel() {
        bindLoadingState()
        bindRecipeSections()
    }
    
    func bindRecipeSections() {
        viewModel.$recipeSections
            .receive(on: RunLoop.main)
            .sink { [weak self] sections in
                self?.recipeSections = sections
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func bindLoadingState() {
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
            }
            .store(in: &cancellables)
    }
    
    func setupLoadingSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func fetchRecipes() {
        Task {
            await viewModel.fetchRecipes()
        }
    }
    
    func registerCells() {
        tableView.register(ErrorTableViewCell.self, forCellReuseIdentifier: ErrorTableViewCell.reuseIdentifier)
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.reuseIdentifier)
    }
    
    func makeErrorCell(_ message: String, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseIdentifier, for: indexPath) as? ErrorTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(message: message)
        return cell
    }

    func makeRecipeCell(for recipe: Recipe, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseIdentifier, for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: recipe)
        return cell
    }
}
