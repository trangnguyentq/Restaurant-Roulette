//
//  UserProfile.swift
//  RestaurantRoulette
//
//  Created by Labuser on 4/21/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import Foundation

class UserProfile {
    var userID: Int
    var username: String!
    var rating: Int!
    var priceRanges: [Bool]!
    var maxDistance: Double!
    var type: String!
    
    init(userID: Int, username: String, rating: Int, priceRanges: [Bool], maxDistance: Double, type: String) {
        self.userID = userID
        self.username = username
        self.rating = rating
        self.priceRanges = priceRanges
        self.maxDistance = maxDistance
        self.type = type
    }
    
    init() {
        self.userID = 0
        self.username = ""
        self.rating = 3
        self.priceRanges = [true, true, false, false]
        self.maxDistance = 5.0
        self.type = "All Restaurants"
    }
}
