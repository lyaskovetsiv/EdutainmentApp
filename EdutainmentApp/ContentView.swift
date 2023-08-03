//
//  ContentView.swift
//  EdutainmentApp
//
//  Created by Иван Лясковец on 03.08.2023.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - States
	@State private var isGamePlaying: Bool = false
	@State private var isShowingError: Bool = false
	@State private var numberForTraining = 2
	@State private var numberOfQuestions: [Int] = [5, 10, 20]
	@State private var questionCount: Int?
	
	// MARK: - UI
	
    var body: some View {
		NavigationView {
			if isGamePlaying {
				ZStack {
					LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
						.ignoresSafeArea()
					Button {
						toggleGame()
					} label: {
						Text("Restart")
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
							toggleGame()
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
		.alert("WARNING!", isPresented: $isShowingError) {
			
		} message: {
			Text("Choose number of questions and try again!")
		}
    }
	
	// MARK: - Private methods
	
	private func toggleGame() {
		if !isGamePlaying {
			if questionCount == nil {
				isShowingError = true
			} else {
				isGamePlaying.toggle()
			}
		} else {
			isGamePlaying.toggle()
		}
	}
	
	private func changeNumberOfQuestions(number: Int) {
		questionCount = number
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
