
import UIKit
@IBDesignable
class DotsActivityIndicator: UIView {
    enum AnimationKeys {
        static let group = "scaleGroupAnimation"
    }
    enum AnimationConstants {
        static let dotScale: CGFloat = 1.5
        static let scaleUpDuration: TimeInterval = 0.2
        static let scaleUpDownDuration: TimeInterval = 0.2
        static let offset: TimeInterval = 0.2
        static var totalScaleDuration: TimeInterval {
            return scaleUpDuration + scaleUpDownDuration
        }
    }
    
    var dots: [CALayer] = []
    
    @IBInspectable
    var dotsCount: Int = 3 {
        didSet {
            removeDots()
            cofigureDots()
            setNeedsLayout()
        }
    }
    @IBInspectable
    var dotRadius: CGFloat = 8.0 {
        didSet {
            for dot in dots {
                configureDotSize(dot)
            }
            setNeedsLayout()
        }
    }
    override var tintColor: UIColor! {
        didSet {
            for dot in dots {
                configureDotColor(dot)
            }
            setNeedsLayout()
        }
    }
    @IBInspectable
    var dotSpacing: CGFloat = 8.0
    var dotSize: CGSize {
        return CGSize(width: dotRadius * 2 , height: dotRadius * 2)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cofigureDots()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cofigureDots()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: frame.width/2, y: frame.height/2)
        let middle = dots.count/2
        for i in 0..<dots.count {
            let x = center.x + CGFloat(i - middle)*(dotSize.width + dotSpacing)
            let y = center.y
            dots[i].position = CGPoint(x: x, y: y)
        }
    }
    
    func cofigureDots() {
        for _ in 0..<dotsCount {
            let dot = CALayer()
            configureDotSize(dot)
            configureDotColor(dot)
            dots.append(dot)
            layer.addSublayer(dot)
            
        }
        startAnimation()
    }
    func removeDots() {
        for dot in dots {
            dot.removeFromSuperlayer()
        }
        dots.removeAll()
    }
    func configureDotSize(_ dot: CALayer) {
        dot.frame.size = dotSize
        dot.cornerRadius = dotRadius
    }
    func configureDotColor(_ dot: CALayer) {
        dot.backgroundColor = tintColor.cgColor
    }
    func startAnimation() {
        var offset: TimeInterval = 0
        for dot in dots {
            dot.removeAnimation(forKey: AnimationKeys.group)
         let animatiom = scaleAnimation(offset)
            dot.add(animatiom, forKey: AnimationKeys.group)
            offset = offset + AnimationConstants.offset
        }
    }
    func stopAnimation () {
        
    }
    func scaleAnimation(_ after: TimeInterval) -> CAAnimationGroup {
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.beginTime = after
        scaleUp.fromValue = 1
        scaleUp.toValue = AnimationConstants.dotScale
        scaleUp.duration = AnimationConstants.scaleUpDuration
        
    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.beginTime = after + scaleUp.duration
        scaleDown.fromValue = AnimationConstants.dotScale
        scaleDown.toValue = 1
        scaleDown.duration = AnimationConstants.scaleUpDownDuration
        let group = CAAnimationGroup()
        group.animations = [scaleUp, scaleDown]
        group.repeatCount = .infinity
        group.duration = AnimationConstants.totalScaleDuration * TimeInterval(dots.count)
        return group
    }
    
}
