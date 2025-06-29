//
//  EmojiCircle.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 29.06.2025.
//

import SwiftUI

struct EmojiCircle: View {
    var emoji: Character
    
    var body: some View {
        Text("\(emoji)")
            .font(.caption)
            .frame(width: 24, height: 24)
            .background(Color.accentLight)
            .clipShape(Circle())
    }
}
