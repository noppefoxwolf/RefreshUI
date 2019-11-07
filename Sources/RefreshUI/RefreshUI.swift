import Rotoscope
import UIKit
import SwiftUI

public struct Token: Identifiable {
    public let id: Int
}

public extension List {
    func onPull(perform: @escaping () -> Void, isLoading: Bool) -> some View {
        onPull(perform: perform, isLoading: isLoading, token: Token(id: 1))
    }
    
    func onPull<T: Identifiable>(perform: @escaping () -> Void, isLoading: Bool, token: T) -> some View where T.ID == Int {
        
        // run in body calculation
        if isLoading {
            NotificationCenter.default.post(name: .beginRefreshing, object: nil, userInfo: ["id" : token.id])
        } else {
            NotificationCenter.default.post(name: .endRefreshing, object: nil, userInfo: ["id" : token.id])
        }
        
        return tagging(token.id) { (target) in
            guard let managerBox = target else { return }
            guard let tableViewWrapper = managerBox.subviews.first else { return }
            guard let tableView = tableViewWrapper.subviews.first as? UITableView else { return }
            if tableView.refreshControlHandler == nil && tableView.refreshControl == nil {
                let refreshControl = UIRefreshControl()
                let handler = PullToRefreshHandler(refreshControl: refreshControl, id: token.id)
                handler.onPull = perform
                tableView.refreshControlHandler = handler
                tableView.refreshControl = refreshControl
                refreshControl.endRefreshing()
            }
        }
    }
}

extension Notification.Name {
    static var beginRefreshing: Notification.Name {
        Notification.Name(rawValue: "com.noppe.refreshUI.beginRefreshing")
    }
    static var endRefreshing: Notification.Name {
        Notification.Name(rawValue: "com.noppe.refreshUI.endRefreshing")
    }
}

internal class PullToRefreshHandler: NSObject {
    weak var refreshControl: UIRefreshControl? = nil
    var onPull: (() -> Void)? = nil
    let id: Int
    
    init(refreshControl: UIRefreshControl, id: Int) {
        self.id = id
        super.init()
        self.refreshControl = refreshControl
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(PullToRefreshHandler.beginRefreshing), name: .beginRefreshing, object: nil)
        nc.addObserver(self, selector: #selector(PullToRefreshHandler.endRefreshing), name: .endRefreshing, object: nil)
        refreshControl.addTarget(self, action: #selector(PullToRefreshHandler.valueChanged), for: .valueChanged)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func valueChanged(_ sender: UIRefreshControl) {
        onPull?()
    }
    
    @objc func beginRefreshing(_ notification: Notification) {
        guard let id = notification.userInfo?["id"] as? Int else { return }
        guard self.id == id else { return }
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl?.beginRefreshing()
        }
    }
    
    @objc func endRefreshing(_ notification: Notification) {
        guard let id = notification.userInfo?["id"] as? Int else { return }
        guard self.id == id else { return }
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
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
