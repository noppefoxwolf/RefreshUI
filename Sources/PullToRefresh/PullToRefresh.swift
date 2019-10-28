import Rotoscope
import UIKit
import SwiftUI

public enum PullToRefresh {
    public static func install() {
        Rotoscope.install()
    }
}

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
                let tableView = Rotoscope.lastTableView
                let refreshControl = tableView?.refreshControl ?? UIRefreshControl()
                refreshControl.addTarget(self.handler, action: #selector(PullToRefreshHandler.valueChanged(_:)), for: .valueChanged)
                tableView?.refreshControl = refreshControl
                tableView?.refreshControlHandler = self.handler
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

var StoredPropertyKey: UInt8 = 0

extension UITableView {
    var refreshControlHandler: PullToRefreshHandler? {
        get {
            guard let object = objc_getAssociatedObject(self, &StoredPropertyKey) as? PullToRefreshHandler else {
                return nil
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &StoredPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

}
