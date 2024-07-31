//
//  FoodInfoView.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 26.07.24.
//

import SwiftUI

struct FoodInfoView: View {
    @Binding var barcodeData: String
    @StateObject private var foodAPI = FoodAPI() // Use StateObject for managing FoodAPI
    @State private var food: FoodInfo? // Store fetched food info
    @Binding var myAllergens: [String]
    @State var isAllergic: Bool = false
    @State private var showAlert: Bool = false
    @EnvironmentObject var dataController: ScannedProductDataController
    var shouldSave: Bool
    
    var body: some View {
        VStack {
            if let food = food {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            if let brands = food.product.brands {
                                if !brands.contains(food.product.product_name) {
                                    Text(brands)
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                            } // show brand if exists
                            Text(food.product.product_name.isEmpty ? "No Product Name Available": food.product.product_name)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        AsyncImage(url: URL(string: food.product.image_front_url)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        .frame(maxWidth: .infinity, maxHeight: 180)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        
                        Text("Product Code:")
                            .font(.headline)
                            .padding(.top, 1)
                        Text(food.code.isEmpty ? "N/A": food.code)
                            .font(.body)
                            .padding(.bottom, 1)
                        
                        Text("Allergens:")
                            .font(.headline)
                            .padding(.top, 1)
                        Text(food.product.allergens_from_user.isEmpty ? "N/A" : food.product.allergens_from_user)
                            .font(.body)
                            .padding(.bottom, 1)
                        
                        Text("Ingredients:")
                            .font(.headline)
                            .padding(.top, 1)
                        if let ingredients = food.product.ingredients_text_en {
                            Text(ingredients)
                                .font(.body)
                                .padding(.bottom, 1)
                        } else if let ingredients = food.product.ingredients_text_de {
                            Text(ingredients)
                                .font(.body)
                                .padding(.bottom, 1)
                        } else {
                            Text("Ingredients information not available")
                                .font(.body)
                                .padding(.bottom, 1)
                        }
                        VStack(alignment: .leading) {
                            Text("Nutritional Information")
                                .font(.headline)
                                .padding(.bottom, 1)
                            
                            ForEach(food.product.nutriments.allNutrients, id: \.name) { nutrient in
                                HStack {
                                    Text(nutrient.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    if nutrient.name == "Energy" {
                                        VStack(alignment: .trailing) {
                                            Text("\(nutrient.value, specifier: "%.1f") kJ")
                                            Text("\(nutrient.value * 0.2388, specifier: "%.1f") kcal")
                                        }
                                    } else {
                                        Text("\(nutrient.value, specifier: "%.1f") g")
                                    }
                                }
                                .font(.body)
                                Divider()
                            }
                        }
                        .padding(.bottom, 5)
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
        }
        .alert(isPresented: $showAlert) {
            if isAllergic {
                Alert(
                    title: Text("Allergens detected!"),
                    message: Text("This product contains allergens you are sensitive to. Please avoid it."),
                    dismissButton: .default(Text("OK"))
                )
            } else {
                Alert(
                    title: Text("Allergens not detected!"),
                    message: Text("No allergens detected in this product. Enjoy!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .background(isAllergic ? Color.red.opacity(0.3) : Color.green.opacity(0.3))
        .onAppear {
            loadFoodInfo()
        }
    }
    private func loadFoodInfo() {
        Task {
            do {
                food = try await foodAPI.getProduct(barcode: barcodeData)
                isAllergic = checkAllergens()
                showAlert = true
                if shouldSave {
                    dataController.addProduct(code: barcodeData, product_name: food?.product.product_name ?? "Unknown", brand: food?.product.brands ?? "Unknown", imageURL: food?.product.image_front_url ?? "", allergens: food?.product.allergens_from_user ?? "")
                }
            } catch FoodAPI.FError.invalidURL {
                print("Invalid URL")
            } catch FoodAPI.FError.invalidResponse {
                print("Invalid response")
            } catch FoodAPI.FError.invalidData {
                print("Invalid data")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    private func checkAllergens() -> Bool {
        guard let food = food else {
            return false
        }
        return myAllergens.contains { allergen in
            food.product.allergens_from_user.lowercased().contains(allergen.lowercased())
        }
    }
}

