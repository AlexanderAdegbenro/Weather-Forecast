//
//  PullToRefresh.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import Foundation
import SwiftUI

struct PullToRefresh: ViewModifier {
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay(
                VStack {
                    if isRefreshing {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .offset(y: 30)
                    } else {
                        Color.clear
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    PullToRefreshCoordinator(isRefreshing: $isRefreshing, onRefresh: onRefresh)
                )
            )
    }
}

struct PullToRefreshCoordinator: UIViewRepresentable {
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.handleRefresh), for: .valueChanged)
        if let scrollView = findUIScrollView(view) {
            scrollView.refreshControl = refreshControl
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if !isRefreshing {
            findUIScrollView(uiView)?.refreshControl?.endRefreshing()
        }
    }

    func findUIScrollView(_ fromView: UIView) -> UIScrollView? {
        for subview in fromView.subviews {
            if let scrollView = subview as? UIScrollView {
                return scrollView
            } else if let scrollView = findUIScrollView(subview) {
                return scrollView
            }
        }
        return nil
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator {
        var control: PullToRefreshCoordinator

        init(_ control: PullToRefreshCoordinator) {
            self.control = control
        }

        @objc func handleRefresh() {
            control.onRefresh()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                [weak self] in
                self?.control.isRefreshing = false

            }
        }
    }
}
