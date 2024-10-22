//
//  LunchMateDetailView.swift
//  SPOT_F
//
//  Created by 선호 on 7/9/24.
//

import SwiftUI

struct LunchMateDetailView: View {
    @State private var showConfirmation = false
    @Binding var challenge: Challenge
    @State private var acceptedPeople = 2 // Sample data, replace with actual logic

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
                    Text("Restaurant:")
                        .font(.headline)
                    Spacer()
                    Text(challenge.hostRestaurant)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                HStack {
                    Text("Time:")
                        .font(.headline)
                    Spacer()
                    Text(challenge.deadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                HStack {
                    Text("Accepting Until:")
                        .font(.headline)
                    Spacer()
                    Text(challenge.deadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                HStack {
                    Text("Accepting:")
                        .font(.headline)
                    Spacer()
                    Text("\(acceptedPeople)/5 accepted")
                        .foregroundColor(.gray)
                }
                .padding(.top)

                Button(action: {
                    withAnimation {
                        acceptedPeople += 1
                        showConfirmation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showConfirmation = false
                        }
                    }
                }) {
                    Text("Send Acceptance Request")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                }
                .padding(.top)
                .disabled(acceptedPeople >= 5)
                .opacity(acceptedPeople >= 5 ? 0.5 : 1)

                Spacer()
            }
            .padding()
            .overlay(
                VStack {
                    if showConfirmation {
                        Text("Request sent! Wait for approval.")
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

struct LunchMateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LunchMateDetailView(challenge: .constant(sampleLunchMateChallenges[0]))
    }
}
