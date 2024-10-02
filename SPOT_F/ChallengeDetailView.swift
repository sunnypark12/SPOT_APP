//
//  ChallengeDetailView.swift
//  SPOT_F
//
//  Created by 선호 on 7/3/24.
//

import SwiftUI

struct ChallengeDetailView: View {
    @State private var showConfirmation = false
    @Binding var challenge: Challenge

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(challenge.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipped()

                Text(challenge.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                Text(challenge.description)
                    .font(.body)
                    .padding(.top)

                HStack {
                    Text("Host Restaurant:")
                        .font(.headline)
                    Spacer()
                    Text(challenge.hostRestaurant)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                HStack {
                    Text("Deadline:")
                        .font(.headline)
                    Spacer()
                    Text(challenge.deadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                HStack {
                    Text("Prize:")
                        .font(.headline)
                    Spacer()
                    Text(challenge.prize)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                Button(action: {
                    withAnimation {
                        challenge.isJoined = true
                        showConfirmation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showConfirmation = false
                        }
                    }
                }) {
                    Text("Join Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                }
                .padding(.top)
                .disabled(challenge.isJoined)
                .opacity(challenge.isJoined ? 0.5 : 1)

                Spacer()
            }
            .padding()
            .overlay(
                VStack {
                    if showConfirmation {
                        Text("Challenge accepted! Try your best!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .transition(.scale)
                    }
                }
                .animation(.easeInOut)
                , alignment: .top)
        }
        .navigationTitle("Challenge Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailView(challenge: .constant(sampleChallenges[0]))
    }
}

