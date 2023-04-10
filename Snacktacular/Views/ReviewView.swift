//
//  ReviewView.swift
//  Snacktacular
//
//  Created by Jonathan Wheeler Jr. on 4/3/23.
//

import SwiftUI
import Firebase

struct ReviewView: View {
    @StateObject var reviewVM = ReviewViewModel()
    @State var spot: Spot
    @State var review: Review
    @State var postedByThisUser = false
    @State var rateOrReviewString = "Click to Rate:" //otherwise will say poster's email
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
            
            Text(rateOrReviewString)
                .font(postedByThisUser ? .title2 : .subheadline)
                .bold(postedByThisUser)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal)
            HStack {
                StarsSelectionView(rating: $review.rating)
                    .disabled(!postedByThisUser) //disable if not posted by this user
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0)
                    }
            }
            .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("Review Title:")
                    .bold()
                
                TextField("title", text: $review.title)
                    .padding(.horizontal, 6)
                     .overlay {
                        RoundedRectangle(cornerRadius: 5)
                             .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                    }
                
                Text("Review")
                
                TextField("review", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                    }
            }
            .disabled(!postedByThisUser)
            .padding(.horizontal)
            .font(.title2)
            
            Spacer()
            
        }
        .onAppear {
            if review.reviewer == Auth.auth().currentUser?.email {
                postedByThisUser = true
            } else {
                let reviewPostedOn = review.postedOn.formatted(date: .numeric, time: .omitted)
                rateOrReviewString = "by: \(review.reviewer) on: \(reviewPostedOn)"
            }
        }
        .navigationBarHidden(postedByThisUser)
        .toolbar {
            if postedByThisUser {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
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
                if review.id != nil {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        
                        Button {
                            Task {
                                let success = await  reviewVM.deleteReview(spot: spot, review: review)
                                if success {
                                    dismiss()
                                }
                            }
                            
                        } label: {
                            Image(systemName: "trash")
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
