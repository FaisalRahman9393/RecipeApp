
Mobile Engineer Task 
Here at Rightmove, we work across two native app teams -- both teams are small, cross-functional and while we constantly collaborate, each team focuses on specific goals and key performance indicators.   
 
With this take home task we're looking to see how you think about problems and how you approach solutions. It's your chance to show us "what good looks like" to you. We're not expecting something you could ship to the App Store tomorrow, but we are looking for a functioning app, and for you to showcase production-quality.
 
Finally, think about how a user might want this app to function. We've specified some requirements, but feel free to show us your product mindset and thinking when completing this task. 

**The Recipe Collection App .** We'd like you to build an app that lets users explore recipes and curate their own collections using [Tasty](https://rapidapi.com/apidojo/api/tasty/playground/).  

### Task Overview
Build a native app that shows a list of recipes from the API and the user's favourite recipe collection at the top. Selecting a recipe should display the recipe's details, it's up to you to decide which details are relevant to display. From this view, the user should be able to add or remove it from their favourite collection. The user's favourite collection should persist between app launches.   

###  Deliverable
App should be written in Swift and utilise UIKit or SwiftUI.- Please use any testing techniques you would use for production code. - When complete, please share your project with this GitHub account (https://github.com/RightmoveAppsTechTask).
- Highlight any decisions or limitations within your project.
 
### What We Look For
As a reminder, we are looking for a functioning app, and for you to showcase production-quality. You should be mindful to consider the developer experience as part of this test.- It's okay to use third party libraries, but make sure there is enough of your code that we can make a good assessment of your abilities.
 
### Disclaimer
We will not use any of this code for any of Rightmove's applications.
 
--------------------------------

- Currently the little logic inside the Network fetcher is untested 
    - A new test file could be added and both happy and unhappy paths (throwing of errors) could be tested 
    - Although this would be making a direct network call (and utilising a bit more resources), it wouldn't be a lot of tests as the rest of the behaviour is tested inside the RecipeServiceTests

- fetchRecipes currently throws generic errors. A better approach would be to throw specific errors so these decisions don't have to be made at the view layer. In a large application this would also make debugging/ logging easier.

- App security:
	- TODO 

- Url components and request decrators can be inject through a config, this would allow for reuse and better testing

TODO:

/- show a list of recipes 
- show users favourite recipes
- Should have persistence 
- Selecting a recipe should show the details (up to me what details)
    - Should be able to add or remove from the details view
