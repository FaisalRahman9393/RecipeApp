import Foundation

let sampleRecipesJSON: Data = """
{
    "results": [
        {
            "id": 1,
            "name": "pizza",
            "description": "test description pizza",
            "thumbnail_url": "https://example.com/pizza.jpg",
            "instructions": [{ "display_text": "test display test pizza" }],
            "nutrition": {
                "calories": 111,
                "fat": 222,
                "protein": 333,
                "sugar": 444,
                "carbohydrates": 555,
                "fiber": 666
            }
        },
        {
            "id": 2,
            "name": "burger",
            "description": "test description burger",
            "thumbnail_url": "https://example.com/burger.jpg",
            "instructions": [{ "display_text": "test display test burger" }],
            "nutrition": {
                "calories": 777,
                "fat": 888,
                "protein": 999,
                "sugar": 121,
                "carbohydrates": 122,
                "fiber": 123
            }
        }
    ]
}
""".data(using: .utf8)!

let emptyRecipesJSON: Data = """
{
    "results": []
}
""".data(using: .utf8)!

let invalidRecipesJSON: Data = """
{
    "invalid_key": []
}
""".data(using: .utf8)!
