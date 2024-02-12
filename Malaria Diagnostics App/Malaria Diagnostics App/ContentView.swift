//
//  ContentView.swift
//  Malaria Diagnostics App
//
//  Created by crystal on 2/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Tabs
        TabView {
            // Image Analysis Tab
            ImageAnalysisView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Image Analysis")
                }
            // Other tabs
            Text("Other Feature")
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("More")
                }
        }
    }
}

struct ImageAnalysisView: View {
    @State private var isShowingImagePicker = false
    @State private var isShowingPhotoLibrary = false
    @State private var image: Image? = nil
    @State private var diagnosisResult: Bool? = nil
    
    var body: some View {
        VStack {
            // Title
            Text("Malaria Diagnostics")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.title)
                .padding()
            
            // Image shown or not
            image?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .clipShape(Rectangle())
                .shadow(radius: 10)
            
            // TODO: Display result
            if let result = diagnosisResult {
                resultIndicator(result: result)
            }
            
            // Take photo button
            Button(action: {
                self.isShowingImagePicker = true
            }) {
                HStack {
                    Image(systemName: "camera")
                        .fontWeight(.bold)
                    Text("Take a photo")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: 300)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(7)
            }
            .padding()
            .sheet(isPresented: $isShowingImagePicker) {
                PhotoCaptureView(isShown: self.$isShowingImagePicker, image: self.$image)
            }
            
            // Upload image button
            Button(action: {
                self.isShowingPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName:"photo.on.rectangle")
                        .fontWeight(.bold)
                    Text("Add an existing photo")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: 300)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(7)
            }
            .sheet(isPresented: $isShowingPhotoLibrary) {
                ImagePickerView(isShown: self.$isShowingPhotoLibrary, image: self.$image, sourceType: .photoLibrary)
            }
            
        }
        .navigationTitle("Image Analysis")
    }
}

@ViewBuilder
private func resultIndicator(result: Bool) -> some View {
    Circle()
        .foregroundColor(result ? .red : .green)
        .frame(width: 100, height: 50)
        .overlay(Text(result ? "Positive" : "Negative").foregroundColor(.white))
        .padding()
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: Image?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var image: Image?
        
        init(isShown: Binding<Bool>, image: Binding<Image?>) {
            _isShown = isShown
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
}

struct PhotoCaptureView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: Image?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoCaptureView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PhotoCaptureView>) {
        // TODO: implement more logics
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var image: Image?
        
        init(isShown: Binding<Bool>, image: Binding<Image?>) {
            _isShown = isShown
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
}

#Preview {
    ContentView()
}
