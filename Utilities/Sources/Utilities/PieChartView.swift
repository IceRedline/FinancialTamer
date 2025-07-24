import UIKit

public class PieChartView: UIView {
    
    public var entities: [Entity] = [] {
        didSet { setNeedsDisplay() }
    }

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
        guard let context = UIGraphicsGetCurrentContext(), !entities.isEmpty else { return }

        let total = entities.map { NSDecimalNumber(decimal: $0.value).doubleValue }.reduce(0, +)
        guard total > 0 else { return }

        let limited = Array(entities.prefix(5))
        let others = entities.dropFirst(5)
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

            context.setFillColor(segmentColors[index % segmentColors.count].cgColor)

            let path = UIBezierPath()
            path.addArc(withCenter: center,
                        radius: outerRadius,
                        startAngle: startAngle,
                        endAngle: startAngle + angle,
                        clockwise: true)
            path.addArc(withCenter: center,
                        radius: innerRadius,
                        startAngle: startAngle + angle,
                        endAngle: startAngle,
                        clockwise: false)
            path.close()
            context.addPath(path.cgPath)
            context.fillPath()

            startAngle += angle
        }

        drawLegendInside(center: center, segments: segments, total: total)
    }

    private func drawLegendInside(center: CGPoint, segments: [Entity], total: Double) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        let textColor = UIColor.black
        let boxSize: CGFloat = 10
        let spacing: CGFloat = 6
        let lineHeight: CGFloat = 16
        let totalHeight = lineHeight * CGFloat(segments.count)
        let originY = center.y - totalHeight / 2

        for (index, segment) in segments.enumerated() {
            let value = NSDecimalNumber(decimal: segment.value).doubleValue
            let percentage = Int(round((value / total) * 100))
            let color = segmentColors[index % segmentColors.count]

            let y = originY + CGFloat(index) * lineHeight
            let circleRect = CGRect(x: center.x - 60, y: y + (lineHeight - boxSize) / 2, width: boxSize, height: boxSize)
            let circlePath = UIBezierPath(ovalIn: circleRect)
            color.setFill()
            circlePath.fill()

            let text = "\(percentage)% \(segment.label)" as NSString
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            let textRect = CGRect(x: circleRect.maxX + spacing, y: y, width: 100, height: lineHeight)
            text.draw(in: textRect, withAttributes: textAttributes)
        }
    }
}
