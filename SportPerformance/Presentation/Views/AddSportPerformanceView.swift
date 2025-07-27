//
//  AddSportPerformanceView.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import SwiftUI

struct AddSportPerformanceView: View {
    @Environment(\.container) private var container

    var body: some View {
        AddSportPerformanceContentView(
            viewModel: container.makeAddSportPerformanceViewModel()
        )
    }
}

private struct AddSportPerformanceContentView: View {
    
    private enum Field: Hashable {
      case name, place, length
    }
    
    @StateObject var viewModel: AddSportPerformanceViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    var body: some View {
        Form {
            TextField(L10n.AddSportPerformance.namePlaceholder, text: $viewModel.name)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .place }

            TextField(L10n.AddSportPerformance.placePlaceholder, text: $viewModel.place)
                .focused($focusedField, equals: .place)
                .submitLabel(.next)
                .onSubmit { focusedField = .length }

            TextField(L10n.AddSportPerformance.lengthPlaceholder, text: $viewModel.length)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .length)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = nil
                }

            Picker("", selection: $viewModel.saveMode) {
                Text(L10n.AddSportPerformance.saveLocal).tag(SaveMode.local)
                Text(L10n.AddSportPerformance.saveRemote).tag(SaveMode.backend)
            }
            .pickerStyle(.segmented)
        }
        .navigationTitle(L10n.AddSportPerformance.navigationTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(L10n.AddSportPerformance.saveButton) {
                    Task {
                        await viewModel.save()
                        if viewModel.error == nil {
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.isValid || viewModel.isSaving)
            }
            if focusedField == .length {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L10n.AddSportPerformance.doneButton) {
                        focusedField = nil
                    }
                }
            }
        }
        .alert(item: $viewModel.error) { err in
            Alert(title: Text(err.localizedDescription), dismissButton: .default(Text(L10n.AddSportPerformance.okButton)))
        }
        .onAppear { focusedField = .name }
    }
}

struct AddSportPerformanceView_Previews: PreviewProvider {
    static var previews: some View {
        AddSportPerformanceView()
            .environment(\.container, MockDIContainer())
    }
}
