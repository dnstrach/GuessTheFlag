//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dominique Strachan on 8/4/23.
//

import SwiftUI

// custom modifier
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 45))
            .foregroundColor(.white)
            .fontWeight(.heavy)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionsAsked = 0
    
    @State private var countries = ["Åland Islands", "Albania", "American Samoa", "Andorra", "Angola", "Anguilla", "Antartica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Azerbaijan", "Austria","The Bahamas", "Bahrain", "Bangladesh", "Barbados", "Bosnia and Herzegovina", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bonaire", "Botswana", "Bouvet Island", "Brazil", "Brunei", "Bulgaria", "Burundi", "Burkina Faso", "Canada", "Cocos Islands", "Congo", "Central African Republic", "Republic of the Congo", "Cote d'Ivoire", "Cook Islands", "Chile", "Cameroon", "China", "Columbia", "Costa Rica", "Cuba", "Cape Verde", "Curacao", "Christmas Island", "Cyprus", "Czech Republic",
                                    "Estonia", "France", "Germany", "Ireland", "Italy", "Kosovo", "Mayotte", "Nigeria", "Poland", "Russia", "Saint Barthélemy", "Samoa", "South Africa", "Spain", "Switzerland", "United Arab Emirates", "United Kingdom", "United States", "Wallis and Futuna", "Yemen", "Zambia", "Zimbabwe"].shuffled()
    @State private var countriesAsked = [String]()
    @State private var correctAnswer = Int.random(in: 0...2)

    
    @State private var rotation = 0.0
    @State private var offset = CGFloat.zero
    @State private var buttonTapped = 0
    @State private var buttonPressed = false
    @State private var firstFlagWrong = false
    @State private var secondFlagWrong = false
    @State private var thirdFlagWrong = false
    
    var body: some View {
        ZStack {
            //Background color
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 100, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Text("\(countries.count)")
                
                Spacer()
                
                
                Text("Guess the Flag")
                //.modifier(Title())
                    .titleStyle()
                
                Spacer()
                
                VStack {
                    VStack {
                        Text(countries[correctAnswer])
                            .frame(width: 200, height: 100)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                            .italic()
                        
                    }
                    
                    VStack (spacing: 30) {
                        ForEach(0..<3, id: \.self) { number in
                            Button {
                                
                                flagTapped(number)
                                wrongFlagTapped(number)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3600.0) {
                                    //Gets rid of duplicates in one game
                                    if !countriesAsked.contains(countries[number]) {
                                        countriesAsked.append(countries[number])
                                        countries.remove(at: number)
                                    }
                                }
                                
                            } label: {
                                FlagImageView(flag: self.countries[number])
                                
                            }
                            .rotation3DEffect(.degrees(number == correctAnswer ? rotation: 0), axis: (x: 0, y: 1, z: 0))
                            .opacity(number != correctAnswer && buttonPressed ? 0.25 : 1)
                            .offset(x: firstFlagWrong && number == 0 ? self.offset : .zero, y: .zero)
                            .offset(x: secondFlagWrong && number == 1 ? self.offset : .zero, y: .zero)
                            .offset(x: thirdFlagWrong && number == 2 ? self.offset : .zero, y: .zero)
                        }
                    }
                }//VSTACK - white box
                .frame(maxWidth: 300, maxHeight: 450)
                .padding(.vertical, 60)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 60))
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if questionsAsked != 15 {
                Button("Continue", action: askQuestion)
            } else {
                Button("New Game", action: restartGame)
            }
            
        } message: {
            if questionsAsked != 15 {
                Text("Your score is \(score)")
            } else {
                Text("Final score: \(score)")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        buttonPressed = true
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            withAnimation {
                rotation += 360
            }
        } else {
            scoreTitle = "Wrong! \(countries[number]) is not the correct answer."
        }
        
        //delay to show flag animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showingScore = true
        }
        
    }
    
    // set animation for wrong flag tapped
    func wrongFlagTapped(_ number: Int) {
        buttonTapped = number

        switch buttonTapped {
        case 0 where number != correctAnswer:
            firstFlagWrong = true
            withAnimation(.easeInOut(duration: 0.5)) {
                self.offset = 200
            }
        case 1 where number != correctAnswer:
            secondFlagWrong = true
            withAnimation(.easeInOut(duration: 0.5)) {
                self.offset = 200
            }
        case 2 where number != correctAnswer:
            thirdFlagWrong = true
            withAnimation(.easeInOut(duration: 0.5)) {
                self.offset = 200
            }
        default:
            break
        }
    }
    
    // increasing question counter and reset
    func askQuestion() {
        questionsAsked += 1
        showingScore = false
        offset = .zero
        
        correctAnswer = Int.random(in: 0...2)
        
        withAnimation(.easeOut(duration: 2.0)) {
            countries.shuffle()
        }
        
        buttonPressed = false
        firstFlagWrong = false
        secondFlagWrong = false
        thirdFlagWrong = false
        
    }
    
    func restartGame() {
        //refreshing countries and countries asked array
        countries.append(contentsOf: countriesAsked)
        countriesAsked.removeAll()
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsAsked = 1
        score = 0
        
        buttonPressed = false
        firstFlagWrong = false
        secondFlagWrong = false
        thirdFlagWrong = false
        offset = .zero
    }
    
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

