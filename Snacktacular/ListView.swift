//
//  ListView.swift
//  Snacktacular
//
//  Created by Jonathan Wheeler Jr. on 3/29/23.
//

import SwiftUI
import Firebase

struct ListView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        List {
            Text("List items placed here")
        }
        .listStyle(.plain)
        .navigationBarBackButtonHidden()
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
                    //too add
                } label: {
                    Image(systemName: "plus")
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
