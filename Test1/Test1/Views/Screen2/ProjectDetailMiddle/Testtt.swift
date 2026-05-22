//
//  Testtt.swift
//  Test1
//
//  Created by Hai Nam on 22/5/26.
//

import SwiftUI

class MyCoordinator: NSObject, UIGestureRecognizerDelegate {
    static let shared = MyCoordinator()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

struct MyGesture: UIGestureRecognizerRepresentable {

    let action: (CGPoint) -> Void
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> MyCoordinator {
        MyCoordinator.shared
    }
    
    func makeUIGestureRecognizer(context: Context) -> UIGestureRecognizer {
        let pan = UIPanGestureRecognizer()
        pan.delegate = context.coordinator
        return pan
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        action(recognizer.translation(in: nil))
    }
}
