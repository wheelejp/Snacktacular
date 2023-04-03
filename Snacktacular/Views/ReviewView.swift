//
//  ReviewView.swift
//  Snacktacular
//
//  Created by Jonathan Wheeler Jr. on 4/3/23.
//

import SwiftUI

struct ReviewView: View {
    @State var spot: Spot
    @State var review: Review
    @StateObject var reviewVM = ReviewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(spot.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                .lineLimit(1)
                Text(spot.address)
                    .padding(.bottom )
            }
            .padding(.horizontal )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Click to Rate")
                .font(.title2)
                .bold()
            HStack {
                StarsSelectionView(rating: $review.rating)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("Review Title:")
                    .bold()
                
                TextField("title", text: $review.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                
                Text("Review")
                
                TextField("review", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .padding(.horizontal)
            .font(.title2)
            
            Spacer()
            
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Save") {
                    Task {
                        let success = await reviewVM.saveReview(spot: spot, review: review)
                        if success {
                            
                            dismiss()
                        } else {
                           print("😡ERROR saving data in review view")
                        }
                    }
                }
            }

        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReviewView(spot: Spot(name: "Shake Shack", address: "Boylston Street"), review: Review())
        }
    }
}
