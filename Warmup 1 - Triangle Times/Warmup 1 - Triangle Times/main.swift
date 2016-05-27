//
//  main.swift
//  Warmup 1 - Triangle Times
//
//  Created by Carlos Noble Curveira on 2016-05-27.
//  Copyright © 2016 Carlos Noble Curveira. All rights reserved.
//

import Foundation

var angle1Value = 0
var angle2Value = 0
var angle3Value = 0

repeat
{
    while angle1Value == 0
    {
        print("Angle 1?", terminator: " ")
        if let angle1 = readLine(stripNewline: true)
        {
            if let angle1Int = Int(angle1)
            {
                if 0 < angle1Int && 180 > angle1Int
                {
                angle1Value = angle1Int
                }
            }
        }
    }
    while angle2Value == 0
    {
        print("Angle 2?", terminator: " ")
        if let angle2 = readLine(stripNewline: true)
        {
            if let angle2Int = Int(angle2)
            {
                if 0 < angle2Int && 180 > angle2Int
                {
                angle2Value = angle2Int
                }
            }
        }
    }
    while angle3Value == 0
    {
        print("Angle 3?", terminator: " ")
        if let angle3 = readLine(stripNewline: true)
        {
            if let angle3Int = Int(angle3)
            {
                if 0 < angle3Int && 180 > angle3Int
                {
                angle3Value = angle3Int
                }
            }
        }
    }
} while angle1Value == 0 && angle2Value == 0 && angle3Value == 0

if angle1Value+angle2Value+angle3Value != 180
{
    print("Error")
} else if angle1Value == angle2Value && angle2Value == angle3Value{
    print("Equilateral")
} else if angle1Value == angle2Value || angle2Value == angle3Value || angle1Value == angle3Value{
    print("Isosceles")
} else {
    print("Scalene")
}
