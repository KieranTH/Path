//
//  InformationView.swift
//  Path
//
//  Created by Kieran on 01/08/2021.
//

import SwiftUI

struct InformationView: View {
    
    @ObservedObject var currentArea: CurrentArea
    
    var body: some View {
        
        if let img = UIImage(named: currentArea.area.name.lowercased())
        {
            Image(currentArea.area.name.lowercased())
                .resizable()
                .scaledToFit()
                .opacity(0.8)
                .blur(radius:0.3)
                .shadow(color: Color(UIColor.systemBackground), radius: 3)
        }
        
        
//        Image(currentArea.area.name)
//            .resizable()
//            .scaledToFit()
        
        Text(currentArea.area.name.firstUppercased)
            .font(.title)
            .padding(.all,12)
        
//        ScrollView(.horizontal){
//            HStack(spacing: 20){
//                VStack{
//                    Text("Distance:")
//                    Text("1 KM")
//                }
//                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                .frame(width: 200, height: 200, alignment: .center)
//                .background(Color.red)
//                VStack{
//                    Text("Distance:")
//                    Text("2 KM")
//                }
//                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                .frame(width: 400, height: 200, alignment: .center)
//                .background(Color.red)
//            }
//        }
        
        TabView{
                VStack{
                    Text("Distance:")
                        .font(.headline)
                        .padding(.bottom, 20)
                    Text("1 KM")
                        .font(.subheadline)
                        .padding(.bottom, 30)
                    
                }
                //.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .frame(width: 200, height: 200, alignment: .center)
                //.background(Color.red)
                //.border(Color.white.opacity(0.6), width: 3)
                .shadow(radius: 0)
            
            
                VStack{
                    Text("Distance:")
                        .font(.headline)
                        .padding(.bottom, 20)
                    Text("1 KM")
                        .font(.subheadline)
                        .padding(.bottom, 30)
                }
                //.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .frame(width: 200, height: 200, alignment: .center)
                //.background(Color.red)
                //.border(Color.white.opacity(0.6), width: 3)
                .shadow(radius: 0)
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(width: 250, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding()
        .border(Color(UIColor.systemBackground), width: 1)
        .background(Color(UIColor.systemBackground).colorInvert().opacity(0.1).blur(radius: 4))
        .shadow(color: .gray, radius: 7, y: 2)
        
        
        
    }
}

extension StringProtocol{
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

