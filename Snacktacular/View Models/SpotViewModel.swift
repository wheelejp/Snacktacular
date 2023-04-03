//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Jonathan Wheeler Jr. on 3/29/23.
//

import Foundation
import FirebaseFirestore

class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    func saveSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = spot.id {
            do {
                try await db.collection("spots").document(id).setData(spot.dictionary)
                print("Data updated successfully! 😎")
                return true
            } catch {
                print("ERROR: Data could not be updated in 'spots'😡 \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection("spots").addDocument(data: spot.dictionary)
                print("Data added successfully!🐣")
                return true 
            } catch {
                print("ERROR: COuld not create new data in 'spots'😡 \(error.localizedDescription)")
                return false
            }
        }
    }
}