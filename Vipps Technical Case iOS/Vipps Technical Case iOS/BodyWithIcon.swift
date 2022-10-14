//
//  BodyWithIcon.swift
//  Vipps Technical Case iOS
//
//  Created by Marius Genton on 10/14/22.
//

import SwiftUI

struct BodyWithIcon: View {
    
    let text: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(text)
        }
        .padding([.leading, .trailing, .top])
    }
}

struct BodyWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        BodyWithIcon(text: "Test", iconName: "info.circle")
    }
}
