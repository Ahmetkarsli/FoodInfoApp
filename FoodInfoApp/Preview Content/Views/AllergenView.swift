//
//  AllergenView.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 24.07.24.
//

import SwiftUI

struct AllergensView: View {
    @Binding var myAllergens: [String]
    var allergens: [String: String] = [
            "Cereals containing gluten": "Gluten", // Getreide mit Gluten (z.B. Weizen, Roggen, Gerste, Hafer)
            "Crustaceans": "Crustaceans", // Krustentiere
            "Eggs": "Egg", // Eier
            "Fish": "Fish", // Fisch
            "Peanuts": "Peanuts", // Erdnüsse
            "Soybeans": "Soybeans", // Sojabohnen
            "Milk": "Milk", // Milch
            "Nuts": "Nuts", // Nüsse (z.B. Haselnüsse, Walnüsse, Mandeln)
            "Celery": "Celery", // Sellerie
            "Mustard": "Mustard", // Senf
            "Sesame seeds": "Sesame", // Sesam
            "Sulphur dioxide and sulphites": "chemical", // Schwefeldioxid und Sulfite
            "Lupin": "Lupine", // Lupine
            "Molluscs": "shellfish" // Weichtiere
        ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            Text("Choose your allergens:")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allergens.keys.sorted(), id: \.self) { allergen in
                        Button(action: {
                            if myAllergens.contains(allergen) {
                                myAllergens.removeAll { $0 == allergen }
                            } else {
                                myAllergens.append(allergen)
                            }
                        }) {
                            VStack {
                                // Try to load the image from the asset catalog, otherwise use a SF Symbol
                                if let imageName = allergens[allergen],
                                   let uiImage = UIImage(named: imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .padding(8)
                                } else {
                                    Image(systemName: "questionmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .padding(8)
                                }
                                
                                Text(allergen)
                                    .fontWeight(.medium)
                                    .padding(5)
                                    .bold()
                            }
                            .frame(width: 150, height: 150)
                            .background(myAllergens.contains(allergen) ? .red : .gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            .foregroundColor(myAllergens.contains(allergen) ? .white : .black)
                            .padding(4)
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var myAllergens = ["Dairy", "Eggs", "Peanuts"]
    return AllergensView(myAllergens: $myAllergens)
}
