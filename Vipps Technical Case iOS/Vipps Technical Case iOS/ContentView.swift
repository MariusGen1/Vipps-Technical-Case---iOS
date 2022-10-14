//
//  ContentView.swift
//  Vipps Technical Case iOS
//
//  Created by Marius Genton on 10/14/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var dataManager = DataManager()
    @State private var textFieldString = ""
    
    private func getInfo(for countryName: String) {
        if dataManager.isLoading == false { // Avoid multiple simulatneous requests
            Task { await dataManager.getData(for: countryName) }
        }
    }
    
    var body: some View {
        VStack {
            
            // Title
            Text(dataManager.country == nil ? "No country selected":dataManager.country!.name)
                .fontWeight(.bold)
                .font(.system(.title3))
            
            
            // If no country has been looked up, display instructions
            if dataManager.country == nil {
                BodyWithIcon(text: "Enter the name of a country in the text field to get its information", iconName: "info.circle")
            }
            
            
            // Otherwise, display information about the country
            else {
                // In here, we can force-unwrap the dataManager's "country" property, since we have already verified its existence.
                
                // Capital
                BodyWithIcon(text: "Capital: " + dataManager.country!.capital, iconName: "mappin.circle")
                
                // Alternative spellings count
                BodyWithIcon(text: String(dataManager.country!.altSpellings.count) + " alternative spellings", iconName: "text.magnifyingglass")
                
            }
            
            
            // Text field to enter the country name
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(uiColor: UIColor.systemGray6))
                    .frame(height: 50)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading)
                        .foregroundColor(Color(uiColor: UIColor.systemGray3))
                    TextField("Enter a country name", text: $textFieldString)
                        .submitLabel(.done)
                        .onSubmit { getInfo(for: textFieldString) }
                }
            }.padding()
            
            
            // Button to lookup the country entered (can also be done by tapping the "done" button on the keyboard)
            Button { getInfo(for: textFieldString) } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(uiColor: UIColor.systemBlue))
                        .frame(height: 50)
                    Text("Get info")
                        .foregroundColor(.white)
                }
            }
            .padding([.leading, .trailing, .bottom]) // No padding on top to put it closer to text field
            
            
            // Information label: to inform the user about the status of their request when the rersults have not been displayed yet (error/loading)
            if dataManager.isLoading {
                // The data is being fetched
                ProgressView()
                    .progressViewStyle(.circular)
            } else if dataManager.error != nil {
                // An error occurred during the last request
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text(dataManager.error!) // Can be force-unwrapped because we know for sure that it is not nil
                }
                .foregroundColor(.red)
                .padding()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
