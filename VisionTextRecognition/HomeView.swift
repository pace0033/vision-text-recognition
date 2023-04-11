//
//  ContentView.swift
//  VisionTextRecognition
//
//  Created by Will Paceley on 2023-04-10.
//

import SwiftUI

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
        .padding()
        .fullScreenCover(isPresented: $isShowingScanner) {
            ScannerView(scannedImage: $scannedImage)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
