//
//  ContentView.swift
//  EdutainmentApp
//
//  Created by Иван Лясковец on 03.08.2023.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - States
	
	//Settings
	@State private var numberOfQuestions: [Int] = [5, 10, 20]
	@State private var numberForTraining = 2
	@State private var questionCount: Int?
	@State private var isShowingError: Bool = false

	// Game
	@State private var isGamePlaying: Bool = false
	@State private var isEndOfgame = false
	@State private var gameRound = 1
	@State private var userScore = 0
	
	// Round
	@State private var isShownRoundAlert = false
	@State private var roundResultAlertTitle = ""
	@State private var roundResultAlertMessage = ""
	@State private var randomNumber = Int.random(in: 1...10)
	@State private var userAnswer = ""
	
	// MARK: - UI
	
    var body: some View {
		NavigationView {
			if isGamePlaying {
				ZStack {
					LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
						.ignoresSafeArea()
					VStack {
						Text("ROUND \(gameRound)")
							.font(.system(size: 45, weight: .bold))
						Text("What is result of:")
							.font(.title)
						Text("\(numberForTraining) x \(randomNumber)")
							.font(.title2)
						
						TextField("Enter number", text: $userAnswer)
							.keyboardType(.numberPad)
							.padding()
							.background(.white)
							.border(.blue, width: 2)
							.padding()
						
						Button {
							checkAnswer()
						} label: {
							Text("Check")
								.frame(width: 90, height: 10)
								.font(.title2)
								.padding()
								.background(.blue)
								.foregroundColor(.white)
								.clipShape(RoundedRectangle(cornerRadius: 5))
								
						}
						.padding()
					}
				}
			} else {
				ZStack {
					LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
						.ignoresSafeArea()
					VStack {
						Spacer()
						
						// Number for trainging
						Text ("Number for training")
							.font(.system(size: 24, weight: .bold))
						Stepper(value: $numberForTraining, in: 2...12) {
							Text("Current number: \(numberForTraining)")
								.font(.title2)
	
						}
						.padding(EdgeInsets(top: 15, leading: 50, bottom: 0, trailing: 50))
						Spacer()
						
						// Number of questions
						Text ("Number of questions")
							.font(.system(size: 24, weight: .bold))
						HStack {
							ForEach(numberOfQuestions, id: \.self) { number in
								Button {
									withAnimation {
										changeNumberOfQuestions(number: number)
									}
								} label: {
									Text("\(number)")
										.frame(width: 60, height: 60)
										.font(.title)
										.background(questionCount == nil || questionCount != number ? .white: .blue)
										.foregroundColor(questionCount == nil || questionCount != number ? .blue: .white)
										.clipShape(RoundedRectangle(cornerRadius: 20))
										.padding()
								}
							}
						}
						Spacer()
						
						// Start Button
						Button {
							startGame()
						} label: {
							Text("Start Trainig")
								.font(.title2)
								.padding()
								.background(.blue)
								.foregroundColor(.white)
								.clipShape(RoundedRectangle(cornerRadius: 20))
						}
						Spacer()
					}
				}.navigationTitle("TRAIN YOURSELF")
			}
		}
		.alert("Ooups!", isPresented: $isShowingError) {
		} message: {
			Text("Choose number of questions and try again!")
		}
		.alert(roundResultAlertTitle, isPresented: $isShownRoundAlert) {
			Button("Next round", action: startNewRound)
		}
		.alert("The End", isPresented: $isEndOfgame) {
			Button("New Game") {
				restartGame()
			}
		} message: {
			Text("Your score: \(userScore)")
		}
    }
}

// MARK: - Private methods

extension ContentView {
	private func startGame() {
		if questionCount == nil {
			isShowingError = true
		} else {
			isGamePlaying.toggle()
		}
	}
	
	private func restartGame() {
		isEndOfgame = false
		isGamePlaying = false
		isShownRoundAlert = false
		userScore = 0
		gameRound = 1
		questionCount = nil
		userAnswer = ""
	}
	
	private func startNewRound() {
		randomNumber = Int.random(in: 1...10)
		gameRound += 1
		userAnswer = ""
	}
	
	private func changeNumberOfQuestions(number: Int) {
		questionCount = number
	}
	
	private func checkAnswer() {
		if gameRound == questionCount {
			isEndOfgame = true
			return
		}
		
		guard let answer = Int(userAnswer) else { return }
		let correntNumber = numberForTraining * randomNumber
		if answer == correntNumber {
			roundResultAlertTitle = "AWESOME!"
			roundResultAlertMessage = "Correct!"
			userScore += 1
			isShownRoundAlert.toggle()
		} else {
			roundResultAlertTitle = "OOUPS!"
			roundResultAlertMessage = "Incorrenct answer!"
			isShownRoundAlert.toggle()
		}
	}
}

// MARK: - PreviewProvider

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
