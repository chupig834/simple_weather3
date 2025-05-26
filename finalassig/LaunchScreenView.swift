//
//  LaunchScreenView.swift
//  finalassig
//
//  Created by Jerry Chu on 12/7/24.
//

import SwiftUI

struct LaunchScreenView: View
{
    
    
    
    var body: some View {
        ZStack{
            Image("App_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image("Mostly Clear")
                .resizable()
                .scaledToFit()
                .frame(width:100, height:100)
                .position(x:220, y:250)
            
            Image("Powered_by_Tomorrow-Black")
                .resizable()
                .frame(width:250, height:25)
                .aspectRatio(contentMode: .fit)
                .position(x:220, y:550)
        }
    }
}

#Preview {
    LaunchScreenView()
}
