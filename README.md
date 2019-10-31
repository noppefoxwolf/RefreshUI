# RefreshUI

![](https://github.com/noppefoxwolf/PullToRefresh/blob/master/.github/ios.gif)

![](https://github.com/noppefoxwolf/PullToRefresh/blob/master/.github/mac.gif)

# Usage

```swift
PullToRefresh.install()
```

```swift
List {
    ForEach(items, id: \.self) { (item) in
        Text("\(item)")
    }
}.onPull(perform: {
    self.items.shuffle()
}, isLoading: isLoading)
```
