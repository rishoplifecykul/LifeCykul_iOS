//
//  OTPScreen.swift
//  LifeCykul
//
//  Created by Rishop Babu on 25/03/25.
//

import SwiftUI

struct OTPView: View {
    @State private var otpText: [String] = Array(repeating: "", count: 6)
    @State private var timeRemaining = 180 // 3 minutes countdown
    @State private var timerActive = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Timer Circle
                ZStack {
                    Circle()
                        .stroke(Color.green.opacity(0.3), lineWidth: 6)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / 180)
                        .stroke(Color.green, lineWidth: 6)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: timeRemaining)
                    
                    Text(formatTime(timeRemaining))
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(width: 90, height: 90)
                
                // OTP Title
                Text(StringConstants.enterOtp)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                // OTP Input Fields
                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: $otpText[index])
                            .frame(width: 50, height: 50)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .font(.title)
                            .onChange(of: otpText[index]) { newValue in
                                if newValue.count > 1 {
                                    otpText[index] = String(newValue.prefix(1))
                                }
                            }
                    }
                }
                
                // Instruction Text
                Text(StringConstants.otpInstruction)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                // Resend OTP Button
                Button(action: {
                    resetTimer()
                }) {
                    Text(StringConstants.resendOTP)
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                }
                
                // Proceed Button
                Button(action: {
                    print("Proceed with OTP")
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
                
                Spacer()
            }
            .padding()
            .navigationTitle(StringConstants.verifyOTP)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { print("Back action") }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
            .background(Color.white)
            .onAppear {
                startTimer()
            }
        }
    }
    
    // Timer Formatter
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Timer Logic
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                timerActive = false
            }
        }
    }
    
    func resetTimer() {
        timeRemaining = 180
        timerActive = true
        startTimer()
    }
}

#Preview {
    OTPView()
}

