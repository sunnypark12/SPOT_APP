import SwiftUI
import AVFoundation
import AVKit
import CoreLocation

struct UploadView: View {
    @State private var showImagePicker = false
    @State private var showVideoPicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var videoDuration: Double = 8.0
    @State private var isVideoMode = false
    @State private var showLocationPopup = false
    @State private var showBadgesPopup = false
    @State private var showCaptionPopup = false
    @State private var restaurantLocation: String = ""
    @State private var selectedBadges: [String] = []
    @State private var captionText: String = ""
    
    let badges = ["Wheelchair Accessible", "Parking Available", "Veteran Friendly", "Deafness Accessible", "Blindness Accessible"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 1.0, green: 0.776, blue: 0.0), Color(red: 0.835, green: 0.4, blue: 0.086)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                CustomCameraView(selectedImage: $selectedImage, selectedVideoURL: $selectedVideoURL)
                
                Spacer()
                
                if selectedImage != nil || selectedVideoURL != nil {
                    Button(action: {
                        showLocationPopup = true
                    }) {
                        Text("Proceed")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            
            if showLocationPopup {
                locationPopup
            }
            
            if showBadgesPopup {
                badgesPopup
            }
            
            if showCaptionPopup {
                captionPopup
            }
        }
    }
    
    private var locationPopup: some View {
        VStack {
            TextField("Enter Restaurant Location", text: $restaurantLocation)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding()
            
            Button(action: {
                showLocationPopup = false
                showBadgesPopup = true
            }) {
                Text("OK")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .padding()
        .shadow(radius: 20)
    }
    
    private var badgesPopup: some View {
        VStack {
            Text("Select Badges")
                .font(.headline)
                .padding()
            
            ForEach(badges, id: \.self) { badge in
                Button(action: {
                    if selectedBadges.contains(badge) {
                        selectedBadges.removeAll { $0 == badge }
                    } else {
                        selectedBadges.append(badge)
                    }
                }) {
                    HStack {
                        Image(systemName: badgeIcon(for: badge))
                        Text(badge)
                    }
                    .padding()
                    .background(selectedBadges.contains(badge) ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(4)
                }
            }
            
            Button(action: {
                selectedBadges.removeAll()
            }) {
                Text("None of them apply")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(4)
            }
            
            HStack {
                Button(action: {
                    uploadPost()
                }) {
                    Text("Skip")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
                
                if !selectedBadges.isEmpty {
                    Button(action: {
                        showBadgesPopup = false
                        showCaptionPopup = true
                    }) {
                        Text("Proceed to Caption")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
        }
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .padding()
        .shadow(radius: 20)
    }
    
    private var captionPopup: some View {
        VStack {
            TextField("Enter Caption", text: $captionText)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding()
            
            Button(action: {
                uploadPost()
            }) {
                Text("Upload")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .padding()
        .shadow(radius: 20)
    }
    
    func uploadPost() {
        // Implement the logic to upload the post with selected image, video, badges, and caption
        showLocationPopup = false
        showBadgesPopup = false
        showCaptionPopup = false
        selectedImage = nil
        selectedVideoURL = nil
        restaurantLocation = ""
        selectedBadges = []
        captionText = ""
    }
    
    func badgeIcon(for badge: String) -> String {
        switch badge {
        case "Wheelchair Accessible":
            return "figure.roll"
        case "Parking Available":
            return "car.fill"
        case "Veteran Friendly":
            return "shield.lefthalf.filled"
        case "Deafness Accessible":
            return "ear"
        case "Blindness Accessible":
            return "eye.fill"
        default:
            return "questionmark.circle"
        }
    }
}

struct CustomCameraView: View {
    @StateObject private var camera = CameraModel()
    @State private var showImagePicker = false
    @Binding var selectedImage: UIImage?
    @Binding var selectedVideoURL: URL?
    @State private var isVideoMode = false

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                HStack {
                    Button(action: {
                        camera.isFlashOn.toggle()
                    }, label: {
                        Image(systemName: camera.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        showImagePicker = true
                    }, label: {
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                    })
                    .sheet(isPresented: $showImagePicker) {
                        if isVideoMode {
                            VideoPicker(sourceType: .photoLibrary, selectedVideoURL: $selectedVideoURL, maxDuration: 8.0)
                        } else {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isVideoMode.toggle()
                    }, label: {
                        Text(isVideoMode ? "Video" : "Photo")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        if isVideoMode {
                            camera.startRecording()
                        } else {
                            camera.takePicture()
                        }
                    }, label: {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .padding()
                    })
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            camera.checkPermissions()
        }
        .onChange(of: camera.photoData) { newData in
            if let newData = newData {
                selectedImage = UIImage(data: newData)
            }
        }
        .onChange(of: camera.videoURL) { newURL in
            if let newURL = newURL {
                selectedVideoURL = newURL
            }
        }
    }
}

import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    @Published var isFlashOn = false
    @Published var photoData: Data?
    @Published var videoURL: URL?
    
    public var session: AVCaptureSession?
    
    private var output = AVCapturePhotoOutput()
    private var videoOutput = AVCaptureMovieFileOutput()
    
    override init() {
        super.init()
        self.checkPermissions()
    }
    
    func setup() {
        session = AVCaptureSession()
        guard let session = session else { return }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                if session.canAddOutput(videoOutput) {
                    session.addOutput(videoOutput)
                }
                
                session.startRunning()
            } catch {
                print("Error setting up camera: \(error)")
            }
        }
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setup()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setup()
                    }
                }
            }
        case .denied, .restricted:
            print("Camera access denied or restricted")
        @unknown default:
            break
        }
    }
    
    func takePicture() {
        guard let session = session, session.isRunning else {
            print("Session is not running")
            return
        }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = isFlashOn ? .on : .off
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func startRecording() {
        guard let session = session, session.isRunning else { return }
        
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mov")
        videoOutput.startRecording(to: tempURL, recordingDelegate: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.stopRecording()
        }
    }
    
    func stopRecording() {
        videoOutput.stopRecording()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation() {
            self.photoData = data
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            self.videoURL = outputFileURL
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        if let session = camera.session {
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.frame
            view.layer.addSublayer(previewLayer)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
        picker.mediaTypes = ["public.image"]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct VideoPicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedVideoURL: URL?
    var maxDuration: Double
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, maxDuration: maxDuration)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: VideoPicker
        var maxDuration: Double
        
        init(_ parent: VideoPicker, maxDuration: Double) {
            self.parent = parent
            self.maxDuration = maxDuration
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let videoURL = info[.mediaURL] as? URL {
                parent.selectedVideoURL = videoURL
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
        picker.mediaTypes = ["public.movie"]
        picker.videoMaximumDuration = maxDuration
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
