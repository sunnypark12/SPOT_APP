//
//  ChallengeCardView.swift
//  SPOT_F
//
//  Created by 선호 on 7/3/24.
//

import SwiftUI

struct ChallengeCardView: View {
    var challenge: Challenge

    var body: some View {
        HStack {
            Image(challenge.imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(challenge.name)
                    .font(.headline)
                Text(challenge.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct ChallengeCardView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCardView(challenge: sampleChallenges[0])
    }
}

