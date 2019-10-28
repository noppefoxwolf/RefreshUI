import Rotoscope
import UIKit
import SwiftUI


public extension View {
    func onPull(perform: @escaping () -> Void, isLoading: Bool) -> some View {
        return self.modifier(PullToRefreshModifier(handler: .init(), isLoading: isLoading, onPull: perform))
    }
}

internal struct PullToRefreshModifier: ViewModifier {
    let handler: PullToRefreshHandler
    let isLoading: Bool
    let onPull: () -> Void
    
    func body(content: Content) -> some View {
        isLoading ? Rotoscope.lastTableView?.refreshControl?.beginRefreshing() : Rotoscope.lastTableView?.refreshControl?.endRefreshing()
        return content.onAppear {
            // mainでasyncすることでビュー構築後に実行する
            DispatchQueue.main.async {
                // 本当は直接指定したい
                let refreshControl = Rotoscope.lastTableView?.refreshControl ?? UIRefreshControl()
                refreshControl.addTarget(self.handler, action: #selector(PullToRefreshHandler.valueChanged(_:)), for: .valueChanged)
                Rotoscope.lastTableView?.refreshControl = refreshControl
                refreshControl.setValue(self.handler, forKey: "com.noppe.refreshControl.handler")
            }
        }
    }
}

internal class PullToRefreshHandler: NSObject {
    weak var refreshControl: UIRefreshControl? = nil
    var onPull: (() -> Void)? = nil
    
    @objc func valueChanged(_ sender: UIRefreshControl) {
        refreshControl = sender
        onPull?()
    }
}
