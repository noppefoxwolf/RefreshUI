# PullToRefresh

```swift
List {
    ForEach(items, id: \.self) { (item) in
        Text("\(item)")
    }
}.onPull(perform: {
    self.items.shuffle()
}, isLoading: isLoading)
```
