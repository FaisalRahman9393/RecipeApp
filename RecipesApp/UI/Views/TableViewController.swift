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
    private var cancellables: [AnyCancellable] = []
    private var recipeSections: [RecipeSection] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let spinner = UIActivityIndicatorView(style: .large)

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        recipeSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeSections[section].recipes.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        recipeSections[section].type.title
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipeSections[indexPath.section].recipes[indexPath.row]
        let detailVC = RecipeDetailViewController(recipe: recipe, viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let recipe = recipeSections[indexPath.section].recipes[indexPath.row]
        cell.textLabel?.text = recipe.name
        return cell
    }
}

// MARK: - Private Methods
private extension TableViewController {

    func bindViewModel() {
        bindRecipeSections()
        bindLoadingState()
    }

    func bindRecipeSections() {
        viewModel.$recipeSections
            .receive(on: RunLoop.main)
            .sink { [weak self] sections in
                self?.recipeSections = sections
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
}
