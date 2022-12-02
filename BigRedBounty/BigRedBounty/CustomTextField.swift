//
//  CustomTextField.swift
//  BigRedBounty
//
//  Created by user228377 on 11/27/22.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
