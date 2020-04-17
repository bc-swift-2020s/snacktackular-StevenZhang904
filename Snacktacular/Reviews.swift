//
//  Reviews.swift
//  Snacktacular
//
//  Created by 张泽华 on 2020/4/17.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Reviews{
    var reviewArray: [Review] = []
    var db:Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()){
        guard spot.documentID != "" else{
            return
        }
        db.collection("reviews").document(spot.documentID).collection("reviews").addSnapshotListener{(querySnapshot, error) in
            guard error == nil else{
                print("Error: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.reviewArray = []
            for document in querySnapshot!.documents{
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }

}
