//
//  ContentView.swift
//  Shape Master
//
//  Created by Thamindu Gamage on 2024-06-07.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    enum ViewSelection: String, CaseIterable, Identifiable {
        case main = "Learn Shape"
        case game = "Shape Game"
        
        var id: String { self.rawValue }
    }
    
    @State private var selectedView: ViewSelection = .main
    
    let shapes = [
        "circle", "triangle", "rectangle", "ellipse",
        "square", "right triangle", "parallelogram", "heart",
        "rectangle prism", "cone", "cylinder", "star",
        "trapezoid", "rhombus", "cube", "pentagon",
        "hexagon", "heptagon", "octagon", "decagon"
    ]
    
    let descriptions = [
        "A round shape with all points equidistant from the center.",
        "A shape with three sides and three angles.",
        "A shape with four sides and four right angles.",
        "An oval shape, a stretched circle.",
        "A shape with four equal sides and four right angles.",
        "A triangle with one angle of 90 degrees.",
        "A four-sided shape with opposite sides parallel and equal.",
        "A shape representing a stylized heart.",
        "A three-dimensional shape with six rectangular faces.",
        "A three-dimensional shape with a circular base and a pointed top.",
        "A three-dimensional shape with two parallel circular bases.",
        "A star-shaped figure with pointed edges.",
        "A four-sided shape with only one pair of parallel sides.",
        "A four-sided shape where all sides have equal length but opposite angles are equal.",
        "A three-dimensional shape with six equal square faces.",
        "A shape with five sides and five angles.",
        "A shape with six sides and six angles.",
        "A shape with seven sides and seven angles.",
        "A shape with eight sides and eight angles.",
        "A shape with ten sides and ten angles."
    ]
    
    @State private var currentIndex = 0
    @State private var audioPlayer: AVAudioPlayer?
    @State private var shapeAudioPlayer: AVAudioPlayer?

    var capitalizedShape: String {
        let shape = shapes[currentIndex]
        return shape.capitalized
    }

    var body: some View {
        VStack {
            Picker("Select View", selection: $selectedView) {
                ForEach(ViewSelection.allCases) { view in
                    Text(view.rawValue).tag(view)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            switch selectedView {
            case .main:
                mainView
            case .game:
                ShapeGameView()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .onAppear {
            playBackgroundMusic()
        }
    }

    var mainView: some View {
        HStack {
            ZStack {
                VStack {
                    Text(capitalizedShape)
                        .font(.largeTitle)
                        .padding()

                    Spacer()

                    // Card View
                    ZStack {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.white)
                            .shadow(radius: 10)
                        
                        VStack {
                            Image(shapes[currentIndex])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 160)
                                .padding()
                            
                            Text(descriptions[currentIndex])
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .shadow(color: .gray, radius: 2, x: 0, y: 2) // Shadow for description
                        }
                        .padding()
                    }
                    .frame(width: 400, height: 250)
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            if currentIndex > 0 {
                                currentIndex -= 1
                                playAudio(for: shapes[currentIndex])
                            }
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Color(.systemBackground)) // Same as icon background color
                                .clipShape(Circle())
                        }

                        Spacer()

                        Button(action: {
                            if currentIndex < shapes.count - 1 {
                                currentIndex += 1
                                playAudio(for: shapes[currentIndex])
                            }
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Color(.systemBackground)) // Same as icon background color
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                }
                
                // Fairy image outside the card
                Image("fairy")
                    .resizable()
                    .frame(width: 200, height: 300)
                    .offset(x: -220, y: -100)
            }

            Divider()
                .frame(height: 300)
            
            List(shapes.indices, id: \.self) { index in
                Button(action: {
                    currentIndex = index
                    playAudio(for: shapes[index])
                }) {
                    Text(shapes[index].capitalized)
                        .padding()
                        .foregroundColor(currentIndex == index ? .black : .primary) // Highlight selected item color
                        .cornerRadius(8)
                        .font(.title)
                }
            }
            .frame(width: 250)
        }
    }

    func playBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "background", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.volume = 0.2
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing background music: \(error.localizedDescription)")
            }
        }
    }

    func playAudio(for shape: String) {
        if let bundle = Bundle.main.path(forResource: shape, ofType: "mp3") {
            let shapeAudio = NSURL(fileURLWithPath: bundle)
            do {
                shapeAudioPlayer = try AVAudioPlayer(contentsOf: shapeAudio as URL)
                shapeAudioPlayer?.prepareToPlay()
                shapeAudioPlayer?.play()
            } catch {
                print("Error playing shape audio: \(error.localizedDescription)")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

