//
//  Spot.swift
//  Snacktacular
//
//  Created by 张泽华 on 2020/4/11.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit
class Spot: NSObject, MKAnnotation{
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var longitude: CLLocationDegrees{
        return coordinate.longitude
    }
    
    var latitude: CLLocationDegrees{
        return coordinate.latitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var title: String?{
        return name
    }
    
    var subtitle: String?{
        return address
    }
    
    var dictionary: [String: Any]{
        return ["name": name, "address": address, "longitude": longitude, "latitude": latitude, "averageRating": averageRating, "numberOfReivews": numberOfReviews, "postingUserID": postingUserID]
    }
    
    init(name: String, address:String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserID: String, documenID:String){
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documenID
    }
    convenience override init(){
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documenID: "")
    }
    
    convenience init(dictionary: [String: Any]){
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longtitude = dictionary["longtitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""

        self.init(name: name, address: address, coordinate: coordinate, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documenID: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        //grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else{
            print("error: could not save data because we don't have a valid postingIserID")
           return completed(false)
        }
        self.postingUserID = postingUserID
        //create the dictionar representing the data we want to save
        let dataToSave = self.dictionary
        //if we HAVE saved a record, we'll have a documenID
        if self.documentID != ""{
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) {(error) in
                if let error = error {
                    print("error: updating document \(self.documentID)\(error.localizedDescription)")
                    completed(false)
                }else{
                    completed(true)
                }
            }
        }else{
            var ref: DocumentReference? = nil // let firestore create the new documentID
            ref = db.collection("spots").addDocument(data: dataToSave) {error in
                if let error = error {
                    print("error: creating new document \(self.documentID)\(error.localizedDescription)")
                                   completed(false)
                               }else{
                    print("new document created with the ref ID \(ref?.documentID ?? "unknown document ")")
                                   completed(true)
                    self.documentID = ref!.documentID
                    completed(true)
                               }
            }
        }
    }
    
}
