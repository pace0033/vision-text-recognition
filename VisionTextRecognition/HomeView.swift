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
    @State private var scanResults: [String]?
    @State private var isShowingScanner = false
    @State private var isShowingProgressView = false
    
    var body: some View {
        VStack {
            if let scanResults {
                List(scanResults, id: \.self) { result in
                    Text(result)
                }
                .listStyle(.plain)
            }
            
            Button {
                isShowingScanner = true
                isShowingProgressView = true
            } label: {
                if isShowingProgressView {
                    ProgressView()
                } else {
                    Label("Scan Image", systemImage: "camera.viewfinder")
                }
            }
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.large)
            .font(.title3)
            .padding(.top)
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
        
        // MARK: CUSTOMIZATION OPTIONS
        // Recognition Level (Fast or Accurate)
         request.recognitionLevel = .fast
        
        // Minimum Text Height
        // The minimum height, relative to the image height, of the text to recognize.
        request.minimumTextHeight = 0.5
        
        // Language detection toggle
        request.automaticallyDetectsLanguage = false
        
        // Specify languages to recognize
        request.recognitionLanguages = ["en-US", "fr-FR"]
        
        // Get supported languages for the request
        do {
            try request.supportedRecognitionLanguages()
        } catch {
            print("Supported languages not found.")
        }
        
        // Toggle Language Correction
        request.usesLanguageCorrection = false
        
        // Custom Words
        // Words to supplement the recognized languages at the word-recognition stage
        request.customWords = ["supercalifragilisticexpialidocious"]
        
        isShowingProgressView = true
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
            isShowingProgressView = false
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            isShowingProgressView = false
            return
        }
        
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        processResults(recognizedStrings)
    }
    
    private func processResults(_ results: [String]) {
        print(results)
        scanResults = results
        isShowingProgressView = false
    }
}
