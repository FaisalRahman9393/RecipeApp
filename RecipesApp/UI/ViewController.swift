//
//  ViewController.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = RecipesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .red
        
        Task {
            await viewModel.fetchRecipes()
        }
    }
}
