//
//  FlagImageView.swift
//  GuessTheFlag
//
//  Created by Dominique Strachan on 8/10/23.
//

import SwiftUI

struct FlagImageView: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .shadow(radius: 10)
    }
}

struct FlagImageView_Previews: PreviewProvider {
    
    static var previews: some View {
        FlagImageView(flag: "")
    }
}
