//
//  ContentView.swift
//  vestio
//
//  Created by Ben Lischin on 6/14/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack (alignment: .center) {
            Label {
                Group {
                    Text("Vest")
                        .foregroundColor(Color.green) +
                        //.underline() +
                        //.font(Font.system(size: 30))
                        //.bold()
                        //.italic()
                    Text("io")
                        .foregroundColor(Color.green)
                        //.underline()
                        //.font(Font.system(size: 30))
                        //.bold()
                        //.italic()
                }
                
                .frame(maxWidth: 95, alignment: .center)
                .bold()
                .italic()
                .font(Font.system(size: 30))
                .onAppear() {
                    modelData.load()
                }
            }icon: {
                Image(systemName: "bitcoinsign.square")
                    .foregroundColor(Color.green)
                    .bold()
                    .font(Font.system(size: 30))
                    .italic()
                
            }.padding(.top, 20)
            TabView {
                // Main tab that displays information
                MainTab()
                    .tabItem {
                       Image(systemName: "dollarsign.circle.fill")
                           
                       Text("Home")
                        
                    }
//
//                // Edit tab to add or remove stocks
                EditTab()
                   .tabItem {
                      Image(systemName: "waveform.and.magnifyingglass")
                      Text("Search")
                   }
//                // Edit tab to add or remove stocks
                ProfileTab()
                   .tabItem {
                      Image(systemName: "person.fill")
                      Text("Profile")
                   }
            }
            Spacer()
        }.background(Color.white)
    }
}
