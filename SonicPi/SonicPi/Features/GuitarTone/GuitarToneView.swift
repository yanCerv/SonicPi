//
//  GuitarTone.swift
//  SonicPi
//
//  Created by Yan Cervantes  on 26/08/26.
//

import SwiftUI
import GuitarToneLab

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
          Text("Laboratorio de audio de SonicPi")
            .foregroundStyle(.secondary)
        }
        
        //Controls
        GuitarTonePlaybackControls(status: viewModel.status, output: viewModel)
      }
      .padding()
      .navigationTitle("SonicPi")
      .sheet(item: $viewModel.showEffect, content: { effect in
        switch effect {
          case .equalizer:
          GuitarToneEqualizerControls(settings: viewModel.equalizerSettings, output: viewModel)
        case .delay:
          GuitarToneDelayControls(settings: viewModel.delaySettings, output: viewModel)
        case .reverb:
          GuitarToneReverbControls(settings: viewModel.reverbSettings, output: viewModel)
        }
      })
      .alert(viewModel.message, isPresented: $viewModel.showError) {
        Button("Ok") {
          //No-Op
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
