//
//  WorldView.swift
//  Path
//
//  Created by Kieran on 11/07/2021.
//

import SwiftUI
import MapKit
import CoreGPX


struct WorldView: View {
    
    @Binding var tabSelection: Int
    
    //@Binding var parentName: String
    
    @ObservedObject var currentArea: CurrentArea
    
    @State var parentGpx: GPXRoot
    
    var locationManager = CLLocationManager()
    
    //--- global var from Main.swift file ---
    //@EnvironmentObject var path: FootPaths
    
    //--- Initial Coordinates for map --
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State var searchModel = false
    @State var history: [Area] = []
    
    @State var search: Area?
    
    
    //--- display map ---
    var body: some View {
        
        ZStack{
            //--- map ---
            MapView(centerCoordinate: $centerCoordinate, searchedArea: $search, tabSelection: $tabSelection, gpx: parentGpx)
                .navigationTitle("Map")
                .edgesIgnoringSafeArea(.all)
            /*MapV()
                .navigationTitle("Map")
                .edgesIgnoringSafeArea(.all)*/
            
            //--- magnifying glass button ---
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action:{
                        self.searchModel.toggle()
                    }){
                        Image(systemName: "magnifyingglass")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
                }
            }
            //--- sheet that opens for searching ---
            .sheet(isPresented: $searchModel , content: {
                //--- calls Search View and passes bool for searchModel and history list
                //--- then uses callback function didSearchArea to pass new area to history ///---
                showSearchModel(isPresented: self.$searchModel, historyList: self.history,didSearchArea: {
                    area in
                    
                    self.history.append(area)
                    self.search = area
                    
                    self.currentArea.area = area
                    
                    //self.parentName = area.name
                    //print("New Area:", self.parentName)
                }, tabSelection: $tabSelection)
            })
        }
    }
}

//--- Search Area View ---
struct showSearchModel: View{
    
    //--- binding var (changes cycle up ladder, this method changes parent method) ---
    @Binding var isPresented: Bool
    
    //--- search history list ---
    var historyList: [Area]
    
    //--- area var ---
    @State var area = ""
    
    //---- showing alert var ---
    @State var showingAlert = false
    
    //--- callback function delcaration ---
    var didSearchArea: (Area) -> ()
    
    @Binding var tabSelection: Int
    
    //@Binding var parentName: String


    
    //--- view function ---
    var body: some View{
        VStack{
            //--- title ---
            HStack{
                Text("Search for Area")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                Spacer()
            }
            //--- search bar ---
            HStack(spacing: 16){
                Text("Search:")
                TextField("Area", text: $area)
                    .padding(.all, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).strokeBorder(style: StrokeStyle(lineWidth: 1)))
                    
            }.padding(.bottom, 20)
            
            //--- search button ---
            Button(action: {
                if(self.area != "")
                {
                    //--- creates new Area object and passes to callback ---
                    self.didSearchArea(.init(name: self.area))
                    //--- closes sheet through boolean ---
                    self.isPresented = false
                    //self.parentName = self.area
                    //print(self.parentName)
                }
                else{
                    //--- dislays alert ---
                    self.showingAlert = true
                }
                
            }, label: {
                Text("Search")
                    .padding(.all,16)
                    .foregroundColor(Color.white)
                    .background(Color.green)
            }).cornerRadius(10)
            
            
            //--- Cancel button ---
            Button(action: {self.isPresented = false}, label: {
                Text("Cancel")
                    .padding(.all,16)
                    .foregroundColor(Color.white)
                    .background(Color.red)
            }).cornerRadius(10)
            
            //--- History List ---
            VStack{
                HStack{
                    Text("Search History")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                //--- List object to iterate through array ---
                List(historyList){
                    area in
                    
                    //--- Button to allow for information about area (distance etc) ---
                    Button(action:{
                        //--- Changing view to ContentView and closing sheet ---
                        tabSelection = 1;
                        self.isPresented = false
                    }){
                        //--- Area name and search button ---
                        HStack{
                            Text("Area: ")
                            Text(area.name)
                            Spacer()
                            Button(action: {
                                self.isPresented = false
                                //--- ADD SEARCH FUNCTIONALITY HERE ---
                                didSearchArea(area)
                                
                            }, label: {
                                Image(systemName: "magnifyingglass")
                            })
                        }.padding(.all, 10)
                    }
                }
                .listStyle(SidebarListStyle())
            }.padding(.top, 50)
            Spacer()
        }
        .padding(.all, 16)
        .alert(isPresented: $showingAlert){
            Alert(
                title: Text("Invalid Input"),
                message: Text("Please enter a valid input!"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}
