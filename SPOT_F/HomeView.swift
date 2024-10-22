import SwiftUI
import CoreLocation

struct HomeView: View {
    @State private var isExpanded = false
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab: String = "Trending"

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
                    VStack {
                        HStack {
                            Text("Trending")
                                .font(.custom("Chenla", size: 16))
                                .foregroundColor(selectedTab == "Trending" ? Color.black : Color.white)
                                .padding(.horizontal)
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = "Trending"
                                    }
                                }

                            Text("Following")
                                .font(.custom("Chenla", size: 16))
                                .foregroundColor(selectedTab == "Following" ? Color.black : Color.white)
                                .padding(.horizontal)
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = "Following"
                                    }
                                }
                        }
                    }
                    .padding(.top, 30)

                    GeometryReader { proxy in
                        if selectedTab == "Trending" {
                            TabView {
                                ForEach(0..<10, id: \.self) { index in
                                    PostView(imageName: "res\(index % 3 + 1)", location: "Trending Location \(index + 1)", backImageName: "food\(index % 3 + 1)")
                                        .frame(width: proxy.size.width, height: proxy.size.height)
                                        .rotationEffect(.degrees(-90))
                                }
                            }
                            .frame(width: proxy.size.height, height: proxy.size.width)
                            .rotationEffect(.degrees(90), anchor: .topLeading)
                            .offset(x: proxy.size.width)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        } else if selectedTab == "Following" {
                            TabView {
                                ForEach(0..<10, id: \.self) { index in
                                    PostView(imageName: "res\(index % 3 + 1)", location: "Following Location \(index + 1)", backImageName: "food\(index % 3 + 1)")
                                        .frame(width: proxy.size.width, height: proxy.size.height)
                                        .rotationEffect(.degrees(-90))
                                }
                            }
                            .frame(width: proxy.size.height, height: proxy.size.width)
                            .rotationEffect(.degrees(90), anchor: .topLeading)
                            .offset(x: proxy.size.width)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                    }

                    Spacer()

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
                            Image("Smiley_Face")
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                    }
                    .offset(y: 15)
                    .frame(height: 70)
                }
            }
        }
    }
}

struct PostView: View {
    var imageName: String
    var location: String
    var backImageName: String
    @State private var isLiked = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    HStack {
                        Text("Sunny_Park")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("at")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(location)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    Text("3 min ago")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.top, 40)
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(20)
            Spacer()
            // FlipCardView with full-width photo
            FlipCardView(
                front: AnyView(
                    ZStack(alignment: .bottom) {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped() // Ensures any overflowing content is clipped
                            .background(Color.clear) // Ensures the background is clear

                        HStack {
                            Text("This is a caption for the post.")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Text("125")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            Image(isLiked ? "Smiley_Face_Yellow" : "Smiley_Face")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .scaleEffect(isLiked ? 1.2 : 1.0)
                                .opacity(isLiked ? 0.5 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: isLiked)
                                .onTapGesture(count: 2) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isLiked.toggle()
                                    }
                                }
                        }
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .frame(height: 80)
                    }
                ),
                back: AnyView(
                    Image(backImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 10)

            Spacer()
        }
        .shadow(radius: 2)
    }
}

struct FlipCardView: View {
    @State private var flipped = false
    
    var front: AnyView
    var back: AnyView
    
    var body: some View {
        ZStack {
            if flipped {
                back
            } else {
                front
            }
        }
        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.default, value: flipped)
        .onTapGesture {
            withAnimation {
                flipped.toggle()
            }
        }
    }
}

struct CircleBut: View {
    var icon: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.75))
                .frame(width: 60, height: 60)

            Image(systemName: icon)
                .foregroundColor(.black)
                .font(.system(size: 25))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
