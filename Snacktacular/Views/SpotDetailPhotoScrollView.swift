//
//  SpotDetailPhotoScrollView.swift
//  Snacktacular
//
//  Created by Jonathan Wheeler Jr. on 4/10/23.
//

import SwiftUI

struct SpotDetailPhotoScrollView: View {
//    struct FakePhoto: Identifiable {
//        let id = UUID().uuidString
//        var imageURLString = "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-23f5c.appspot.com/o/BYvALSeQY84QB9euFcQR%2FBA84F0C6-B3AF-4450-A27F-EBF019813C3E.jpeg?alt=media&token=113a1c9f-5b43-47f0-a275-1870abbc48ac"
//    }
//
//    let photos = [FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto()]
    
    var photos: [Photo]
    var spot: Spot
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack (spacing: 4) {
                ForEach(photos) { photo in
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
    }
}

struct SpotDetailPhotoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SpotDetailPhotoScrollView(photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-23f5c.appspot.com/o/BYvALSeQY84QB9euFcQR%2FBA84F0C6-B3AF-4450-A27F-EBF019813C3E.jpeg?alt=media&token=113a1c9f-5b43-47f0-a275-1870abbc48ac")], spot: Spot(id: "BYvALSeQY84QB9euFcQR"))
    }
}
