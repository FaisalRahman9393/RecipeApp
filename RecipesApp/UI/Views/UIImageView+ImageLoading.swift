//
//  UIImageView+ImageLoading.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 01/05/2025.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from urlString: String) async {
        let spinner = addSpinner()

        guard let url = URL(string: urlString) else {
            handleFailureState(spinner: spinner)
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0  // Set timeout to 5 seconds

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let image = UIImage(data: data) else {
                handleFailureState(spinner: spinner)
                return
            }
            handleSuccessState(with: image, spinner: spinner)
        } catch {
            handleFailureState(spinner: spinner)
        }
    }

    // MARK: - Private Helpers

    private func addSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        self.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        return spinner
    }

    @MainActor
    private func handleFailureState(spinner: UIActivityIndicatorView) {
        spinner.removeFromSuperview()
        self.subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel()
        label.text = "Image failed to load :("
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        self.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -8)
        ])
    }

    @MainActor
    private func handleSuccessState(with image: UIImage, spinner: UIActivityIndicatorView) {
        spinner.removeFromSuperview()
        self.image = image
    }
}
