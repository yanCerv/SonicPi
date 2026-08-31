//
//  GuitarTone.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

import SwiftUI

struct GuitarToneView: View {
  
  @State private var viewModel: GuitarToneViewModel = GuitarToneViewModel()

  var body: some View {
    NavigationStack {
      VStack(spacing: 24) {
        Image(systemName: "guitars")
          .font(.system(size: 64))
          .foregroundStyle(.tint)
          .accessibilityHidden(true)

        VStack(spacing: 8) {
          Text("Guitar Tone Lab")
            .font(.largeTitle.bold())
          Text("Primer laboratorio de audio de SonicPi")
            .foregroundStyle(.secondary)
        }
        
        //Controls
        GuitarTonePlaybackControls(status: viewModel.status, output: viewModel)
        
        GroupBox("Cadena planeada") {
          Text("Player  →  Mixer  →  Effects  →  Output")
            .font(.body.monospaced())
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }

        Spacer()
      }
      .padding()
      .navigationTitle("SonicPi")
      .sheet(isPresented: $viewModel.showEqualizer, content: {
        GuitarToneEqualizerControls(settings: viewModel.equalizerSettings, output: viewModel)
      })
      .sheet(isPresented: $viewModel.showDelay, content: {
        GuitarToneDelayControls(settings: viewModel.delaySettings, output: viewModel)
      })
      .sheet(isPresented: $viewModel.showReverb, content: {
        GuitarToneReverbControls(settings: viewModel.reverbSettings, output: viewModel)
      })
      .alert(viewModel.message, isPresented: $viewModel.showError) {
        Button("Ok") {
       // Todo some alert action
        }
      }
      .task {
        viewModel.initialState()
      }
    }
  }
}

#Preview {
  GuitarToneView()
}
