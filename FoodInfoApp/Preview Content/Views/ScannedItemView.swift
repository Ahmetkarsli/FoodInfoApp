//
//  ScannedItemView.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 20.07.24.
//

import SwiftUI

struct ScannedItemView: View {
    
    @EnvironmentObject var dataController: ScannedProductDataController
    @Binding var myAllergens: [String]
    @State private var searchScannedProduct = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProducts) { product in
                    NavigationLink(destination: FoodInfoView(
                        barcodeData: .constant(product.code),
                        myAllergens: $myAllergens,
                        shouldSave: false)
                        .environmentObject(dataController)) {
                            HStack {
                                // Product Image
                                if let url = URL(string: product.imageURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    } placeholder: {
                                        Rectangle()
                                            .foregroundColor(.gray.opacity(0.3))
                                            .frame(width: 80, height: 80)
                                    }
                                } else {
                                    Rectangle()
                                        .foregroundColor(.gray.opacity(0.3))
                                        .frame(width: 80, height: 80)
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(product.brand)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                    Text(product.product_name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Code: \(product.code)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Scanned on: \(product.dateScanned, formatter: itemFormatter)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                }
                .onDelete(perform: dataController.deleteProduct)
            }
            .navigationTitle("Scanned Items")
            .toolbar {
                EditButton()
            }
        }
        .searchable(text: $searchScannedProduct)
    }
    
    private var filteredProducts: [ScannedProduct] {
        let filtered = searchScannedProduct.isEmpty ?
            dataController.products :
            dataController.products.filter { $0.product_name.contains(searchScannedProduct) }
        
        return filtered.sorted { $0.dateScanned > $1.dateScanned }
    }

}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    @Previewable @State var myAllergens = ["Eggs", "Milk", "Peanuts"]
    return ScannedItemView(myAllergens: $myAllergens)
        .environmentObject(ScannedProductDataController())
}
