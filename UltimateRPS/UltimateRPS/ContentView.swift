//
//  ContentView.swift
//  UltimateRPS
//
//  Created by Austin Bond on 6/11/24.
//
//
//  ContentView.swift
//  UltimateRPS
//
//  Created by Austin Bond on 6/11/24.
//

import SwiftUI

// Main view of the app
struct ContentView: View {
    // Array of possible moves
    let moves = ["✊", "✋", "✌️"]

    // State properties to manage game state
    @State private var computerChoice = Int.random(in: 0..<3) // Randomly select the computer's move
    @State private var shouldWin = Bool.random() // Randomly decide if the player should win or lose
    @State private var score = 0 // Player's score
    @State private var questionCount = 1 // Number of questions asked
    @State private var showingResults = false // Boolean to track when to show results
    @State private var animateComputerMove = false // Boolean to track when to animate the computer's move
    @State private var showChoices = [false, false, false] // Booleans to track the visibility of choices

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.33, green: 0.84, blue: 0.31), location: 0.0),
                    .init(color: Color(red: 0.33, green: 0.84, blue: 0.31), location: 0.17),
                    .init(color: Color(red: 1.0, green: 0.89, blue: 0.20), location: 0.17),
                    .init(color: Color(red: 1.0, green: 0.89, blue: 0.20), location: 0.34),
                    .init(color: Color(red: 0.99, green: 0.61, blue: 0.19), location: 0.34),
                    .init(color: Color(red: 0.99, green: 0.61, blue: 0.19), location: 0.51),
                    .init(color: Color(red: 0.95, green: 0.25, blue: 0.24), location: 0.51),
                    .init(color: Color(red: 0.95, green: 0.25, blue: 0.24), location: 0.68),
                    .init(color: Color(red: 0.33, green: 0.33, blue: 0.83), location: 0.68),
                    .init(color: Color(red: 0.33, green: 0.33, blue: 0.83), location: 0.85),
                    .init(color: Color(red: 0.15, green: 0.68, blue: 0.99), location: 0.85),
                    .init(color: Color(red: 0.15, green: 0.68, blue: 0.99), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            // Ignore safe area to make gradient cover the whole screen
            .ignoresSafeArea()

            VStack {
                Spacer()

                // Display the computer's move
                VStack {
                    if animateComputerMove {
                        Text(moves[computerChoice])
                            .font(.system(size: 250))
                            .transition(.scale) // Scale transition
                    } else {
                        Text(moves[computerChoice])
                            .font(.system(size: 250))
                    }
                }
                .frame(maxWidth: 300)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()

                // Display the prompt and player choices
                VStack {
                    Text(shouldWin ? "Which one wins?" : "Which one loses?")
                        .foregroundColor(shouldWin ? .green : .red)
                        .font(.headline)
                        .fontWeight(.heavy)

                    HStack {
                        ForEach(0..<3) { number in
                            Button(moves[number]) {
                                play(choice: number) // Action when a choice is made
                            }
                            .font(.system(size: 80))
                            .opacity(showChoices[number] ? 1 : 0) // Control visibility with opacity
                            .animation(.easeIn(duration: 0.5).delay(Double(number) * 0.2), value: showChoices[number])
                        }
                    }
                }
                .frame(maxWidth: 300)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onAppear {
                    animateChoices() // Animate choices when view appears
                }

                Spacer()

                // Display the score
                VStack {
                    Text("Score: \(score)")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: 80)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
            }
            .alert("Game over", isPresented: $showingResults) {
                Button("Play Again", action: reset) // Reset the game when "Play Again" is tapped
            } message: {
                Text("Your score was \(score)")
            }
        }
    }

    // Function to animate the display of choices
    func animateChoices() {
        for index in 0..<showChoices.count {
            // Delay animations to make them appear sequentially
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                withAnimation {
                    showChoices[index] = true
                }
            }
        }
    }

    // Function to handle player's choice
    func play(choice: Int) {
        let winningMoves = [1, 2, 0] // Moves that beat each corresponding move in 'moves' array
        let didWin: Bool

        // Determine if player's choice wins or loses
        if shouldWin {
            didWin = choice == winningMoves[computerChoice]
        } else {
            didWin = winningMoves[choice] == computerChoice
        }

        // Update score based on the result
        if didWin {
            score += 1
        } else {
            score -= 1
        }

        // Check if it's the last question
        if questionCount == 10 {
            showingResults = true // Show results if it's the last question
        } else {
            withAnimation {
                // Prepare for the next round
                computerChoice = Int.random(in: 0..<3)
                shouldWin.toggle()
                questionCount += 1
                animateComputerMove.toggle()
                resetChoices() // Reset choices visibility
            }
            animateChoices() // Animate choices for the next round
        }
    }

    // Function to reset choices' visibility
    func resetChoices() {
        withAnimation {
            showChoices = [false, false, false]
        }
    }

    // Function to reset the game
    func reset() {
        computerChoice = Int.random(in: 0..<3)
        shouldWin = Bool.random()
        questionCount = 1
        score = 0
        resetChoices()
        animateChoices()
    }
}

#Preview {
    ContentView()
}
