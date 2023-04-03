//
//  ReviewViewModel.swift
//  Snacktacular
//
//  Created by Jonathan Wheeler Jr. on 4/3/23.
//

import SwiftUI
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func saveReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()
        
        let collectionString = "spots/\(spot.id ?? "")/reviews"
        
        if let id = review.id {
            do {
                try await db.collection(collectionString).document(id).setData(review.dictionary)
                print("Data updated successfully! 😎")
                return true
            } catch {
                print("ERROR: Data could not be updated in 'reviews'😡 \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection(collectionString).addDocument(data: review.dictionary)
                print("Data added successfully!🐣")
                return true
            } catch {
                print("ERROR: COuld not create new data in 'reviews'😡 \(error.localizedDescription)")
                return false
            }
        }
    }
}
