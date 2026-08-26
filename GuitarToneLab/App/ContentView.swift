import SwiftUI

struct ContentView: View {
    @State private var model = ToneLabViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Guitar Tone Lab")
                        .font(.largeTitle.bold())
                    Text("Explora una cadena de audio nativa para guitarra.")
                        .foregroundStyle(.secondary)
                }

                Label(model.audioState.title, systemImage: model.audioState.symbolName)
                    .font(.headline)
                    .accessibilityLabel("Estado de audio: \(model.audioState.title)")

                Button("Preparar reproducción") {
                    model.preparePlayback()
                }
                .buttonStyle(.borderedProminent)
                .accessibilityHint("La reproducción real llegará en la fase 1.")

                GroupBox("Ruta de señal") {
                    Text("Player  →  Mixer  →  Effects  →  Output")
                        .font(.body.monospaced())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Tone Lab")
        }
    }
}

#Preview {
    ContentView()
}

