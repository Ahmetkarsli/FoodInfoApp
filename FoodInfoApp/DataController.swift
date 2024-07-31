//
//  DataController.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 26.07.24.
//

import Foundation

class ScannedProductDataController: ObservableObject {
    @Published var products: [ScannedProduct] = []
    private let fileName = "scannedProducts.json"
    
    init() {
        loadProducts()
    }
    
    func addProduct(code: String, product_name: String, brand: String, imageURL: String, allergens: String) {
        let newProduct = ScannedProduct(code: code, product_name: product_name, brand: brand, imageURL: imageURL, allergens: allergens)
            products.append(newProduct)
            saveProducts()
    }
    
    func deleteProduct(at offsets: IndexSet) {
        products.remove(atOffsets: offsets)
        saveProducts()
    }
    private func productExists(code: String) -> Bool {
            return products.contains { $0.code == code }
        }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func getFileURL() -> URL {
        getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    private func loadProducts() {
        let fileURL = getFileURL()
        guard let data = try? Data(contentsOf: fileURL) else { return }
        let decoder = JSONDecoder()
        if let decodedProducts = try? decoder.decode([ScannedProduct].self, from: data) {
            products = decodedProducts
        }
    }
    
    private func saveProducts() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(products) {
            try? data.write(to: getFileURL())
        }
    }
}
