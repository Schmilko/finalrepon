//
//  Restaurantresults.swift
//  Defood
//
//  Created by Arun Rau on 7/19/18.
//  Copyright © 2018 GLWR. All rights reserved.
//

import Foundation

struct RestaurantResults: Decodable {
    let results: [Restaurant]
}
struct Restaurant: Decodable {
    let formatted_address: String
    let icon: String
    let name: String
    let rating: Double
    let geometry: GeoLocation
    let types: [String]
    var haverDistance: Double! = nil
}



struct RestaurantLocation: Decodable {
    let lat: Double
    let lng: Double
    
}

struct OpeningHours: Decodable {
    let opening_hours: Bool
}

struct GeoLocation: Decodable{
    let location: RestaurantLocation
}




