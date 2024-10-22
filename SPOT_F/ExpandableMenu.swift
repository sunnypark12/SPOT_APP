//
//  ExpandableMenu.swift
//  SPOT_F
//
//  Created by 선호 on 7/13/24.
//


import SwiftUI

struct ExpandableMenu: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.4))
                .frame(width: 400, height: 100)
                .offset(y: 50)
            
            if isExpanded {
                NavigationLink(destination: ChallengesListView()) {
                    CircleBut(icon: "star.fill")
                }
                .offset(x: -100, y: -10)
                
                NavigationLink(destination: MapView()) {
                    CircleBut(icon: "map.fill")
                }
                .offset(x: -45, y: -80)
                
                NavigationLink(destination: ProfileView()) {
                    CircleBut(icon: "person.fill")
                    
                }
                .offset(x: 100, y: -10)
                
                NavigationLink(destination: UploadView()) {
                    CircleBut(icon: "camera.fill")
                    
                }
                .offset(x: 45, y: -80)
            }
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image("Smiley_Face_Yellow")
                    .resizable()
                    .frame(width: 70, height: 70)
            }
        }
        .offset(y: 15)
        .frame(height: 70)
    }
}


#Preview {
    ExpandableMenu(isExpanded: .constant(false))
}

