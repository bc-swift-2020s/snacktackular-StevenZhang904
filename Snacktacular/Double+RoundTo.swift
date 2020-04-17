//
//  Double+RoundTo.swift
//  Snacktacular
//
//  Created by 张泽华 on 2020/4/15.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation

// round any double to places

extension Double{
    func roundTo(places: Int) -> Double{
        let tenToPower = pow(10.0, Double( (places >= 0 ? places: 0 ) ))
        let roundedValue = (self * tenToPower).rounded() / tenToPower
        return roundedValue
    }
}
