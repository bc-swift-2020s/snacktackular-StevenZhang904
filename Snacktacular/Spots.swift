//
//  Spots.swift
//  Snacktacular
//
//  Created by 张泽华 on 2020/4/11.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Spots{
    var spotArray = [Spot]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("spots").addSnapshotListener{(querySnapshot, error) in
            guard error == nil else{
                print("Error: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.spotArray = []
            for document in querySnapshot!.documents{
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
            }
            completed()
        }
    }
}
