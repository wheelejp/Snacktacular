//
//  PlaceViewModel.swift
//  PlaceLookupDemo
//
//  Created by Jonathan Wheeler Jr. on 3/29/23.
//

import Foundation
import MapKit

@MainActor
class PlaceViewModel:  ObservableObject {
    @Published var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("😡 ERROR: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.places = response.mapItems.map(Place.init)
        }
    }
}
