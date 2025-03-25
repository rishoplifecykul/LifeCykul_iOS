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
                // Title
                Text("Welcome to Lifecykul")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                // Country Code & Phone Number Input
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
                    
                    // Phone Number TextField
                    TextField("Mobile Number", text: $loginViewModel.phoneNumber)
                        .keyboardType(.numberPad)
                        .focused($isKeyboardFocused)
                        .padding()
                        .frame(height: 50)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        .onChange(of: loginViewModel.phoneNumber) { newValue in
                            loginViewModel.phoneNumber = String(newValue.prefix(10))
                            loginViewModel.validatePhoneNumber()
                        }
                }
                
                // Proceed Button
                NavigationLink(destination: NextScreenView()) {
                    Text("Proceed")
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
                
                Spacer()
                
                // Logo Image
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
        }
    }
}



// Dummy Next Screen
struct NextScreenView: View {
    var body: some View {
        Text("Next Screen")
            .font(.title)
            .navigationTitle("Next Screen")
    }
}

#Preview {
    LoginView()
}

