//
//  LoginViewModel.swift
//  LifeCykul
//
//  Created by Rishop Babu on 25/03/25.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var selectedCountry: CountryCodeModel = (CountryCodeModel.allCountries.first ?? CountryCodeModel.init(code: "+91", name: "India"))
    @Published var phoneNumber: String = ""
    @Published var isPhoneNumberValid: Bool = false
    
    func validatePhoneNumber() {
        isPhoneNumberValid = phoneNumber.count == 10
    }
}
