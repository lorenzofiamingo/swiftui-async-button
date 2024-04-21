# SwiftUI AsyncButton 🖲️

`AsyncButton` is a `Button` capable of running concurrent code. 


## Usage

`AsyncButton` has the exact same API as `Button`, so you just have to change this:
```swift
Button("Run") { run() }
```
to this:
```swift
AsyncButton("Run") { try await run() }
```

In addition to `Button` initializers, you have the possibilities to specify special behaviours via `AsyncButtonOptions`:
```swift
AsyncButton("Ciao", options: [.showProgressViewOnLoading, .showAlertOnError], transaction: Transaction(animation: .default)) {
    try await run()
}
```

For heavy customizations you can have access to the `AsyncButtonOperation`s:

```swift
AsyncButton {
    try await run()
} label: { operations in
    if operations.contains { operation in
        if case .loading = operation {
            return true
        } else {
            return false
        }
    } {
        Text("Loading")
    } else if
        let last = operations.last,
        case .completed(_, let result) = last
    {
        switch result {
        case .failure:
            Text("Try again")
        case .success:
            Text("Run again")
        }
    } else {
        Text("Run")
    }
}
```

## Installation

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/lorenzofiamingo/swiftui-async-button`) and click **Next**.
3. Click **Finish**.


## Other projects

[SwiftUI VariadicViews 🥞](https://github.com/lorenzofiamingo/swiftui-variadic-views)

[SwiftUI CachedAsyncImage 🗃️](https://github.com/lorenzofiamingo/swiftui-cached-async-image)

[SwiftUI MapItemPicker 🗺️](https://github.com/lorenzofiamingo/swiftui-map-item-picker)

[SwiftUI PhotosPicker 🌇](https://github.com/lorenzofiamingo/swiftui-photos-picker)

[SwiftUI VerticalTabView 🔝](https://github.com/lorenzofiamingo/swiftui-vertical-tab-view)

[SwiftUI SharedObject 🍱](https://github.com/lorenzofiamingo/swiftui-shared-object)
