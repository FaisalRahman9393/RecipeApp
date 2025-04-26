
- Currently the little logic inside the Network fetcher is untested 
    - A new test file could be added and both happy and unhappy paths (throwing of errors) could be tested 
    - Although this would be making a direct network call (and utilising a bit more resources), it wouldn't be a lot of tests as the rest of the behaviour is tested inside the RecipeServiceTests

- fetchRecipes currently throws generic errors. A better approach would be to throw specific errors so these decisions don't have to be made at the view layer. In a large application this would also make debugging/ logging easier.

- App security:
	- TODO 

- Url components and request decrators can be inject through a config, this would allow for reuse and better testing
