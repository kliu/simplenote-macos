import Foundation
import AppKit


// MARK: - InterlinkWindowController
//
class InterlinkWindowController: NSWindowController {

    private var interlinkViewController: InterlinkViewController? {
        contentViewController as? InterlinkViewController
    }
}


// MARK: - Lookup API
//
extension InterlinkWindowController {

    func displaySuggestions(for keyword: String, around sourceRect: NSRect, from parentWindow: NSWindow?) {
        interlinkViewController?.displayInterlinks(for: keyword)
        display(around: sourceRect, from: parentWindow)
    }
}


// MARK: - Display API(s)
//
extension InterlinkWindowController {

    /// Displays the receiver [below or above] the SourceRect, if space allows. We're also compensating to prevent horizontal clipping.
    /// - Note: Parent Window required to prevent Expose from treating this window as a standalone component
    ///
    func display(around sourceRect: NSRect, from parentWindow: NSWindow?) {
        guard let window = window else {
            return
        }

        let frameOrigin = calculateWindowOrigin(windowSize: window.frame.size, sourceRect: sourceRect)
        window.setFrameOrigin(frameOrigin)
        parentWindow?.addChildWindow(window, ordered: .above)
    }

    /// Adjusts the Window Origin location, so that the Window doesn't get cut offscreen
    ///
    private func calculateWindowOrigin(windowSize: CGSize, sourceRect: CGRect) -> CGPoint {
        let screenWidth = NSScreen.main?.visibleFrame.width ?? .infinity
        var output = sourceRect.origin

        // Adjust Origin.Y: Avoid falling below the screen
        let belowY = output.y - windowSize.height - Metrics.windowInsets.top
        let aboveY = output.y + sourceRect.height + Metrics.windowInsets.top

        output.y = belowY > .zero ? belowY : aboveY

        // Adjust Origin.X: Compensate for horizontal overflow
        let overflowX = screenWidth - output.x - windowSize.width
        if overflowX < .zero {
            output.x += overflowX - Metrics.windowInsets.right
        }

        return output
    }
}


// MARK: - Metrics
//
private enum Metrics {
    static let windowInsets = NSEdgeInsets(top: 12, left: .zero, bottom: .zero, right: 12)
}
