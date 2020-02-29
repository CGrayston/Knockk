//
//  MacawChartView.swift
//  Knockk
//
//  Created by Chris Grayston on 2/22/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import Foundation
import Macaw

class MacawChartView: MacawView {
    // MARK: - Properties - Data Injection
    static let lastFiveShows: [Int]      = [51, 0, 35, 25, 27]
    static let maxValue                  = lastFiveShows.max()!
    static let maxValueLineHeight        = 180
    static let lineWidth: Double         = 275
    static let linesAndDifference        = setLinesAndDifference()
    static let dataDivisor               = Double(linesAndDifference.maxLineValue)/Double(maxValueLineHeight)
    static let adjustedData: [Double]    = lastFiveShows.map({ Double($0) / dataDivisor}) //lastFiveShows.map({ $0.viewCount / dataDivisor}) from video
    static var animations: [Animation]   = []

    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(node: MacawChartView.createChart(), coder: aDecoder)
        backgroundColor = .clear
        
    }
    

    // MARK: - Functions
    private static func createChart() -> Group {
        var items: [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBars())

        return Group(contents: items, place: .identity)
    }

    private static func addYAxisItems() -> [Node] {
        // Set lines and difference
        let lines = linesAndDifference.lines
        let difference = linesAndDifference.difference
        let yAxisHeight: Double = 200
        let lineSpacing: Double = Double(180 / lines)

        var newNodes: [Node] = []

        for i in 1...lines {
            // Give us y cordinate where to dray each line
            let y = yAxisHeight - (Double(i) * lineSpacing)

            let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.black.with(a: 0.20))
            let valueText = Text(text: "\(i * difference)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.black

            newNodes.append(valueLine)
            newNodes.append(valueText)
        }

        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.black.with(a: 0.25))
        newNodes.append(yAxis)

        return newNodes
    }

    private static func addXAxisItems() -> [Node] {
        // Where X Axis is in the cordinate system
        let chartBaseY: Double    =  200
        var newNodes: [Node]      =  []

        for i in 1...adjustedData.count {
            // Start at 1 for a little spacing, 50 is the amoutn of spaceing
            let x = (Double(i) * 50)
            //let valueText = Text(texs: lastFiveShows[i - 1].showNumber)
            let valueText = Text(text: "Day", align:  .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill = Color.black
            newNodes.append(valueText)
        }

        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.black.with(a: 0.25))
        newNodes.append(xAxis)
        return newNodes
    }

    private static func createBars() -> Group {
        let fill = LinearGradient(degree: 90, from: Color(val: 0xff4704), to: Color(val: 0xff4704).with(a: 0.33))
        let items = adjustedData.map { _ in Group() }

        animations = items.enumerated().map { (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height = adjustedData[i] * t
                let rect = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        return items.group()
    }

    // MARK: - Helper Functions
    
    private static func setLinesAndDifference() -> (lines: Int, difference: Int, maxLineValue: Int) {
        var lines = 0
        var difference = 0
        
        switch maxValue {
        case 0:
            lines = 1
            difference = 1
        case 1...10:
            lines = maxValue
            difference = 1
        case 11...50:
            let fractionNum = Double(maxValue) / 5.0
            lines = Int(ceil(fractionNum))
            difference = 5
        case 51...100:
            let fractionNum = Double(maxValue) / 10.0
            lines = Int(ceil(fractionNum))
            difference = 10
        case 101...500:
            let fractionNum = Double(maxValue) / 50.0
            lines = Int(ceil(fractionNum))
            difference = 50
        case 501...1000:
            let fractionNum = Double(maxValue) / 100.0
            lines = Int(ceil(fractionNum))
            difference = 100
        case 1001...10000:
            let fractionNum = Double(maxValue) / 1000.0
            lines = Int(ceil(fractionNum))
            difference = 1000
        default:
            lines = -1
            difference = -1
        }
        
        return (lines, difference, lines * difference)
    }
    static func playAnimations() {
        animations.combine().play()
    }

    private static func createDummyData() -> [Double] {

        return [30, 25, 45, 50, 15]
    }
    
    
    //    static let maxValue            = 180
    //    static let maxValueLineHeight  = 180
    //
    //    static let data: [Double]      = [180, 150, 120, 90, 60]
    //
    //    static let dataDivisor               = Double(maxValue/maxValueLineHeight)
    //    static let adjustedData: [Double]    = data.map({ $0 / dataDivisor}) //lastFiveShows.map({ $0.viewCount / dataDivisor}) from video
    //    static let palette         = [0xf08c00, 0xbf1a04, 0xffd505, 0x8fcc16, 0xd1aae3].map { val in Color(val: val)}
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        let chart = MacawChartView.createChart()
    //        super.init(node: Group(contents: [chart]), coder: aDecoder)
    //    }
    //
    //    private static func createChart() -> Group {
    //        var items: [Node] = []
    //        for i in 1...6 {
    //            let y = 200 - Double(i) * 30.0
    //            items.append(Line(x1: -5, y1: y, x2: 275, y2: y).stroke(fill: Color(val: 0xF0F0F0)))
    //            items.append(Text(text: "\(i*(maxValue/6))", align: .max, baseline: .mid, place: .move(dx: -10, dy: y)))
    //        }
    //        items.append(createBars())
    //        items.append(Line(x1: 0, y1: 200, x2: 275, y2: 200).stroke())
    //        items.append(Line(x1: 0, y1: 0, x2: 0, y2: 200).stroke())
    //        return Group(contents: items, place: .move(dx: 50, dy: 200))
    //    }
    //
    //    private static func createBars() -> Group {
    //        var items: [Node] = []
    //        for (i, item) in adjustedData.enumerated() {
    //            print("i: \(i) item: \(item)")
    //            let bar = Shape(
    //                form: Rect(x: Double(i) * 50 + 25, y: 0, w: 30, h: item),
    //                fill: LinearGradient(degree: 90, from: palette[i], to: palette[i].with(a: 0.3)),
    //                place: .move(dx: 0, dy: -adjustedData[i]))
    //            items.append(bar)
    //        }
    //        return Group(contents: items, place: .move(dx: 0, dy: 200))
    //    }


    
}
