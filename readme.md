# Recipe App

This app allows users to:

- View all recipes from the API endpoint.
- Favourite a recipe using the top-right navigation button:
  - Favourited recipes are stored using `UserDefaults`.
  - Users can also unfavourite recipes by pressing the same button.
- If the app fails to fetch recipes, it will still display favourited ones:
  - The list view includes retry logic.
- Dynamic type is supported to improve accessibility.
- VoiceOver has not been explicitly tested, but since system components are used, default behaviour should work as expected.

## Notes on Implementation Decisions

- **UIKit over SwiftUI**:  
  Although I have designed views in SwiftUI before, I opted for UIKit here as I’m slightly more experienced with it. UIKit is more stable, though it introduces more boilerplate.

- **ViewModel with Combine**:  
  I used a view model that updates views through `@Published` and Combine. This reactive approach would integrate well with SwiftUI if swapped in later.

- **Persistence using `UserDefaults`**:  
  Core Data would be a better long-term solution, especially as the app becomes more complex. Storing more than 100KB in `UserDefaults` is discouraged for performance reasons, though this app stays well below that.  
  - The `PersistenceService` abstraction makes it easy to swap in a `CoreDataPersistenceService` later.

- **Tight Coupling**:  
  To save time, I directly used the return types from the service layer. This introduces tight coupling and could be improved with an adapter or transformation layer.

- **Routing**:  
  Currently, the app does not use routing. A basic UI test confirms navigation from the list to the detail view. In a larger app, I would introduce a coordinator or router pattern.

- **API Key**:  
  The API key is hardcoded to save time. This is not secure; ideally, we would retrieve it at runtime or obfuscate it to reduce exposure.

- **Localization**:  
  Strings could be moved into a `.strings` file to support localization and centralize content management.

- **Testing**:  
  If I had more time, I would have added snapshot tests for UI validation.
