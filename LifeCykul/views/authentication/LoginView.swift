//
//  LoginView.swift
//  LifeCykul
//
//  Created by Rishop Babu on 25/03/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @FocusState private var isKeyboardFocused: Bool // For dismissing the keyboard
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text(StringConstants.welcomeText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                HStack {
                    Menu {
                        ForEach(CountryCodeModel.allCountries, id: \.id) { country in
                            Button(action: {
                                loginViewModel.selectedCountry = country
                            }) {
                                Text("\(country.code) \(country.name)")
                            }
                        }
                    } label: {
                        HStack {
                            Text(loginViewModel.selectedCountry.code)
                                .fontWeight(.medium)
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .frame(width: 100, height: 50)
                        .background(Color.green.opacity(0.2))
                        .foregroundStyle(Color.black)
                        .cornerRadius(10)
                    }
                    
                    TextField(StringConstants.mobileNumber, text: $loginViewModel.mobileNumber)
                        .keyboardType(.numberPad)
                        .focused($isKeyboardFocused)
                        .padding()
                        .frame(height: 50)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        .onChange(of: loginViewModel.mobileNumber) { newValue in
                            loginViewModel.mobileNumber = String(newValue.prefix(10))
                            loginViewModel.validatePhoneNumber()
                        }
                }
                
                Button(action: {
                    loginViewModel.sendOTP()
                }) {
                    Text(StringConstants.proceed)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(!loginViewModel.isPhoneNumberValid)
                .opacity(loginViewModel.isPhoneNumberValid ? 1 : 0.5)
                
                if loginViewModel.isLoading {
                    ProgressView()
                }
                
                if let error = loginViewModel.errorMessage, !error.isEmpty {
                    Text(error).foregroundColor(.red)
                }
                
                Spacer()
                
                Image("LifecykulLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
            }
            .padding()
            .background(Color(.systemBackground))
            .onTapGesture {
                isKeyboardFocused = false
            }
            .navigationDestination(isPresented: $loginViewModel.navigateToOTP) {
                OTPView()
            }
            .navigationDestination(isPresented: $loginViewModel.navigateToRegister) {
                SignUpView()
            }
        }
    }
}

#Preview {
    LoginView()
}

