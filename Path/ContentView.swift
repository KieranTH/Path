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
            Text("Search: ")
                .font(.title)
                .padding(.all,12)
            Text(currentArea.area.name)
                .font(.headline)
                .italic()
                .padding(.all,12)
        }.navigationTitle("Information")
    }
}
