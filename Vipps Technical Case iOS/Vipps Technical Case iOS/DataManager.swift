//
//  DataManager.swift
//  Vipps Technical Case iOS
//
//  Created by Marius Genton on 10/14/22.
//

import Foundation

class DataManager: ObservableObject { // Used to manage everything that has to do with data (async download, processing...)
    
    @Published var isLoading = false // Useful to display activity indicator
    @Published var error: String? // Error description to help user/developer understand any unexpected behaviour
    @Published var country: Country? // Stores info about the last country looked up by the user
    
    
    private func finishWithError(description: String) {
        DispatchQueue.main.async {
            self.error = description
            self.isLoading = false
        }
    }
    
    func getData(for countryName: String) async { // Downloads the data given the country name (if valid)
        
        DispatchQueue.main.async { self.isLoading = true } // Start activity indicator
        
        do {
            // Spaces need to be converted to %20, otherwise the operation will fail
            let formattedCountryName = countryName.replacingOccurrences(of: " ", with: "%20")
            
            guard let url = URL(string: "https://restcountries.com/v2/name/" + formattedCountryName)
            else {
                finishWithError(description: "Country names cannot contain special characters")
                return
            }
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                finishWithError(description: "Error: invalid country name")
                return
            }
            let countryData = try JSONDecoder().decode([Country].self, from: data)
            // Parse JSON: it is given as an array containing a single object with all the information about the country, which is why we will be using countryData[0]
            
            DispatchQueue.main.async {
                self.error = nil
                self.country = countryData[0]
                self.isLoading = false
            }
        } catch {
            finishWithError(description: "Error. Please make sure that you are connected to the internet and have entered a valid country name. Details: " + error.localizedDescription)
        }
    }
    
    
}
