//
//  AITask.swift
//  test123
//
//  Created by Hai Nam on 12/5/26.
//

import Vision
import UIKit
import CoreML

actor AITask {
    static var model: MLModel?
    
    @MainActor static func load() throws {
        let config = MLModelConfiguration()
        config.computeUnits = .all
        model = try realesrgan512(configuration: config).model
    }
    
    static func doSomethiing() async throws {
        for _ in 0..<1000 {
            let handler = await VNImageRequestHandler(cgImage: UIImage.test.cgImage!)
            try handler.perform([VNCoreMLRequest(model: try VNCoreMLModel(for: model!))])
        }
    }
    
    static func pixelBufferRGB(from image: CGImage) -> CVPixelBuffer? {
        
        let width = image.width
        let height = image.height
        
        let attrs: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ]
        
        var pixelBuffer: CVPixelBuffer?
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32RGBA,
            attrs as CFDictionary,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            return nil
        }
        
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return buffer
    }

}
