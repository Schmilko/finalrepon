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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPlaceFromGoogle(place: textField.text!) { (restaurant) in
            print(restaurant)
        }
        return true
    }
    
    
    
    func searchPlaceFromGoogle(place: String, completion: @escaping (RestaurantResults) -> () ){
        
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place)&key=AIzaSyBiw2dOmiz1teJDJ7xjxeSJykFuSzibu2g"
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,
            response, error) in
      
            
            guard let data = data else {return}
            
            let restaurants = try! JSONDecoder().decode(RestaurantResults.self, from: data)
            completion(restaurants)
        }
        task.resume()
    }
    
    func calculateDistance(place: String) {
  
        
//                let userLatitude = UserDefaults.standard.value(forKey: "lat") as! Double
//                let userLongitude = UserDefaults.standard.value(forKey: "lon") as! Double
                

    
    }
    

}
