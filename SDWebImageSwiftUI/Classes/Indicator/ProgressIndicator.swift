/*
* This file is part of the SDWebImage package.
* (c) DreamPiggy <lizhuoli1126@126.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

import SwiftUI

/// A progress bar indicator (system style)
public struct ProgressIndicator: PlatformViewRepresentable {
    @Binding var isAnimating: Bool
    @Binding var progress: CGFloat
    
    public init(_ isAnimating: Binding<Bool>, progress: Binding<CGFloat>) {
        self._isAnimating = isAnimating
        self._progress = progress
    }
    
    #if os(macOS)
    public typealias NSViewType = ProgressIndicatorWrapper
    #elseif os(iOS) || os(tvOS)
    public typealias UIViewType = ProgressIndicatorWrapper
    #endif
    
    #if os(iOS) || os(tvOS)
    public func makeUIView(context: UIViewRepresentableContext<ProgressIndicator>) -> ProgressIndicatorWrapper {
        let uiView = ProgressIndicatorWrapper()
        let view = uiView.wrapped
        view.progressViewStyle = .default
        return uiView
    }
    
    public func updateUIView(_ uiView: ProgressIndicatorWrapper, context: UIViewRepresentableContext<ProgressIndicator>) {
        let view = uiView.wrapped
        if isAnimating {
            view.setProgress(Float(progress), animated: true)
        } else {
            if progress == 0 {
                view.isHidden = false
                view.progress = 0
            } else {
                view.isHidden = true
                view.progress = 1
            }
        }
    }
    #endif
    
    #if os(macOS)
    public func makeNSView(context: NSViewRepresentableContext<ProgressIndicator>) -> ProgressIndicatorWrapper {
        let nsView = ProgressIndicatorWrapper()
        let view = nsView.wrapped
        view.style = .bar
        view.isDisplayedWhenStopped = false
        view.controlSize = .small
        return nsView
    }
    
    public func updateNSView(_ nsView: ProgressIndicatorWrapper, context: NSViewRepresentableContext<ProgressIndicator>) {
        let view = nsView.wrapped
        if isAnimating {
            view.isIndeterminate = false
            view.doubleValue = Double(progress) * 100
            view.startAnimation(nil)
        } else {
            if progress == 0 {
                view.isHidden = false
                view.isIndeterminate = true
                view.doubleValue = 0
                view.stopAnimation(nil)
            } else {
                view.isHidden = true
                view.isIndeterminate = false
                view.doubleValue = 100
                view.stopAnimation(nil)
            }
        }
    }
    
    #endif
}
