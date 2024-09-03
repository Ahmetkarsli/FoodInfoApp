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
    @State private var selectedTab: Int = 0

    
    init() {
        TabBarTransparent() // Set transparent background at the start view is ScannerView
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScannerView(barcodeData: barcodeData, myAllergens: $myAllergens)
                .environmentObject(dataController)
                .tabItem {
                    Label("Scan Code", systemImage: "barcode.viewfinder")
                }
                .tag(0)
            
            ScannedItemView(myAllergens: $myAllergens)
                .environmentObject(dataController)
                .tabItem {
                    Label("Scans", systemImage: "list.bullet")
                }
                .tag(1)
            
            AllergensView(myAllergens: $myAllergens)
                .tabItem {
                    Label("Allergenic", systemImage: "allergens")
                }
                .tag(2)
        }
        .onChange(of: selectedTab, { oldValue, newValue in
            print("Old Value: \(oldValue), New Value: \(newValue)")
            if newValue == 0 {
                TabBarTransparent()
            } else {
                TabBarWhiteBackground()
            }
        })
    }
}

private func TabBarTransparent() {
    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithTransparentBackground()
    tabBarAppearance.backgroundColor = UIColor.clear
    UITabBar.appearance().standardAppearance = tabBarAppearance
    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
}

private func TabBarWhiteBackground() {
    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithOpaqueBackground()
    tabBarAppearance.backgroundColor = UIColor.white
    UITabBar.appearance().standardAppearance = tabBarAppearance
    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
}

#Preview {
    StartView()
}
