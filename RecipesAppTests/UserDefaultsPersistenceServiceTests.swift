//
//  UserDefaultsPersistenceServiceTests.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 30/04/2025.
//

import Foundation
@testable import RecipesApp
import XCTest

final class UserDefaultsPersistenceServiceTests: XCTestCase {

    private var sut: UserDefaultsPersistenceService!
    private var mockDefaults: UserDefaults!
    private let suiteName = "test.favourites"

    override func setUp() {
        super.setUp()
        mockDefaults = UserDefaults(suiteName: suiteName)
        mockDefaults.removePersistentDomain(forName: suiteName)
        sut = UserDefaultsPersistenceService(userDefaults: mockDefaults)
    }

    override func tearDown() {
        mockDefaults.removePersistentDomain(forName: suiteName)
        mockDefaults = nil
        sut = nil
        super.tearDown()
    }

    func testGivenEmptyFavourites_WhenAddFavouriteIsCalled_ThenRecipeIsStored() {
        // Given
        let recipe = Recipe(name: "Pizza", image: "")
        // When
        sut.addFavourite(recipe)
        // Then
        XCTAssertTrue(mockDefaults.stringArray(forKey: "favouriteRecipes")?.contains("Pizza") ?? false)
    }

    func testGivenStoredFavourites_WhenRemoveFavouriteIsCalled_ThenRecipeIsRemoved() {
        // Given
        let recipe = Recipe(name: "Pizza", image: "")
        sut.addFavourite(recipe)
        // When
        sut.removeFavourite(recipe)
        // Then
        XCTAssertFalse(mockDefaults.stringArray(forKey: "favouriteRecipes")?.contains("Pizza") ?? true)
    }

    func testGivenStoredRecipe_WhenIsFavouriteIsCalled_ThenReturnsTrue() {
        // Given
        let recipe = Recipe(name: "Pizza", image: "")
        // When
        sut.addFavourite(recipe)
        // Then
        XCTAssertTrue(sut.isFavourite(recipe))
    }

    func testGivenNoStoredRecipe_WhenIsFavouriteIsCalled_ThenReturnsFalse() {
        let recipe = Recipe(name: "Sushi", image: "")
        XCTAssertFalse(sut.isFavourite(recipe))
    }

    func testGivenMultipleRecipesStored_WhenGetFavouritesIsCalled_ThenReturnsAllRecipes() {
        // Given
        sut.addFavourite(Recipe(name: "Curry", image: ""))
        sut.addFavourite(Recipe(name: "Stew", image: ""))
        // When
        let result = sut.getFavourites().map { $0.name }.sorted()
        // Then
        XCTAssertEqual(result, ["Curry", "Stew"])
    }
}
