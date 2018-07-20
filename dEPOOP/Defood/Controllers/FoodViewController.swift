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
    var restaurants: [Restaurant] = []
    var names: [String] = []
    
    @IBOutlet weak var gayAssLabel: UILabel!
    @IBOutlet weak var lesbianLabel: UILabel!

    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifier = segue.identifier else { return }
//
//        let destination = segue.destination as! TableViewController
//        destination.names = self.names
//
//    }

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
            //update restaurats array with the new restautants
            
            //reload the table view
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchPlaces(with: textField.text ?? "")
        
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
                
                let sortedRestaurantsWeWant = restaurantsWeWant.sorted(by: { (a, b) -> Bool in
                    let aDistance = a.haverDistance!
                    let bDistance = b.haverDistance!
                    
                    if bDistance > aDistance {
                        return true
                    } else {
                        return false
                    }
                })
//
//                    let firstName = sortedRestaurantsWeWant[0].name
//                    self.gayAssLabel.text = firstName
//
//                let secondName = sortedRestaurantsWeWant[1].name
//                self.lesbianLabel.text = secondName
//
              
                //call the completion with the array of restaurants
                print(sortedRestaurantsWeWant)
                completion(sortedRestaurantsWeWant)
                
                
            }
            
            var king : ([Restaurant])?{
                didSet{
            
                    UserDefaults.standard.set(restaurantsWeWant, forKey: "king")
                    UserDefaults.standard.set(restaurantsWeWant, forKey: "name")
                    UserDefaults.standard.set(restaurantsWeWant, forKey: "name")
                    self.performSegue(withIdentifier: "searchSeg", sender: self)
                }
            }
//            let nameOfRestaurant = restaurantsWeWant[0].name
//            print(nameOfRestaurant)
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            //
            //            //
            //
            //
            //            //
            //
            //            //
            //
            //            print("THESE ARE RESTYURNATS")
            //            print(restaurants)
            //
            //
            //
            //            var restaurantsThatWeWant: [Restaurant] = []
            //            for index in [0, 2, 3, 4, 5, 6, ]{
            //                let restaurant = restaurants.results[index]
            //
            //
            //                let restaurantLongitude = restaurants.results[index].geometry.location.lng
            //                let restaurantLatitude = restaurants.results[index].geometry.location.lat
            //
            //
            //                guard let userLatitude = UserDefaults.standard.value(forKey: "lat") as! Double? else{return}
            //                let userLongitude = UserDefaults.standard.value(forKey: "lon") as! Double
            //
            //                let desiredRestaurantType = restaurants.results[index].types
            //
            //                let haverDistance = self.haversineDistance(userLatitude: userLatitude, userLongitude: userLongitude, restaurantLatitude: restaurantLatitude, restaurantLongitude: restaurantLongitude)
            //
            //                if desiredRestaurantType.contains("restaurant") {
            //                    let restaurantName = restaurants.results[index].name
            //                    restaurantsThatWeWant.append([restaurantName, haverDistance])
            //                }
            //                else if desiredRestaurantType.contains("food"){
            //                    let restaurantName = restaurants.results[index].name
            //                    restaurantsThatWeWant.append([restaurantName, haverDistance])
            //                }
            //                else if desiredRestaurantType.contains("bakery"){
            //                    let restaurantName = restaurants.results[index].name
            //                    restaurantsThatWeWant.append([restaurantName, haverDistance])
            //                }
            //                else if desiredRestaurantType.contains("cafe") {
            //                    let restaurantName = restaurants.results[index].name
            //                    restaurantsThatWeWant.append([restaurantName, haverDistance])
            //                }
            //                else{
            //                    print("None found")
            //                }
            //
            //                print(restaurantsThatWeWant)
            //
            //                completion(restaurantsThatWeWant)
            //            }
            //                haversineDistance(userLatitude: Double, userLongitude: Double, restaurantLatitude: Double, restaurantLongitude: Double)
        }
        task.resume()
    }
    
    
    //            var haverDistances = [Double]()
    //
    //            for haverIndex in 0...haverDistances.count - 1 {
    //                haverDistances.append(haverDistance)
    
    
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
        
        let haverDistance = radius * ahaversin(haversin(restaurantLatitude - userLatitude) + cos(userLatitude) * cos(restaurantLatitude) * haversin(restaurantLongitude - userLongitude))
        
        return haverDistance
        
    }
}



