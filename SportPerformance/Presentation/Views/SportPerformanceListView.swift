//
//  SportPerformanceListView.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import SwiftUI

struct SportPerformanceListView: View {
    @Environment(\.container) private var container

    var body: some View {
        SportPerformanceListContentView(
            viewModel: container.makeSportPerformanceListViewModel()
        )
    }
}

private struct SportPerformanceListContentView: View {
    @StateObject var viewModel: SportPerformanceListViewModel
    @State private var isPresentingAddView = false

    private func listItemView(_ performance: SportPerformance) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(performance.name)
                    .font(.headline)
                Spacer()
                if performance.isLocal {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "cloud")
                        .foregroundColor(.green)
                }
            }
            
            HStack {
                Text(performance.place)
                    .font(.subheadline)
                Spacer()
                Text(performance.length, format: .number.precision(.fractionLength(2)))
                    .font(.subheadline)
                Text("m")
                    .font(.subheadline)
                    
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $viewModel.filter) {
                    ForEach(SportPerformanceListViewModel.Filter.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])

                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else if let msg = viewModel.errorMessage {
                        Text(msg).foregroundColor(.red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        if viewModel.filteredPerformances.isEmpty {
                            Text(L10n.SportPerformanceList.noSavedPerformance)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            List {
                                ForEach(viewModel.filteredPerformances) { performance in
                                    listItemView(performance)
                                }
                                .onDelete { indices in
                                    Task { await viewModel.deletePerformances(at: indices) }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(L10n.SportPerformanceList.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { isPresentingAddView = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task { await viewModel.loadPerformances() }
            .sheet(
                isPresented: $isPresentingAddView,
                onDismiss: { Task { await viewModel.loadPerformances()} }
            ) {
                NavigationView { AddSportPerformanceView() }
            }
        }
    }
}

struct SportPerformanceListView_Previews: PreviewProvider {
    static var previews: some View {
        SportPerformanceListView()
            .environment(\.container, MockDIContainer())
    }
}
