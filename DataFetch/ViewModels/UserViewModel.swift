//
//  ViewModel.swift
//  DataFetch
//
//  Created by Bhavitha Gottimukkula on 09/08/24.
//

import Foundation

class UserViewModel {
    var users:[User] = []
    
    func fetchData() async {
        let fetchRequest = APIRequest()
        
        if #available(iOS 15.0, *) {
            do {
                let userData: User = try await NetworkManager.shared.perform(request: fetchRequest, retries: 5, decodeTo: User.self)
                print("Fetched data: \(userData)")
                users.append(userData)
            }
            catch {
                print("Failed to fetch data: \(error)")
            }
        }
    }
}
