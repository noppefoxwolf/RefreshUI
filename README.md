# RefreshUI

| iOS | macOS |
|---|---|
|![](https://github.com/noppefoxwolf/PullToRefresh/blob/master/.github/ios.gif)|![](https://github.com/noppefoxwolf/PullToRefresh/blob/master/.github/mac.gif)|

# Usage

```swift
List {
    ForEach(items, id: \.self) { (item) in
        Text("\(item)")
    }
}.onPull(perform: {
    self.items.shuffle()
}, isLoading: isLoading)
```

# License

RefreshUI is licensed under the MIT License. See the LICENSE file for more information.
