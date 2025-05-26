import Foundation
import GooglePlaces

class CityAutoComplete: ObservableObject
{
    @Published var searchText: String = "" // User's input text
    @Published var suggestions: [String] = [] // Autocomplete suggestions

    private var token = GMSAutocompleteSessionToken() // Session token for requests

    func fetchSuggestions()
    {
        guard !searchText.isEmpty else
        {
            suggestions = [] // Clear suggestions if input is empty
            return
        }

        let request = GMSAutocompleteRequest(query: searchText)
        request.sessionToken = token
        
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        request.filter = filter

        GMSPlacesClient.shared().fetchAutocompleteSuggestions(from: request)
        {
            [weak self] (results, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Autocomplete error: \(error.localizedDescription)")
                self.suggestions = []
                return
            }
            
            if let results = results
            {
                self.suggestions = results.filter { $0.placeSuggestion?.types.contains("locality") ?? false }.prefix(5).compactMap { $0.placeSuggestion?.attributedPrimaryText.string }
            }
        }
    }
}

