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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPlaceFromGoogle(place: textField.text!) { (restaurant) in
            print(restaurant)
        }
        return true
    }
    
//    func haversineDistance(userLatitude: Double, userLongitude: Double, restaurantLatitude: Double, restaurantLongitude: Double, radius: Double = 6367444.7) -> Double {
//
//        let haversin = { (angle: Double) -> Double in
//            return (1 - cos(angle))/2
//        }
//
//        let ahaversin = { (angle: Double) -> Double in
//            return 2*asin(sqrt(angle))
//        }
//
//        // Converts from degrees to radians
//        let dToR = { (angle: Double) -> Double in
//            return (angle / 360) * 2 * Double.pi
//        }
//
//        let userLatitude = dToR(userLatitude)
//        let userLongitude = dToR(userLongitude)
//        let restaurantLatitude = dToR(restaurantLatitude)
//        let restaurantLongitude = dToR(restaurantLongitude)
//
//        print("haver Test")
//        let haverDistance = radius * ahaversin(haversin(restaurantLatitude - userLatitude) + cos(userLatitude) * cos(restaurantLatitude) * haversin(restaurantLongitude - userLongitude))
//
//
//
//
//
//
//
//
//        return haverDistance
//
//    }
    
    
    func searchPlaceFromGoogle(place: String, completion: @escaping (RestaurantResults) -> () ){
        
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place)&key=AIzaSyBiw2dOmiz1teJDJ7xjxeSJykFuSzibu2g"
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,
            response, error) in
            
            
            guard let data = data else {return}
            
            let restaurants = try! JSONDecoder().decode(RestaurantResults.self, from: data)
            completion(restaurants)
            //
            
            
            
            for index in 0...restaurants.results.count - 1 {
                //                var index = 0
                //                index += 1
                let restaurantLongitude = restaurants.results[index].geometry.location.lng
                let restaurantLatitude = restaurants.results[index].geometry.location.lat
                
                guard let userLatitude = UserDefaults.standard.value(forKey: "lat") as! Double? else{return}
                let userLongitude = UserDefaults.standard.value(forKey: "lon") as! Double
                
                let radius: Double = 6367444.7
//                print(haversineDistance(userLatitude: userLatitude, userLongitude: userLongitude, restaurantLatitude: restaurantLatitude, restaurantLongitude: restaurantLongitude, radius: radius))
//
            }
            
            
            var restaurantsThatWeWant = [[]]
            for newIndex in 0...restaurants.results.count - 1{
                
                var desiredRestaurantType = restaurants.results[newIndex].types
        
                func haversineDistance(userLatitude: Double, userLongitude: Double, restaurantLatitude: Double, restaurantLongitude: Double, radius: Double = 6367444.7) -> Double {
                    
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
                
                if desiredRestaurantType.contains("restaurant") {
                    let restaurantName = restaurants.results[newIndex].name
                    restaurantsThatWeWant.append([restaurantName, haverDistance])
                }
                else if desiredRestaurantType.contains("food"){
                    let restaurantName = restaurants.results[newIndex].name
                    restaurantsThatWeWant.append([restaurantName, haverDistance])
                }
                else if desiredRestaurantType.contains("bakery"){
                    let restaurantName = restaurants.results[newIndex].name
                    restaurantsThatWeWant.append([restaurantName, haverDistance])
                }
                else if desiredRestaurantType.contains("cafe"){
                    let restaurantName = restaurants.results[newIndex].name
                    restaurantsThatWeWant.append([restaurantName, haverDistance])
                }
                else{
                    print("None found")
                }

            print(restaurantsThatWeWant)
                    print(haverDistance)
                return haverDistance
            }
//                haversineDistance(userLatitude: Double, userLongitude: Double, restaurantLatitude: Double, restaurantLongitude: Double)
                }
               
            }
            
            
            
//            var haverDistances = [Double]()
//
//            for haverIndex in 0...haverDistances.count - 1 {
//                haverDistances.append(haverDistance)
//            }
        task.resume()

        }
    }
    
    
    
    
    
    

