//
//  ScannerView.swift
//  VisionTextRecognition
//
//  Created by Will Paceley on 2023-04-10.
//

import VisionKit
import SwiftUI

// A SwiftUI view that represents a UIKit view controller (VNDocumentCameraViewController in this case)
struct ScannerView: UIViewControllerRepresentable {
    // SwiftUI manages your UIViewControllerRepresentable type’s coordinator
    // and provides it as part of the context when calling the methods above.
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ScannerView
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true) {
                let image = scan.imageOfPage(at: 0)
                self.parent.scannedImage = image
            }
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("CameraViewController failed with error: \(error)")
            controller.dismiss(animated: true)
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            print("User cancelled taking photo.")
            controller.dismiss(animated: true)
        }
    }
    
    // SwiftUI calls this makeCoordinator() method before makeUIViewController(context:)
    // which grants access to the coordinator object when configuring your view controller.
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    @Binding var scannedImage: UIImage?
    
    // SwiftUI calls this method once when it’s ready to display the view
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
    }
}
