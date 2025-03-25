//
//  LoginViewModel.swift
//  LifeCykul
//
//  Created by Rishop Babu on 25/03/25.
//

import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var selectedCountry: CountryCodeModel = (CountryCodeModel.allCountries.first ?? CountryCodeModel.init(code: "+91", name: "India"))
    @Published var mobileNumber: String = ""
    @Published var isPhoneNumberValid: Bool = false
    @Published var isLoading: Bool = false
    @Published var otpSent: Bool = false
    @Published var errorMessage: String?
    @Published var navigateToOTP: Bool = false
    @Published var navigateToRegister: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func validatePhoneNumber() {
        isPhoneNumberValid = mobileNumber.count == 10
    }
    
    func sendOTP() {
        guard isPhoneNumberValid else {
            print("Invalid number")
            errorMessage = StringConstants.phoneNumberValidation
            return
        }
        isLoading = true
        errorMessage = nil
        
        let parameters = [
            "mobileNumber": mobileNumber,
            "code": selectedCountry.code,
            "type": StringConstants.loginType
        ]
        
        NetworkService.shared.post(endpoint: URLConstants.loginURL, body: parameters)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to send OTP: \(error.localizedDescription)"
                }
            }, receiveValue: { (response: LoginResponse) in
                self.isLoading = false
                if response.resultStatus == "true" {
                    self.navigateToOTP = true
                } else {
                    self.navigateToRegister = true
                }
            })
            .store(in: &cancellables)
    }
}
