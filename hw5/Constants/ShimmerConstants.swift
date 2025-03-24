import UIKit

enum ShimmerConstants {

    static let lightColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    static let darkColor = UIColor(white: 0.75, alpha: 1.0).cgColor
    

    static let shimmerAnimationDuration: TimeInterval = 1.0
    static let shimmerAnimationFromValue: [NSNumber] = [-1.0, -0.5, 0.0]
    static let shimmerAnimationToValue: [NSNumber] = [1.0, 1.5, 2.0]
    

    static let shimmerStartPoint = CGPoint(x: 0, y: 0.5)
    static let shimmerEndPoint = CGPoint(x: 1, y: 0.5)
    

    static let shimmerLocations: [NSNumber] = [0.0, 0.5, 1.0]
    
  
    static let shimmerLayerName = "simmerGradient"
}
