//
//  Model.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 26.07.24.
//

import Foundation

struct ScannedProduct: Identifiable, Codable {
    var id: UUID
    var product_name: String
    var code: String
    var dateScanned: Date
    var brand: String
    var imageURL: String
    var allergens: String
    
    init(code: String, product_name: String, brand: String, imageURL: String, allergens: String) {
        self.id = UUID()
        self.code = code
        self.product_name = product_name
        self.dateScanned = Date()
        self.brand = brand
        self.imageURL = imageURL
        self.allergens = allergens
    }
}

