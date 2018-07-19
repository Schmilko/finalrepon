//
//  CoordinateController1.swift
//  Defood
//
//  Created by Alizandro Lopez on 7/18/18.
//  Copyright © 2018 GLWR. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class CoordinateController1: UIViewController {
    
    var location: CLLocation?
    
    @IBOutlet weak var userAddress: UITextField!
    @IBOutlet weak var friendAddress: UITextField!
    
    let geoCoder = CLGeocoder()
    
    var midpoint : (Double,Double)?{
        didSet{
            // UserDefaults.standard.set(midpoint, forKey: "midpoint")
           
            UserDefaults.standard.set(midpoint?.0, forKey: "lon")
            UserDefaults.standard.set(midpoint?.1, forKey: "lat")
            
            self.performSegue(withIdentifier: "toFood", sender: self)
    
            
            
            
            
//                        UserDefaults.standard.set(midpoint, forKey: "midpoint")
            
        }
    }
    
    
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        
        guard let address = userAddress.text else {return}
        
        convertUserAddressToCoordinates(userAddress: address) { (lon, lat) in
            
            guard let fAddress = self.friendAddress.text else {return}
            
            self.convertUserAddressToCoordinates(userAddress: fAddress, completionHandler: { (flon,flat) in
                
                DispatchQueue.main.async {

                    self.midpoint = (((flon + lon)/2), ((lat + flat)/2))
                    print(self.midpoint!)
                    print("is the midpoint")
                    
                    
                    
                }
                
            })
        }
        
    }
    
    
    func convertUserAddressToCoordinates(userAddress: String, completionHandler: @escaping  ((CLLocationDegrees,CLLocationDegrees)) -> ()) {
        
        // guard let and nil check was being weird so fix force unwrapping later
        geoCoder.geocodeAddressString(userAddress) { (placemarks, error) in
            guard let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            self.location = location
            
            let userLat = location.coordinate.latitude
            let userLong = location.coordinate.longitude
            let userCoords = (userLat, userLong)
            
            print(userCoords)
            
            completionHandler(userCoords)
            
            
            
            
        }
        
    }
    func convertFriendAddressToCoordinates() {
        // guard let and nil check was being weird so fix force unwrapping later
        geoCoder.geocodeAddressString(friendAddress.text!) { (placemarks, error) in
            guard let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            self.location = location
            
            let friendLat = location.coordinate.latitude
            let friendLong = location.coordinate.longitude
            let friendCoords = (friendLat, friendLong)
            print(friendCoords)
            // perform segue
            //            self.performSegue(withIdentifier: "toInfo", sender: self)
            
        }
        
    }
    // use prepare for segue to pass location into the next vc
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFood"{
            let destination = segue.destination as! FoodViewController
            destination.location = location
        }
    }
    //
    // idk if we need to put the outlets in this file because I cant access it so I can split this into two functions to make one for friend and user
    //   guard let userAddress.text = userAddress {
    
}

