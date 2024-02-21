//
//  ImageAnalysisView.swift
//  Malaria Diagnostics App
//
//  Created by crystal on 2/20/24.
//

import Foundation
import SwiftUI

struct ImageAnalysisView: View {
    @State private var isShowingImagePicker = false
    @State private var isShowingPhotoLibrary = false
    @State private var uiImage: UIImage? = nil
    @State private var diagnosisResult: String? = nil
    
    var body: some View {
        VStack {
            
            // Display the selected image
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .clipShape(Rectangle())
                    .shadow(radius: 30)
                    .padding()
            }
            
            // Display the analysis result
            if let result = diagnosisResult {
                ResultBoxView(result: result)
            }
            
            // Take photo button
            Button(action: {
                self.isShowingImagePicker = true
            }) {
                HStack {
                    Image(systemName: "camera")
                    Text("Take a photo")
                }
                .frame(maxWidth: 250)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
//            .padding()
            .sheet(isPresented: $isShowingImagePicker) {
                PhotoCaptureView(isShown: self.$isShowingImagePicker, uiImage: self.$uiImage) {
                    self.analyzeImage()
                }
            }
            
            // Upload image button
            Button(action: {
                self.isShowingPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text("Add an existing photo")
                }
                .frame(maxWidth: 250)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $isShowingPhotoLibrary) {
                ImagePickerView(isShown: self.$isShowingPhotoLibrary, uiImage: self.$uiImage, sourceType: .photoLibrary) {
                    self.analyzeImage()
                }
            }
        }
        .navigationTitle("Image Analysis")
    }
    
    // Analyze the image
    private func analyzeImage() {
        guard let uiImage = uiImage, let base64Image = uiImage.toBase64() else {
            print("Error: Image is nil or Base64 conversion failed")
            self.diagnosisResult = "Error: Image processing failed."
            return
        }

        let gptAPI = GPTAPI()
        gptAPI.sendRequest(withMessage: "Describe the image in a sentence. If it contains blue or purple stains, please mark it as positive; otherwise, mark it as negative.", images: [base64Image]) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.diagnosisResult = response
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.diagnosisResult = "Analysis error: \(error.localizedDescription)"
                }
            }
        }
    }
}

extension UIImage {
    func toBase64(format: ImageFormat = .jpeg) -> String? {
        let imageData: Data?
        switch format {
        case .jpeg:
            imageData = self.jpegData(compressionQuality: 0.8)
        case .png:
            imageData = self.pngData()
        }
        return imageData?.base64EncodedString()
    }
    
    enum ImageFormat {
        case jpeg
        case png
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShown: $isShown, uiImage: $uiImage, onImagePicked: onImagePicked)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var uiImage: UIImage?
        var onImagePicked: () -> Void
        
        init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>, onImagePicked: @escaping () -> Void) {
            _isShown = isShown
            _uiImage = uiImage
            self.onImagePicked = onImagePicked
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.uiImage = uiImage
                onImagePicked()
            }
            isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
}

struct PhotoCaptureView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?
    var onImagePicked: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShown: $isShown, uiImage: $uiImage, onImagePicked: onImagePicked)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var uiImage: UIImage?
        var onImagePicked: () -> Void
        
        init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>, onImagePicked: @escaping () -> Void) {
            _isShown = isShown
            _uiImage = uiImage
            self.onImagePicked = onImagePicked
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.uiImage = uiImage
                onImagePicked()
            }
            isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
}

struct ResultBoxView: View {
    let result: String
    
    private var statusMessage: String {
        result.lowercased().contains("positive") ? "Positive" : "Negative"
    }
    private var statusColor: Color {
        result.lowercased().contains("positive") ? .green : .red
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(result)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: 250, alignment: .leading)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .cornerRadius(5)
            .padding([.leading, .trailing])
        }
        
        Text(statusMessage)
            .bold()
            .foregroundColor(statusColor)
    }
}

