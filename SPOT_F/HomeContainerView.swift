//
//  HomeContainerView.swift
//  SPOT_F
//
//  Created by 선호 on 7/1/24.
//

import SwiftUI

struct HomeContainerView: View {
    @State private var isExpanded = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 1.0, green: 0.776, blue: 0.0), Color(red: 0.835, green: 0.4, blue: 0.086)]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        // Four circles
                        if isExpanded {
                            CircleB(icon: "house.fill", destination: AnyView(HomeView()))
                                .offset(y: -125)
                            CircleB(icon: "map.fill", destination: AnyView(MapView()))
                                .offset(x: -125)
                            CircleB(icon: "star.fill", destination: AnyView(ChallengesListView()))
                                .offset(x: 125)
                            CircleB(icon: "person.fill", destination: AnyView(ProfileView()))
                                .offset(y: 125)
                        }
                        
                        // Smiley face button
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            Image("Smiley_Face")
                                .resizable()
                                .frame(width: 55, height: 55)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct CircleB: View {
    var icon: String
    var destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 100, height: 100)
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.system(size: 40))
            }
        }
    }
}

struct HomeContainerView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContainerView()
    }
}
