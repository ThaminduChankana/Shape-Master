//
//  ShapeGameView.swift
//  Shape Master
//
//  Created by Thamindu Gamage on 2024-06-07.
//

import SwiftUI
import AVFoundation

struct ShapeGameView: View {
    let shapes = [
        "circle", "triangle", "rectangle", "ellipse",
        "square", "right triangle", "parallelogram", "heart",
        "rectangle prism", "cone", "cylinder", "star",
        "trapezoid", "rhombus", "cube", "pentagon",
        "hexagon", "heptagon", "octagon", "decagon"
    ]
    
    @State private var currentShapeIndex = 0
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Text("Which shape is this?")
                .font(.largeTitle)
                .padding()
            
            CardView {
                Image(shapes[currentShapeIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .padding()
            }
            .onAppear {
                loadNextShape()
            }
            
            let options = generateOptions()
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(options, id: \.self) { shape in
                    Button(action: {
                        checkAnswer(selectedShape: shape)
                    }) {
                        Text(shape.capitalized)
                            .padding()
                            .frame(width: 150, height: 50)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.title)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(""),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    loadNextShape()
                }
            )
        }
    }
    
    func generateOptions() -> [String] {
        var options = shapes.shuffled().filter { $0 != shapes[currentShapeIndex] }
        options = Array(options.prefix(3))
        options.append(shapes[currentShapeIndex])
        return options.shuffled()
    }
    
    func checkAnswer(selectedShape: String) {
        if selectedShape == shapes[currentShapeIndex] {
            alertMessage = "Correct! This is a \(selectedShape)."
            playSound(name: "success")
        } else {
            alertMessage = "Try again!"
            playSound(name: "failure")
        }
        showingAlert = true
    }
    
    func loadNextShape() {
        currentShapeIndex = Int.random(in: 0..<shapes.count)
    }
    
    func playSound(name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
}

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
            .padding()
    }
}

#Preview {
    ShapeGameView()
}

