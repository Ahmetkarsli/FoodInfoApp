//
//  DataScannerView.swift
//  FoodInfoApp
//
//  Created by Ahmet Karsli on 24.07.24.
//

import SwiftUI
import VisionKit



struct DocumentScannerView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if !uiViewController.isScanning {
            do {
                try uiViewController.startScanning()
                print("Scanning restarted successfully.")
            } catch {
                print("Failed to restart scanning: \(error)")
            }
        }
    }
    
    @Binding var foundBarCode: String
    var onScan: () -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scannerViewController = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .accurate,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true
        )
        scannerViewController.delegate = context.coordinator
        
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            do {
                try scannerViewController.startScanning()
                
                print("Scanning started successfully.")
            } catch {
                print("Failed to start scanning: \(error)")
            }
        } else {
            print("DataScannerViewController is not supported or not available.")
        }
        return scannerViewController
    }
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: DocumentScannerView
        
        init(parent: DocumentScannerView) {
            self.parent = parent
        }
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            for item in addedItems {
                getBarcode(item: item)
            }
        }
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            for item in updatedItems {
                print("Did update items: \(item)")
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            for item in removedItems {
                print("Did remove items: \(item)")
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("Scanning failed with error: \(error.localizedDescription)")
        }
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            getBarcode(item: item)
            
        }
        
        func getBarcode(item: RecognizedItem) {
            switch item {
            case .barcode(let barcode):
                parent.foundBarCode = barcode.payloadStringValue ?? ""
                parent.onScan()
                print(parent.foundBarCode)
            default:
                print("data not found.")
                break
            }
        }
    }
}
