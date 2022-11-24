//
//  StoreKitSupport.swift
//  hangul-practice
//
//  Created by Luis Gonzalez on 23/11/22.
//

import SwiftUI
import StoreKit

enum PurchaseError: Error {
    case pending
    case failed
    case cancelled
}

class StoreKitViewModel: ObservableObject {
    @AppStorage("payedATip") var paymentSucceeded = false
    
    private(set) var products: [Product] = []
    @Published var productsAvailable = false
    
    func fetchProducts() async throws {
        let products = try await Product.products(for: ["hangul_tipjar"])
        
        self.products = products
        
        if !products.isEmpty {
            await MainActor.run { productsAvailable = true }
        }
    }
    
    func purchaseTip() {
        guard let tipProduct = products.first else { return }
        Task {
            try await self.purchase(tipProduct)
        }
    }
    
    func purchase(_ product: Product) async throws -> StoreKit.Transaction {
        let result = try await product.purchase()
        
        switch result {
        case .pending:
            throw PurchaseError.pending
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await transaction.finish()
                
                await MainActor.run { self.paymentSucceeded = true }
                
                return transaction
            case .unverified:
                throw PurchaseError.failed
            }
        case .userCancelled:
            throw PurchaseError.cancelled
        @unknown default:
            assertionFailure("Unexpected result")
            throw PurchaseError.failed
        }
    }
    
    func listenForStoreKitUpdates() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    print("Transaction verified in listener")
                    
                    await transaction.finish()
                case .unverified:
                    print("Transaction unverified")
                }
            }
        }
    }
}
