//
//  MainView.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 21/11/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var model: MyViewModel
    @State private var showingAddNew = false
    
    var body: some View {
        NavigationStack {
            if model.myRingsData.isEmpty {
                VStack(spacing: 100) {
                    VStack {
                        Text("Añade algunos datos para")
                        Text("comenzar a usar la app...")
                    }
                    .font(.title)
                    Button {
                        showingAddNew = true
                    } label: {
                        Text("Añadir")
                            .font(.largeTitle)
                    }
                    .buttonStyle(.bordered)
                }
            } else {
				VStack {
					ScrollView(.horizontal) {
						LazyHStack {
							ForEach(model.myRingsData) { ring in
								VStack {
									Text(ring.date.formatted(date: .complete, time: .omitted))
										.font(.title2)
									HStack {
										Image(systemName: "arrow.left")
											.opacity(
												ring.id == model.myRingsData.first!.id ? 0 : 1
											)
										Spacer()
										Image(systemName: "arrow.right")
											.opacity(
												ring.id == model.myRingsData.last!.id ? 0 : 1
											)
									}
									.foregroundColor(.secondary)
									.padding(.horizontal)
									RingView(data: ring)
										.padding()
									
									ListView(data: ring)
								}
								.padding(.trailing)
								.containerRelativeFrame(.horizontal)
							}
						}
						.safeAreaPadding(.horizontal)
						.scrollTargetLayout()
					}
					.scrollIndicators(.hidden)
					.scrollTargetBehavior(.viewAligned)
				}
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: AllListedView()) {
                            Label("Listado", systemImage: "list.bullet")
                        }
                        .disabled(model.myRingsData.isEmpty)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddNew = true
                        } label: {
                            Label("Nuevo", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddNew) {
            NavigationStack {
                AddNewView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancelar") {
                                showingAddNew = false
                            }
                        }
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MyViewModel())
    }
}
