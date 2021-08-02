//
//  ContentView.swift
//  Path
//
//  Created by Kieran on 11/07/2021.
//

import SwiftUI
import CoreGPX


struct ContentView: View {
    //let location: Location
    
    @State var gpx: GPXRoot
    
    @ObservedObject var currentArea: CurrentArea
    
    var body: some View {
        ScrollView{
            if(currentArea.area.name != "")
            {
                InformationView(currentArea: currentArea)
            }
            else{
                Text("Welcome!")
                    .font(.title)
                    .padding(.all, 12)
                    .padding(.top, 50)
            }
        }.ignoresSafeArea()
    }
}

//extension String {
//     func isEqualToString(find: String) -> Bool {
//        return String(format: self) == find
//    }
//}
