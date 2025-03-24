import UIKit

class Shimmer {
    // Starts a shimmer animation on the provided view.
    static func start(for view: UIView) {
        view.layoutIfNeeded()
        
        // Avoid adding multiple shimmer layers.
        if view.layer.mask != nil { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = ShimmerConstants.shimmerLayerName
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [ShimmerConstants.darkColor, ShimmerConstants.lightColor, ShimmerConstants.darkColor]
        gradientLayer.startPoint = ShimmerConstants.shimmerStartPoint
        gradientLayer.endPoint = ShimmerConstants.shimmerEndPoint
        gradientLayer.locations = ShimmerConstants.shimmerLocations
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = ShimmerConstants.shimmerAnimationFromValue
        animation.toValue = ShimmerConstants.shimmerAnimationToValue
        animation.duration = ShimmerConstants.shimmerAnimationDuration
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "simmerAnimation")
        view.layer.mask = gradientLayer
    }
    
    // Stops the shimmer animation on the provided view.
    static func stop(for view: UIView) {
        view.layer.mask = nil
    }
}
