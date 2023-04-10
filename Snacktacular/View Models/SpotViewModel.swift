//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Jonathan Wheeler Jr. on 3/29/23.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor

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
                let documentRef = try await db.collection("spots").addDocument(data: spot.dictionary)
                self.spot = spot
                self.spot.id = documentRef.documentID
                print("Data added successfully!🐣")
                return true 
            } catch {
                print("ERROR: COuld not create new data in 'spots'😡 \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func saveImage(spot: Spot, photo: Photo, image: UIImage) async -> Bool {
        guard let spotID = spot.id else {
            print("ERROR: spot.id == nil")
            return false
        }
        
        let photoName = UUID().uuidString // name of the image file
        let storage = Storage.storage() // creates a firebase Storage instance
        let storageRef = storage.reference().child("\(spotID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("ERROR: Could not resize image")
            return false
        }
        
        let metaData = StorageMetadata()
        metaData.contentType =  "image/jpg" //setting metadata like this allowws you to see console image in browser
        
        var imageURLString = "" // we'll set this after the image is successfully saved
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metaData)
            print("📸 Image Saved")
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)" // we'll save this to cloud firestore as part of the documents below
            } catch {
                print("ERROR: Could not get imageURL, \(error.localizedDescription)")
                return false
            }
        } catch {
            print("ERROR: Uploading image to firebase storage")
            return false
        }
        // need to save a document into the "photos" collection of the spot document "spotID"
        let db = Firestore.firestore()
        let collectionString = "spots/\(spotID)/photos"
        
        do {
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
            print("Data updated successfully")
            return true
        } catch {
            print("ERROR: Could not update data in 'photos' for spotID \(spotID)")
            return false
        }
         
    }
}
