//
//  TableViewController.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//

import UIKit
import Combine

class TableViewController: UITableViewController {
    
    let viewModel = RecipesViewModel()
    
    var recipes: [Recipe] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Recipes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupLoadingSpinner()
        bindViewModel()
                
        Task {
            await viewModel.fetchRecipes()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        let detailVC = RecipeDetailViewController(recipe: recipe)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = recipes[indexPath.row].name
        return cell
    }
}

//MARK: private methods
private extension TableViewController {
    
    func bindViewModel() {
        bindRecipes()
        bindLoadingState()
    }
    
    func bindLoadingState() {
        viewModel.$isLoading.receive(on: RunLoop.main)
            .sink { [weak self] loading in
                loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
            }
            .store(in: &cancellables)
    }
    
    func bindRecipes() {
        viewModel.$recipes.receive(on: RunLoop.main)
            .sink { [weak self] recipes in
                self?.recipes = recipes
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
}

