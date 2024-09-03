//
//  FoodAPI.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 20.07.24.
//

import Foundation
import SwiftUICore
import DeveloperToolsSupport

struct FoodInfo: Codable {
    var code: String
    var product: Product
    
    struct Product: Codable {
        var _id: String
        var product_name: String
        var allergens_from_user: String
        var image_front_url: String
        var ingredients_text_en: String?
        var ingredients_text_de: String?
        var brands: String?
        var nutriments: Nutriments
        var nutriscore_grade: String
        
        
        func getNutriScore() -> String {
            switch nutriscore_grade.lowercased() {
            case "a":
                return "Nutri-score-A.svg"
            case "b":
                return "Nutri-score-B.svg"
            case "c":
                return "Nutri-score-C.svg"
            case "d":
                return "Nutri-score-D.svg"
            case "e":
                return "Nutri-score-E.svg"
            default:
                return "questionmark.circle"
            }
        }

    }
    
    struct Nutriments: Codable {
        let energy: Double
        let proteins: Double
        let fat: Double
        let carbohydrates: Double
        let sugars: Double
        let salt: Double
        
        var allNutrients: [(name: String, value: Double)] {
                return [
                    ("Energy", energy),
                    ("Proteins", proteins),
                    ("Fat", fat),
                    ("Carbohydrates", carbohydrates),
                    ("Sugars", sugars),
                    ("Salt", salt)
                ]
            }
    }
    struct SourcesInfo: Codable {
        var name: String
    }
}

class FoodAPI: ObservableObject {
    
    // Fetches product information using the given barcode
    func getProduct(barcode: String) async throws -> FoodInfo {
        // Construct the API URL
        let baseUrl = "https://world.openfoodfacts.org/api/v3/product/\(barcode).json"
        
        // Ensure the URL is valid
        guard let url = URL(string: baseUrl) else {
            throw FError.invalidURL
        }
        
        // Perform network request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Print raw data for debugging
        if let rawJson = String(data: data, encoding: .utf8) {
            print("Raw JSON Response: \(rawJson)")
        }
        
        // Check for successful HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FError.invalidResponse
        }
        
        // Decode JSON data into FoodInfo object
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(FoodInfo.self, from: data)
        } catch {
            print("Decoding Error: \(error)")
            throw FError.invalidData
        }
    }
    
    // Enumeration for API-related errors
    enum FError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
}
