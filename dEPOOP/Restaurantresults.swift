//
//  Restaurantresults.swift
//  Defood
//
//  Created by Arun Rau on 7/19/18.
//  Copyright © 2018 GLWR. All rights reserved.
//

import Foundation

struct Restaurant: Decodable {
    let formatted_address: String
    let icon: String
    let name: String
    let rating: Double
    let geometry: GeoLocation
    //let opening_hours: OpeningHours
    let types: [String]
    
}

struct RestaurantLocation: Decodable {
    let lat: Double
    let lng: Double
    
}

struct OpeningHours: Decodable {
    let opening_hours: Bool
}

struct RestaurantResults: Decodable {
    let results: [Restaurant]
    let next_page_token: String
}

struct GeoLocation: Decodable{
    let location: RestaurantLocation
}




