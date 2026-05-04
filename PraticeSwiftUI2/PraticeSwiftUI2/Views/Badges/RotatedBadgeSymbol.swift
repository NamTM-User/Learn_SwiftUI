//
//  RotatedBadgeSymbol.swift
//  PraticeSwiftUI2
//
//  Created by Hai Nam on 4/5/26.
//

import SwiftUI

struct RotatedBadgeSymbol: View {
    let angle: Angle
    
    var body: some View {
        BadgeSymbol().padding(-60).rotationEffect(angle, anchor: .bottom)
    }
}

#Preview {
    RotatedBadgeSymbol(angle: Angle(degrees: 5))
}
