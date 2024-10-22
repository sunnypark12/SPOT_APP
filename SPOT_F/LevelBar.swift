//
//  LevelBar.swift
//  SPOT_F
//
//  Created by 선호 on 7/3/24.
//

import SwiftUI

struct LevelBar: View {
    var level: Int
    var progress: CGFloat

    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("Level \(level)")
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text("\(Int(progress * 100))%")
                .font(.headline)
                .foregroundColor(.white)
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 100, height: 20)
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                Rectangle()
                    .frame(width: progress * 100, height: 20)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
}

struct LevelBar_Previews: PreviewProvider {
    static var previews: some View {
        LevelBar(level: 1, progress: 0.5)
    }
}
