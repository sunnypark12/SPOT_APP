//
//  Challenge.swift
//  SPOT_F
//
//  Created by 선호 on 7/3/24.
//

import Foundation
import SwiftUI
struct Challenge: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let hostRestaurant: String
    let deadline: String
    let prize: String
    let imageName: String
    var isJoined: Bool = false
}

let sampleChallenges = [
    Challenge(name: "Spicy Food Challenge", description: "Can you handle the heat?", hostRestaurant: "Hot & Spicy", deadline: "30 days left", prize: "$100.00", imageName: "spicy_food"),
    Challenge(name: "Sushi Challenge", description: "Who can eat the most sushi?", hostRestaurant: "Sushi House", deadline: "30 days left", prize: "$100.00", imageName: "sushi"),
    Challenge(name: "Eating Contest", description: "Who can eat the most?", hostRestaurant: "Sunny House", deadline: "20 days left", prize: "$100.00", imageName: "sushi"),
    Challenge(name: "Taste Testing Challenge", description: "Who can eat the most sushi?", hostRestaurant: "Sushi House", deadline: "30 days left", prize: "$100.00", imageName: "sushi"),
    // Add more sample challenges here...
]

let sampleLunchMateChallenges = [
    Challenge(name: "BreakfastMate", description: "Find someone to have breakfast with!", hostRestaurant: "Breakfast House", deadline: "7:00 AM", prize: "Meeting New Friends", imageName: "breakfast"),
    Challenge(name: "LunchMate", description: "Find someone to have lunch with!", hostRestaurant: "Lunch House", deadline: "12:00 PM", prize: "Meeting New Friends", imageName: "lunch"),
    Challenge(name: "DinnerMate", description: "Find someone to have dinner with!", hostRestaurant: "Dinner House", deadline: "6:00 PM", prize: "Meeting New Friends", imageName: "dinner"),
    Challenge(name: "DessertMate", description: "Find someone to have dessert with!", hostRestaurant: "Dessert House", deadline: "8:00 PM", prize: "Meeting New Friends", imageName: "dessert")
]

