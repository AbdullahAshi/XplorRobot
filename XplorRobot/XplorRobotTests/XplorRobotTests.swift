//
//  XplorRobotTests.swift
//  XplorRobotTests
//
//  Created by Abdullah Al-Ashi on 7/Oct/20.
//  Copyright © 2020 Abdullah Al-Ashi. All rights reserved.
//

import XCTest
@testable import XplorRobot

class XplorRobotTests: XCTestCase {
  
  let robot = Robot(board: Board(dimensions: 5))
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testCommand() {
    
    var output: RobotPlaceFacing? = nil
    var expectedOutput: RobotPlaceFacing? = nil
    
    expectedOutput = (3,4, .north)
    var commandRobot = Robot(board: Board(dimensions: 5))
    commandRobot.command([.left, .left, .right, .move, .place((3,3, .north)), .move])
    output = commandRobot.report()
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
    XCTAssertEqual(expectedOutput?.2, output?.2)
    
    //no invalid place provided
    commandRobot = Robot(board: Board(dimensions: 5))
    commandRobot.command([.left, .left, .right, .move, .place((6,7, .north)), .move])
    output = commandRobot.report()
    XCTAssertNil(output)
    
    //requirments test
    //PLACE 0,0,NORTH MOVE REPORT Output: 0,1,NORTH
    expectedOutput = (0,1, .north)
    commandRobot = Robot(board: Board(dimensions: 5))
    commandRobot.command([.place((0,0, .north)), .move])
    output = commandRobot.report()
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
    XCTAssertEqual(expectedOutput?.2, output?.2)
    
    //requirments test
    //PLACE 0,0,NORTH LEFT REPORT Output: 0,0,WEST
    expectedOutput = (0,0, .west)
    commandRobot = Robot(board: Board(dimensions: 5))
    commandRobot.command([.place((0,0, .north)), .left, .move])
    output = commandRobot.report()
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
    XCTAssertEqual(expectedOutput?.2, output?.2)

    //requirments test
    //PLACE 1,2,EAST MOVE MOVE LEFT MOVE REPORT Output: 3,3,NORTH
    expectedOutput = (3,3, .north)
    commandRobot = Robot(board: Board(dimensions: 5))
    commandRobot.command([.place((1,2, .east)), .move, .move, .left, .move])
    output = commandRobot.report()
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
    XCTAssertEqual(expectedOutput?.2, output?.2)
  }
  
  func testPlace() {
    var output: RobotPlaceFacing? = nil
    var expectedOutput: RobotPlaceFacing? = nil
    
    //valid minimum x,y, north
    output = robot.place(at: (0, 0), facing: .north, max: robot.maxIndex)
    expectedOutput = (0, 0, .north)
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
    XCTAssertEqual(expectedOutput?.2, output?.2)
    
    //valid maximum x,y, south
    output = robot.place(at: (4, 4), facing: .south, max: robot.maxIndex)
    expectedOutput = (4, 4, .south)
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
    XCTAssertEqual(expectedOutput?.2, output?.2)
    
    //invalid place
    output = robot.place(at: (5, 5), facing: .east, max: robot.maxIndex)
    XCTAssertNil(output)
  }
  
  func testMove() {
    var output: Robot.RobotPlace? = nil
    var expectedOutput: Robot.RobotPlace? = nil
    let max: Int = robot.maxIndex

    /*
    //overkill movement test
    for x in min...(max-1) {
      for y in min...(max-1) {

      }
    }
    */
    
    //test moving within bounds
    output = robot.move(currentPlace: (0,0), currentFacing: .north, max: max)
    expectedOutput = (0, 1)
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
    
    //test moving outside bounds
    output = robot.move(currentPlace: (max,max), currentFacing: .east, max: max)
    expectedOutput = (max,max)
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
    
    /*
    //test invalid case where place is outside bound just to make sure our function caters for it
    output = robot.move(currentPlace: (6,6), currentFacing: .north, max: max)
    expectedOutput = (max,max)
    XCTAssertEqual(expectedOutput?.0, output?.0)
    XCTAssertEqual(expectedOutput?.1, output?.1)
     */
  }
  
  func testRotateRight() {
    // test rotate rigth against each direction
    XCTAssertEqual(Robot.RobotFacing.east, robot.rotateRight(currentFacing: Robot.RobotFacing.north))
    XCTAssertEqual(Robot.RobotFacing.south, robot.rotateRight(currentFacing: Robot.RobotFacing.east))
    XCTAssertEqual(Robot.RobotFacing.west, robot.rotateRight(currentFacing: Robot.RobotFacing.south))
    XCTAssertEqual(Robot.RobotFacing.north, robot.rotateRight(currentFacing: Robot.RobotFacing.west))
  }
  
  func testRotateLeft() {
    // test rotate left against each direction
    XCTAssertEqual(Robot.RobotFacing.west, robot.rotateLeft(currentFacing: Robot.RobotFacing.north))
    XCTAssertEqual(Robot.RobotFacing.north, robot.rotateLeft(currentFacing: Robot.RobotFacing.east))
    XCTAssertEqual(Robot.RobotFacing.east, robot.rotateLeft(currentFacing: Robot.RobotFacing.south))
    XCTAssertEqual(Robot.RobotFacing.south, robot.rotateLeft(currentFacing: Robot.RobotFacing.west))
  }
  
  func testIncrementUptoMax() {
    //assert value gets increamented and doesn't exceed max
    XCTAssertEqual(4, robot.incrementUptoMax(value: 3, max: 5))
    XCTAssertEqual(5, robot.incrementUptoMax(value: 4, max: 5))
    XCTAssertEqual(5, robot.incrementUptoMax(value: 5, max: 5))
    XCTAssertEqual(5, robot.incrementUptoMax(value: 6, max: 5))
  }
  
  func testDecrementDowntoMin() {
    //assert value gets decremented and doesn't go less than min
    XCTAssertEqual(0, robot.decrementDowntoMin(value: 1, min: 0))
    XCTAssertEqual(0, robot.decrementDowntoMin(value: 0, min: 0))
    XCTAssertEqual(0, robot.decrementDowntoMin(value: -1, min: 0))
  }
  
  func testReport() {
    let newRobot = Robot(board: Board(dimensions: 5))
    
    //assert unplaced robot report is nil
    XCTAssertNil(newRobot.report())
    
    let expectedOutput: RobotPlaceFacing = (3, 3, .west)
    newRobot.command([.place(expectedOutput)])
    
    //asset placed robot report is not nil and equal expected
    XCTAssertEqual(expectedOutput.0, newRobot.report()?.0)
    XCTAssertEqual(expectedOutput.1, newRobot.report()?.1)
    XCTAssertEqual(expectedOutput.2, newRobot.report()?.2)
  }
  
}
