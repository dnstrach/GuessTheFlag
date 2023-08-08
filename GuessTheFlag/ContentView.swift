//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dominique Strachan on 8/4/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionsAsked = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var countriesAsked = [String]()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 100, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.title.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                            .italic()
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            
                            if !countriesAsked.contains(countries[number]) {
                                countriesAsked.append(countries[number])
                                countries.remove(at: number)
                            }
                            
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                //.clipShape(Capsule())
                                .shadow(radius: 10)
                        }
                    }
                }
                .frame(maxWidth: 300)
                .padding(.vertical, 40)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 60))
                
                //Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if questionsAsked != 5 {
                Button("Continue", action: askQuestion)
            } else if questionsAsked == 5 {
                Button("New Game", action: restartGame)
            }
            
        } message: {
            if questionsAsked != 5 {
                Text("Your score is \(score)")
            } else if questionsAsked == 5  {
                Text("Final score: \(score)")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! \(countries[number]) is not the correct answer."
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        //countries.shuffle()
        questionsAsked += 1
    
    }
    
    func restartGame() {
        countries.append(contentsOf: countriesAsked)
        countriesAsked.removeAll()
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsAsked = 1
        score = 0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
