//
//  ContentView.swift
//  HighestThrow
//
//  Created by Jared Davidson on 5/15/23.
//

import SwiftUI
import CoreMotion

struct ThrowGameView: View {
    let motionManager = CMMotionManager()
    @State private var highScore = 0.0
    @State private var currentThrowSpeed = 0.0

    var body: some View {
        VStack {
            Text("High Score: \(formatSpeed(highScore))")
                .font(.largeTitle)

            Text("Current Throw Speed:")
            Text("\(formatSpeed(currentThrowSpeed))")
                .font(.title)
                .fontWeight(.bold)
        }
        .onAppear {
            startAccelerometerUpdates()
        }
        .onDisappear {
            stopAccelerometerUpdates()
        }
    }

    func startAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let acceleration = data?.acceleration else { return }
            let throwSpeed = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
            if throwSpeed > highScore {
                highScore = throwSpeed
            }
            currentThrowSpeed = throwSpeed
        }
    }

    func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
    }

    func formatSpeed(_ speed: Double) -> String {
        let formattedSpeed = String(format: "%.2f m/s", speed)
        return formattedSpeed
    }
}

struct ContentView: View {
    var body: some View {
        ThrowGameView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
