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
    
    var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Test title"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.view.backgroundColor = .red
                
        Task {
            await viewModel.fetchRecipes()
        }
        
        bindViewModel()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
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
        viewModel.$recipes.receive(on: RunLoop.main)
            .sink { recipes in
                self.recipes = recipes
            }
            .store(in: &cancellables)
    }
}

