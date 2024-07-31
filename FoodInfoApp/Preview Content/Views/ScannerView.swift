//
//  ScannerView.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 26.07.24.
//

import SwiftUI

struct ScannerView: View {
    @State private var errorMessage: String?
    @State var barcodeData: String = "3017620422003" // Barcode for Nutella
    @State private var isScanned: Bool = false
    @Binding var myAllergens: [String]

    var body: some View {
        VStack {
            Text("Scan the Barcode")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 10)

            // Scanner view with a border and shadow
            DocumentScannerView(foundBarCode: $barcodeData, onScan: scan)
                .frame(width: .infinity, height: 300)  // Adjusted height
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()

            // Display recognized barcode with a custom style
            VStack(alignment: .leading, spacing: 10) {
                Text("last recognized Barcode:")
                    .font(.headline)
                    .padding(.bottom, 5)

                Text(barcodeData)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            // Button to show product info
            Button(action: {
                if !barcodeData.isEmpty {
                    isScanned = true
                }
            }) {
                Text("Show Product Info")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $isScanned, onDismiss: didDismiss) {
            ZStack {
                FoodInfoView(barcodeData: $barcodeData, myAllergens: $myAllergens, shouldSave: true)
                    .ignoresSafeArea(.all)
            }
        }
        .padding(.horizontal)
    }

    func scan() {
        if !barcodeData.isEmpty {
            isScanned = true
        }
    }

    func didDismiss() {
        // Optionally clear barcodeData or other state if needed
        isScanned = false
    }
}

#Preview {
    ScannerView(myAllergens: .constant([]))
}
