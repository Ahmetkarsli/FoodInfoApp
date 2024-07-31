//
//  ContentView.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 20.07.24.
//

import SwiftUI

struct StartView: View {
    @State private var barcodeData: String = ""
    @State private var myAllergens: [String] = []
    @StateObject private var dataController = ScannedProductDataController()
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(.white)
        tabBarAppearance.configureWithTransparentBackground()
        UITabBar.appearance().backgroundColor = UIColor(.white)
    }

    
    @State private var isShowScanner = false
    var body: some View {
        TabView {
            Tab("allergenic", systemImage: "allergens") {
                AllergensView(myAllergens: $myAllergens)
                
            }
            Tab("Scan Code", systemImage: "barcode.viewfinder") {
                ScannerView(myAllergens: $myAllergens)
                    .environmentObject(dataController)
                
            }
            Tab("scans", systemImage: "list.bullet") {
                ScannedItemView(myAllergens: $myAllergens)
                    .environmentObject(dataController)
            }
            
        }
        .background(.white)
    }
}

#Preview {
    StartView()
}



