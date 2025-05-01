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
    
    private var networkFailureMessage: String? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Recipes"
        
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
        if networkFailureMessage != nil, section == 1 {
            return 1
        }
        
        return recipeSections[section].recipes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if networkFailureMessage != nil, indexPath.section == 1 {
            return 200
        }
        
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        recipeSections[section].type.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if networkFailureMessage != nil, indexPath.section == 1 {
            // no need to handle error cell for now
            return
        }
        
        let recipe = recipeSections[indexPath.section].recipes[indexPath.row]
        let detailVC = RecipeDetailViewController(recipe: recipe, viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell") ??
            UITableViewCell(style: .subtitle, reuseIdentifier: "SubtitleCell")
        
        if networkFailureMessage != nil, indexPath.section == 1 {
            return showErrorCell(cell)
        }
        
        let recipe = recipeSections[indexPath.section].recipes[indexPath.row]
        cell.textLabel?.text = recipe.name
        
        cell.detailTextLabel?.text = "Calories: \(recipe.calories)"
        return cell
    }
    
}

// MARK: - Private Methods
private extension TableViewController {
    
    func bindViewModel() {
        bindRecipeSections()
        bindLoadingState()
        bindFailureState()
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
    
    func bindFailureState() {
        viewModel.$networkFetchFailure
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.networkFailureMessage = message
            }
            .store(in: &cancellables)
    }
    
    func showErrorCell(_ cell: UITableViewCell) -> UITableViewCell {
        var config = cell.defaultContentConfiguration()
        config.text = self.networkFailureMessage
        config.textProperties.color = .systemRed
        config.textProperties.alignment = .center
        cell.contentConfiguration = config
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        return cell
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
