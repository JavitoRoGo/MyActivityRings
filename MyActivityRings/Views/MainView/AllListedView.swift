//
//  AllListedView.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 23/11/22.
//

import SwiftUI

struct AllListedView: View {
    @EnvironmentObject var model: MyViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    
    var rings: [MyModel] {
        model.myRingsData.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(rings) { ring in
                    NavigationLink(destination: EditView(ring: ring)) {
                        HStack {
                            Text(ring.date.formatted(date: .numeric, time: .omitted))
                            Spacer()
                            Text("\(ring.movement)").foregroundColor(.pink)
                            Text("\(ring.exercise)").foregroundColor(.green)
                            Text("\(ring.standUp)").foregroundColor(.blue)
                            Circle()
                                .fill(ring.isTraining ? (ring.training?.type == .toRun ? .orange : .green) : .clear)
                                .frame(width: 10)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                model.myRingsData.removeAll(where: { $0.id == ring.id })
                            } label: {
                                Label("Borrar", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(model.myRingsData.count) registros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            showingAlert = true
                        } label: {
                            Label("Borrar todo", systemImage: "trash")
                        }
                        .disabled(model.myRingsData.isEmpty)
                        Button {
                            shareButton()
                        } label: {
                            Label("Exportar", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
            .alert("Estás a punto de borrar todos los datos.\n¿Estás seguro?", isPresented: $showingAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Borrar", role: .destructive) {
                    model.myRingsData.removeAll()
                    dismiss()
                }
            } message: {
                Text("Esta acción no podrá deshacerse.")
            }
        }
    }
    
    func shareButton() {
        let ringsUrl = [getURLToShare(from: jsonFile)]
        
        let ac = UIActivityViewController(activityItems: ringsUrl, applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController!.present(ac, animated: true, completion: nil)
    }
    
    func getURLToShare(from jsonFile: String) -> URL {
        guard var url = Bundle.main.url(forResource: jsonFile, withExtension: nil),
              let documents = getDocumentDirectory() else {
            return URL(string: "")!
        }
        let file = documents.appendingPathComponent(jsonFile)
        if FileManager.default.fileExists(atPath: file.path) {
            url = file
        }
        return url
    }
}

struct AllListedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllListedView()
                .environmentObject(MyViewModel())
        }
    }
}
