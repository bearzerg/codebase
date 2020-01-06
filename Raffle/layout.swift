import UIKit

typealias EdgeClosure = (_ view: UIView, _ superview: UIView) -> ([NSLayoutConstraint])

extension UIView {

    func pin(on superview: UIView, _ callback: EdgeClosure) {
        superview.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        callback(self, superview).forEach {
            $0.isActive = true
        }
    }

}

self.mapView.pin(on: self.view) {
            [
                $0.topAnchor.constraint(equalTo: $1.topAnchor),
                $0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                $0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),


self.mapView.pin(on: self.view) {
            self.topAnchor = $0.topAnchor.constraint(equalTo: $1.topAnchor)
            return [
                self.topAnchor,
                $0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                $0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
            ]
        }

          