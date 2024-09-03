//
//  ScannerView.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 26.07.24.
//

import SwiftUI


struct ScannerView: View {
    @State private var errorMessage: String?
    @State var barcodeData: String // Barcode for Nutella
    @State private var isScanned: Bool = false
    @Binding var myAllergens: [String]

    var body: some View {
        ZStack {
            DocumentScannerView(foundBarCode: $barcodeData, onScan: scan)
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                if barcodeData != "" {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("last recognized Barcode:")
                            .font(.headline)
                            .padding(.bottom, 5)
                            .foregroundStyle(.white)
                        
                        Text(barcodeData)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .background(.white)
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
            }
        }
        .sheet(isPresented: $isScanned, onDismiss: didDismiss) {
            ZStack {
                FoodInfoView(barcodeData: $barcodeData, myAllergens: $myAllergens, shouldSave: true)
                    .ignoresSafeArea(.all)
            }
        }
        //.padding(.horizontal)
    }

    func scan() {
        if !barcodeData.isEmpty {
            isScanned = true
        }
    }

    func didDismiss() {
        isScanned = false
    }
}

#Preview {
    ScannerView(barcodeData: "3017620422003", myAllergens: .constant([]))
}
