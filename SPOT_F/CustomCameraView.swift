//
//  CustomCameraView.swift
//  SPOT_F
//
//  Created by 선호 on 7/6/24.
//

import SwiftUI
import AVFoundation

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
        .onChange(of: camera.photoData, perform: { data in
            if let data = data {
                selectedImage = UIImage(data: data)
            }
        })
        .onChange(of: camera.videoURL, perform: { url in
            if let url = url {
                selectedVideoURL = url
            }
        })
    }
}



import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    @Published var isFlashOn = false
    @Published var photoData: Data?
    @Published var videoURL: URL?
    
    public var session: AVCaptureSession? // Make session public
    
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
        
        do {
            try output.capturePhoto(with: settings, delegate: self)
        } catch {
            print("Error capturing photo: \(error.localizedDescription)")
        }
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
            previewLayer.videoGravity = .resizeAspectFill // Correcting videoGravity reference
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
