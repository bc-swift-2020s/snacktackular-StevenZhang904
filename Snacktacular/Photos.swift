//
//  Photos.swift
//  Snacktacular
//
//  Created by 张泽华 on 2020/4/17.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!

    init() {
        db = Firestore.firestore()
    }
}
