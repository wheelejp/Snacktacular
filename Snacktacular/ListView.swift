//
//  ListView.swift
//  Snacktacular
//
//  Created by Jonathan Wheeler Jr. on 3/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List(spots) { spot in
                NavigationLink {
                    SpotDetailView(spot: spot)
                } label: {
                    Text(spot.name)
                        .font(.title2)
                }
                
            }
            .listStyle(.plain)
            .navigationBarTitle("Snack Spots")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        //signout
                        do {
                            try Auth.auth().signOut()
                            print("🪵 Log out successful")
                            dismiss()
                        } catch {
                            print("ERROR:  Could not sign out 😡")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SpotDetailView(spot: Spot())
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListView()
        }
    }
}
