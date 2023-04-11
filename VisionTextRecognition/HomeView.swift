//
//  ContentView.swift
//  VisionTextRecognition
//
//  Created by Will Paceley on 2023-04-10.
//

import SwiftUI
import Vision

struct HomeView: View {
    @State private var scannedImage: UIImage?
    @State private var isShowingScanner = false
    
    var body: some View {
        VStack {
            
            
            Button {
                isShowingScanner = true
            } label: {
                Label("Scan Image", systemImage: "camera.fill")
            }
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.large)
            .padding()
        }
        .fullScreenCover(isPresented: $isShowingScanner) {
            ScannerView(scannedImage: $scannedImage)
        }
        .onChange(of: scannedImage) { _ in
            if let image = scannedImage {
                processImage(image: image)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView {
    private func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get CGImage from input image")
            return
        }
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        print(recognizedStrings)
    }
}
