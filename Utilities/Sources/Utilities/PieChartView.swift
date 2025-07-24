import UIKit

public class PieChartView: UIView {
    
    public var entities: [Entity] = [] {
        didSet {
            animateTransition(from: oldValue, to: entities)
        }
    }
    
    private var displayedEntities: [Entity] = []
    
    private let segmentColors: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemYellow,
        .systemGreen,
        .systemBlue,
        .systemGray
    ]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !displayedEntities.isEmpty else { return }

        let total = displayedEntities.map { NSDecimalNumber(decimal: $0.value).doubleValue }.reduce(0, +)
        guard total > 0 else { return }

        let limited = Array(displayedEntities.prefix(5))
        let others = displayedEntities.dropFirst(5)
        let othersSum = others.map { NSDecimalNumber(decimal: $0.value).doubleValue }.reduce(0, +)

        var segments = limited
        if othersSum > 0 {
            segments.append(Entity(value: Decimal(othersSum), label: "Остальные"))
        }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerRadius = min(bounds.width, bounds.height) / 2 - 60
        let innerRadius = outerRadius * 0.9
        var startAngle: CGFloat = -.pi / 2

        for (index, segment) in segments.enumerated() {
            let value = NSDecimalNumber(decimal: segment.value).doubleValue
            let angle = CGFloat(value / total) * 2 * .pi
            let endAngle = startAngle + angle

            context.setFillColor(segmentColors[index % segmentColors.count].cgColor)

            let path = UIBezierPath()
            path.addArc(withCenter: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            path.close()

            path.fill()

            startAngle = endAngle
        }

        drawLegend(in: context, center: center, segments: segments)
    }
    
    private func drawLegend(in context: CGContext, center: CGPoint, segments: [Entity]) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.black
        ]
        
        let total = segments.map { NSDecimalNumber(decimal: $0.value).doubleValue }.reduce(0, +)
        let legendRadius: CGFloat = min(bounds.width, bounds.height) / 2 - 60
        let lineHeight: CGFloat = 20
        let boxSize: CGFloat = 10
        
        for (i, segment) in segments.enumerated() {
            let value = NSDecimalNumber(decimal: segment.value).doubleValue
            let percent = Int((value / total * 100).rounded())
            let label = "\(percent)% \(segment.label)"
            
            let y = center.y - CGFloat(segments.count) / 2 * lineHeight + CGFloat(i) * lineHeight
            
            // цветной кружок
            let color = segmentColors[i % segmentColors.count]
            let circleRect = CGRect(x: center.x - 60, y: y + (lineHeight - boxSize) / 2, width: boxSize, height: boxSize)
            let circlePath = UIBezierPath(ovalIn: circleRect)
            color.setFill()
            circlePath.fill()
            
            // подпись
            let textPoint = CGPoint(x: circleRect.maxX + 5, y: y)
            (label as NSString).draw(at: textPoint, withAttributes: textAttributes)
        }
    }
    
    // MARK: - Анимация перехода
    
    private func animateTransition(from old: [Entity], to new: [Entity]) {
        // Сохраняем текущее состояние для рисования
        self.displayedEntities = old
        self.setNeedsDisplay()
        
        // Сброс всех анимаций
        layer.removeAllAnimations()
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.duration = 0.5
        fadeOut.beginTime = 0
        fadeOut.fillMode = .forwards
        fadeOut.isRemovedOnCompletion = false
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi
        rotation.duration = 0.5
        rotation.beginTime = 0
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        
        let groupOut = CAAnimationGroup()
        groupOut.animations = [fadeOut, rotation]
        groupOut.duration = 0.5
        groupOut.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self else { return }
            
            // Обновляем данные
            self.displayedEntities = new
            self.setNeedsDisplay()
            
            // Анимация входа
            let fadeIn = CABasicAnimation(keyPath: "opacity")
            fadeIn.fromValue = 0
            fadeIn.toValue = 1
            fadeIn.duration = 0.5
            fadeIn.beginTime = 0
            fadeIn.fillMode = .forwards
            fadeIn.isRemovedOnCompletion = false
            
            let rotationBack = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationBack.fromValue = Double.pi
            rotationBack.toValue = 2 * Double.pi
            rotationBack.duration = 0.5
            rotationBack.beginTime = 0
            rotationBack.fillMode = .forwards
            rotationBack.isRemovedOnCompletion = false
            
            let groupIn = CAAnimationGroup()
            groupIn.animations = [fadeIn, rotationBack]
            groupIn.duration = 0.5
            groupIn.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            self.layer.add(groupIn, forKey: "inAnimation")
        }
        CATransaction.commit()
        
        // Запускаем первую фазу
        layer.add(groupOut, forKey: "outAnimation")
    }
}
