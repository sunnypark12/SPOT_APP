
import CoreLocation
import SwiftUI

struct ProfileView: View {
    @State private var isProfilePressed = false
    @State private var showCollections = false
    @State private var showProfileSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 1.0, green: 0.776, blue: 0.0), location: 0.3),
                        .init(color: Color(red: 0.835, green: 0.4, blue: 0.086), location: 0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                VStack() {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ProfileSettingsView()) {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                    }
                    
                    Text("Bruno Pham")
                        .font(Font.custom("Titan One", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    HStack(alignment: .center, spacing: 30) {
                        VStack {
                            NavigationLink(destination: BitesListView()) {
                                VStack {
                                    Text("bites")
                                        .font(Font.custom("Concert One", size: 18))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                                        .frame(width: 44, alignment: .center)

                                    Text("12")
                                        .font(Font.custom("Titan One", size: 18))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        VStack {
                            NavigationLink(destination: FollowingListView()) {
                                VStack {
                                    Text("following")
                                        .font(Font.custom("Concert One", size: 18))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                                        .frame(width: 77, alignment: .center)

                                    Text("673")
                                        .font(Font.custom("Titan One", size: 18))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        VStack {
                            NavigationLink(destination: FollowersListView()) {
                                VStack {
                                    Text("follower")
                                        .font(Font.custom("Concert One", size: 18))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                                        .frame(width: 67, alignment: .center)

                                    Text("79")
                                        .font(Font.custom("Titan One", size: 18))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                    }
                    .padding(0)
                    .frame(width: 350, height: 80)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .inset(by: 1)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    
                    GeometryReader { geometry in
                        VStack {
                            if !isProfilePressed {
                                ResponsiveWebView(isProfilePressed: $isProfilePressed)
                                    .frame(height: 0)
                                    .offset(y: +20)
                                    .frame(alignment: .center)

                            }
                            

                            VStack {
                                if isProfilePressed {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .background(Circle().fill(Color.white))
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                        .onTapGesture {
                                            withAnimation {
                                                isProfilePressed.toggle()
                                            }
                                        }
                                        .padding(.top, 10)
                                        .padding(.bottom, 15)

                                        .offset(y: +10)
                                    CollectionsContentView(showCollections: $showCollections)
                                        .transition(.move(edge: .bottom))
                                }
                                
                            }
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                        .offset(y: isProfilePressed ? -geometry.size.height * 0.1 : 0)
                        .animation(.easeInOut, value: isProfilePressed)
                    }
                    .padding(.top, 40)
                }
            }
        }
    }
}


//COLLECTION VIEW//

struct CollectionsContentView: View {
    @Binding var showCollections: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<2) { _ in
                    HStack {
                        ProfileCollectionView()
                        ProfileCollectionView()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}



struct ProfileCollectionView: View {
    var body: some View {
        NavigationLink(destination: CollectionsView()) {
            VStack(alignment: .leading, spacing: 6) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 158, height: 158)
                        .background(
                            AsyncImage(url: URL(string: "https://via.placeholder.com/158x158"))
                        )
                        .cornerRadius(10)
                        .overlay(
                            Text("PORTRAIT\nPHOTOGRAPHY")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.all, 8)
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(10)
                        )
                }
                Text("25 shots")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
            }
            .frame(width: 158, height: 185)
        }
    }
}


// -- BITE VIEW -- //
struct BitesListView: View {
    let bites: [String] = Array(1...21).map { "\($0)" } // Array of 21 bites for demonstration

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 1.0, green: 0.776, blue: 0.0), location: 0.3),
                    .init(color: Color(red: 0.835, green: 0.4, blue: 0.086), location: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                    ForEach(bites, id: \.self) { bite in
                        NavigationLink(destination: BiteDetailView(bite: bite)) {
                            BiteView(bite: bite)
                                .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                        }
                    }
                }
            }
            .navigationTitle("See Your Bites")
        }
    }
}

struct BiteView: View {
    let bite: String
    let width = UIScreen.main.bounds.width / 3
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.clear)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/\(Int(width))x\(Int(width))?text=Bite+\(bite)"))
                )
                .cornerRadius(0)
        }
        .frame(width: width, height: width)
        .aspectRatio(1, contentMode: .fill)
        .clipped()
    }
}

struct BiteDetailView: View {
    let bite: String
    @State private var showBack = false

    var body: some View {
        VStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 1.0, green: 0.776, blue: 0.0), location: 0.3),
                        .init(color: Color(red: 0.835, green: 0.4, blue: 0.086), location: 0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                if showBack {
                    // Video view
                    Color.black
                        .overlay(
                            Text("Video \(bite)")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                } else {
                    // Image view
                    AsyncImage(url: URL(string: "https://via.placeholder.com/320x320?text=Bite+\(bite)")) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    showBack.toggle()
                }
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}



// == FOLLOW VIEW == //
struct FollowingListView: View {
    var body: some View {
        SpottingView()
            .navigationTitle("Following")
    }
}

struct SpottingView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 1.0, green: 0.776, blue: 0.0), location: 0.3),
                    .init(color: Color(red: 0.835, green: 0.4, blue: 0.086), location: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            List {
                ForEach(0..<20) { index in
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text("Spotting \(index)")
                                .font(.headline)
                            Text("@spotting\(index)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden) // This line hides the default background of the List
        }
        .navigationTitle("Spotting")
    }
}


struct FollowersListView: View {
    var body: some View {
        SpottersView()
            .navigationTitle("Followers")
    }
}

struct SpottersView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 1.0, green: 0.776, blue: 0.0), location: 0.3),
                    .init(color: Color(red: 0.835, green: 0.4, blue: 0.086), location: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            List {
                ForEach(0..<20) { index in
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text("Spotter \(index)")
                                .font(.headline)
                            Text("@spotter\(index)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden) // This line hides the default background of the List
        }
        .navigationTitle("Spotters")
    }
}



struct ProfileView_Previewer: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

