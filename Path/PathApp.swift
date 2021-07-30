//
//  PathApp.swift
//  Path
//
//  Created by Kieran on 11/07/2021.
//

import SwiftUI



@main
struct PathApp: App {
    
    //@StateObject var paths = FootPaths()
    @State private var selection = 1
    @State var gpx = GPXManager().start()
    
    //--- change this state to @StateObject and create new swift class for the current Area
    //--- and within the ContentView and WorldView use @ObservableObject for the current area var ---
    
    @StateObject var currentArea = CurrentArea()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection){
                NavigationView{
                    ContentView(gpx: gpx, currentArea: currentArea)//location: locations.primary)
                }
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Discover")
                }.tag(1)
                
                NavigationView{
                    WorldView(tabSelection: $selection, currentArea: currentArea, parentGpx: gpx)
                }
                .tabItem{
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)
            }//.environmentObject(paths)
        }
    }
}
