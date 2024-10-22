//
//  Restaurant.swift
//  SPOT_F
//
//  Created by 선호 on 7/1/24.
//

import Foundation
import MapKit
import SwiftUI

//struct Restaurant: Identifiable {
//    let id = UUID()
//    let name: String
//    let iconName: String
//    let location: CLLocationCoordinate2D
//}

enum Badge: String {
    case figureRoll = "figure.roll"
    case carFill = "car.fill"
    case shieldLeftHalfFilled = "shield.lefthalf.filled"
    case ear = "ear"
    case eyeFill = "eye.fill"
    
    var image: Image {
        Image(systemName: self.rawValue)
    }
    
    var backgroundColor: Color {
        switch self {
        case .figureRoll:
            return .green
        case .carFill:
            return .blue
        case .shieldLeftHalfFilled:
            return .red
        case .ear:
            return .yellow
        case .eyeFill:
            return .gray
        }
    }
}

struct Restaurant: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
    let badge: Badge?
}

