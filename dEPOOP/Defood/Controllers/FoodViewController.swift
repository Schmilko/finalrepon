//
//  FoodViewController.swift
//  Defood
//
//  Created by Alizandro Lopez on 7/18/18.
//  Copyright © 2018 GLWR. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation
import Swift


//struct UserService {
//    func getLad() -> Double {
//        return
//    }
//
//    func setLad(value: Double) {
//
//    }
//}

class FoodViewController: UIViewController, UITextFieldDelegate {
    
    var location: CLLocation?
    @IBOutlet weak var pickingFoodTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(location)
        var restaurantType = pickingFoodTextField.text
        pickingFoodTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func fetchPlaces(with searchTerm: String) {
        
        searchPlaceFromGoogle(place: searchTerm) { (restaurants) in
            
            //update restaurant array with the new restaurants
      
            
            
            //reload the table view
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchPlaces(with: textField.text ?? "")
        
        return true
    }
    
    func searchPlaceFromGoogle(place: String, completion: @escaping ([Restaurant]) -> () ) {
        
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place)&key=AIzaSyBiw2dOmiz1teJDJ7xjxeSJykFuSzibu2g"
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,
            response, error) in
            
            guard let data = data else {return}
            
            //decodes the json into RestuarantResult
            let restaurantResult = try! JSONDecoder().decode(RestaurantResults.self, from: data)
            
            //get the array of restuarants from RestuarantResult.result
            let restaurants = restaurantResult.results
            
            var restaurantsWeWant: [Restaurant] = []
            
            //for each restuarant
            for aRestaurant in restaurants {
                
                //filter the restuarant to check if it's the type we want
                let desiredRestaurantType = aRestaurant.types
                if desiredRestaurantType.contains("restaurant") || desiredRestaurantType.contains("food") || desiredRestaurantType.contains("bakery") || desiredRestaurantType.contains("cafe") {
                    
                    //find the distance using the haverDistance function
                    let restaurantLongitude = aRestaurant.geometry.location.lng
                    let restaurantLatitude = aRestaurant.geometry.location.lat
                    
                    guard let userLatitude = UserDefaults.standard.value(forKey: "lat") as! Double? else{return}
                    let userLongitude = UserDefaults.standard.value(forKey: "lon") as! Double
                    
                    let haverDistance = self.haversineDistance(userLatitude: userLatitude, userLongitude: userLongitude, restaurantLatitude: restaurantLatitude, restaurantLongitude: restaurantLongitude)
                    
                    //append the restaurant into the array
                    var copiedRestaurant = aRestaurant
                    copiedRestaurant.haverDistance = haverDistance
                    
                    restaurantsWeWant.append(copiedRestaurant)
                } else {
                    //skip aRestaurant since it's not either of the types we want
                }
                
            }
            
            //call the completion with the array of restaurants
            completion(restaurantsWeWant)
            print(restaurantsWeWant)

        }
        task.resume()
    }
    

    
    
    func haversineDistance(userLatitude: Double, userLongitude: Double, restaurantLatitude: Double, restaurantLongitude: Double) -> Double {
        
        let radius: Double = 6367444.7
        let haversin = { (angle: Double) -> Double in
            return (1 - cos(angle))/2
        }
        
        let ahaversin = { (angle: Double) -> Double in
            return 2*asin(sqrt(angle))
        }
        
        // Converts from degrees to radians
        let dToR = { (angle: Double) -> Double in
            return (angle / 360) * 2 * Double.pi
        }
        
        let userLatitude = dToR(userLatitude)
        let userLongitude = dToR(userLongitude)
        let restaurantLatitude = dToR(restaurantLatitude)
        let restaurantLongitude = dToR(restaurantLongitude)
        
        print("haver Test")
        let haverDistance = radius * ahaversin(haversin(restaurantLatitude - userLatitude) + cos(userLatitude) * cos(restaurantLatitude) * haversin(restaurantLongitude - userLongitude))
        
        return haverDistance
        
    }
}


