import SwiftUI

extension Double {
    var withoutZeros: String {
        String(format: "%.0f", self)
    }
}

enum QuestionsAmount: Double, CaseIterable {
    case five = 5.0
    case ten = 10.0
    case twenty = 20.0
}

struct UserInput {
    var multipleNumber: Int
    var questionsAmount: QuestionsAmount
    var correctAnswersCount = 0
    var currentQuestion: Double = 0.0
}

struct Question {
    var options = [Int]()
    var correctAnswer: Int = -1
}

struct ContentView: View {
    
    @State private var isGameStarted: Bool = false
    @State private var userInput: UserInput = .init(multipleNumber: 2, questionsAmount: .five)
    @State private var randomNumber = ContentView.tableRange.randomElement() ?? 2
    @State private var question: Question = .init()
    
    private static let tableRange = 2...12
    
    var body: some View {
        if isGameStarted {
            gameView
        } else {
            initialSettingsView
        }
    }
    
    var initialSettingsView: some View {
        NavigationStack {
            List {
                Section {
                    Stepper("Selected number \(userInput.multipleNumber)", value: $userInput.multipleNumber, in: ContentView.tableRange)
                    
                    Picker("Selected amount of questions", selection: $userInput.questionsAmount) {
                        ForEach(QuestionsAmount.allCases, id: \.self) { element in
                            Text("\(element.rawValue.withoutZeros)")
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.linear(duration: 0.1)) {
                                onStartTapped()
                            }
                        } label: {
                            Text("Start")
                                .frame(width: 90, height: 30)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Input values")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func onStartTapped() {
        userInput.currentQuestion = 1
        userInput.correctAnswersCount = 0
        generateQuestion()
        isGameStarted = true
    }
    
    var gameView: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Text("\(userInput.currentQuestion.withoutZeros)/\( userInput.questionsAmount.rawValue.withoutZeros)")
                    Spacer()
                }
            }
            
            Section("Question") {
                HStack {
                    Spacer()
                    Text("\(randomNumber) * \(userInput.multipleNumber) = ???")
                        .font(.largeTitle)
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                ForEach(question.options, id: \.self) { number in
                    Button {
                        submitQuestion(selectedNumber: number)
                    } label: {
                        Text("\(number)")
                            .frame(width: 50, height: 50)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
    
    private func submitQuestion(selectedNumber: Int) {
        let correctAnswer = randomNumber * userInput.multipleNumber
        
        if selectedNumber == correctAnswer {
            userInput.correctAnswersCount += 1
        }
        
        if userInput.currentQuestion >= userInput.questionsAmount.rawValue {
            print("\(userInput.correctAnswersCount)/\(userInput.questionsAmount.rawValue)")
            isGameStarted = false
            return
        }
        
        generateQuestion()
    }
    
    private func generateQuestion() {
        randomNumber = ContentView.tableRange.randomElement() ?? 2
        
        let correctAnswer = randomNumber * userInput.multipleNumber
        var options = [correctAnswer]
        
        while options.count < 3 {
            let wrongAnswer = Int.random(in: (correctAnswer - 10)...(correctAnswer + 10))
            if !options.contains(wrongAnswer) && wrongAnswer > 0 && wrongAnswer != correctAnswer {
                options.append(wrongAnswer)
            }
        }
        
        question.options = options.shuffled()
        userInput.currentQuestion += 1/3
    }
}

#Preview {
    ContentView()
}
