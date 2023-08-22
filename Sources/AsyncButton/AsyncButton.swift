import SwiftUI

public struct AsyncButton<Label> : View where Label : View {
    private let role: ButtonRole?
    private let options: AsyncButtonOptions
    private let transaction: Transaction
    private let action: () async throws -> Void
    private let label: ([AsyncButtonOperation]) -> Label
    
    @State private var operations: [AsyncButtonOperation] = []
    @State private var showingErrorAlert = false
    @State private var localizedError: AnyLocalizedError?

    #if os(iOS)
        private let generator = UINotificationFeedbackGenerator()
    #endif

    @State private var tint: Color?
    
    var operationIsLoading: Bool {
        operations.contains { operation in
            if case .loading = operation {
                return true
            } else {
                return false
            }
        }
    }
    
    var showProgressView: Bool {
        options.contains(.showProgressViewOnLoading) && operationIsLoading
    }
    
    var disableButton: Bool {
        options.contains(.disableButtonOnLoading) && operationIsLoading
    }
    
    public var body: some View {
        Button(
            role: role,
            action: {
                if options.contains(.disallowParallelOperations) {
                    guard operationIsLoading == false else { return }
                }
                let actionTask = Task {
                    try await action()
                }
                operations.append(.loading(actionTask))
                Task {
                    if options.contains(.enableNotificationFeedback) {
                        #if os(iOS)
                            generator.prepare()
                        #endif
                    }
                    let result = await actionTask.result
                    let index = operations.lastIndex { operation in
                        if case .loading(let task) = operation {
                            return task == actionTask
                        } else {
                            return false
                        }
                    }
                    operations[index!] = .completed(actionTask, result)
                    #if os(iOS)
                        if options.contains(.enableNotificationFeedback) {
                            switch result {
                            case .success:
                                generator.notificationOccurred(.success)
                            case .failure:
                                generator.notificationOccurred(.error)
                            }
                        }
                    #endif
                    if options.contains(.enableTintFeedback) {
                        withAnimation(.linear(duration: 0.1)) {
                            switch result {
                            case .success:
                                tint = .green
                            case .failure:
                                tint = .red
                            }
                        }
                        withAnimation(.linear(duration: 0.2).delay(1.5)) {
                            tint = nil
                        }
                    }
                    if options.contains(.showAlertOnError) {
                        if case .failure(let error) = result {
                            let localizedError = error as? LocalizedError ?? UnlocalizedError(error: error)
                            self.localizedError = AnyLocalizedError(erasing: localizedError)
                            showingErrorAlert = true
                        }
                    }
                }
            },
            label: {
                label(operations)
                    .opacity(showProgressView ? 0 : 1)
                    .overlay {
                        if showProgressView {
                            ProgressView()
                        }
                    }
            }
        )
        .disabled(disableButton)
        .animation(transaction.animation, value: operations)
        .tint(tint)
        .alert(isPresented: $showingErrorAlert, error: localizedError) { error in
            Button("OK") {
                showingErrorAlert = false
            }
        } message: { error in
            if let message = error.failureReason ?? error.recoverySuggestion ?? error.helpAnchor {
                Text(message)
            }
        }

    }
    
    public init(
        role: ButtonRole? = nil,
        options: AsyncButtonOptions = [],
        transaction: Transaction = Transaction(),
        action: @escaping () async throws -> Void,
        @ViewBuilder label: @escaping ([AsyncButtonOperation]) -> Label
    ) {
        self.role = role
        self.options = options
        self.transaction = transaction
        self.action = action
        self.label = label
    }
}

extension AsyncButton {
    
    public init(
        role: ButtonRole? = nil,
        options: AsyncButtonOptions = .automatic,
        transaction: Transaction = Transaction(animation: .default),
        action: @escaping () async throws -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.init(role: role, options: options, transaction: transaction, action: action) { _ in
            label()
        }
    }
}

extension AsyncButton where Label == Text {
    
    public init(
        _ titleKey: LocalizedStringKey,
        role: ButtonRole? = nil,
        options: AsyncButtonOptions = .automatic,
        transaction: Transaction = Transaction(animation: .default),
        action: @escaping () async throws -> Void
    ) {
        self.init(role: role, options: options, transaction: transaction, action: action) { operations in
            Text(titleKey)
        }
    }
}

extension AsyncButton where Label == Text {
    
    public init<S>(
        _ title: S,
        role: ButtonRole?,
        options: AsyncButtonOptions = .automatic,
        transaction: Transaction = Transaction(animation: .default),
        action: @escaping () async throws -> Void
    ) where S : StringProtocol
    {
        self.init(role: role, options: options, transaction: transaction, action: action) { operations in
            Text(title)
        }
    }
}
