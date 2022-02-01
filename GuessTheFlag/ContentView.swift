//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Caio Feitoza Martins on 21/06/21.
//

import SwiftUI

struct FlagImage: View {
    var fileName: String
    
    var body: some View {
        
        Image(fileName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
        }
    }


struct ContentView: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreTotal = 0
    
    @State private var rotationAmount = 0.0
    @State private var opacityAmount = 1.0
    
    var body: some View {
        ZStack  {
            LinearGradient(gradient: Gradient(colors: [Color.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        VStack(spacing: 30) {
        VStack{
            Text("Tap the flag of")
                .foregroundColor(.white)
            Text(countries[correctAnswer])
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.black
                )
        }
        ForEach(0 ..< 3) { number in
            Button(action: {
                self.flagTapped(number)
                opacityAmount = 0.25
            }) {
                FlagImage(fileName: self.countries[number])
                    .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                }
            .rotation3DEffect(.degrees(number == correctAnswer ? rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
            .opacity(number == correctAnswer ? 1 : opacityAmount)
            }
            
            VStack{
                Text("Score: \(scoreTotal)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
            
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(scoreTotal)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer  {
            scoreTitle = "Correct"
            scoreTotal += 1
            
            rotationAmount = 0.0
            
            withAnimation() {
                self.rotationAmount = 360
            }
        }   else{
            scoreTitle = "Wrong! That was the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        rotationAmount = 0.0
        opacityAmount = 1.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
