import Foundation


typealias RobotPlaceFacing = (Int, Int, Robot.RobotFacing)

protocol RobotProtocol {
  func command(_ commands: [Robot.RobotCommand])
  func report() -> RobotPlaceFacing?
}

class Robot {
  
  typealias RobotPlace = (Int,Int)
  
  enum RobotFacing {
    case north
    case south
    case east
    case west
  }
  
  enum RobotCommand {
    case place(RobotPlaceFacing)
    case left
    case right
    case move
  }

  private var dimensions: Int
  private var facing: RobotFacing = .north
  private var currentPlace: RobotPlace?
  private var maxIndex: Int {
    return dimensions - 1
  }
  
  init(dimensions: Int = 5) {
    self.dimensions = dimensions
  }
}

//MARK: Robot Interface - RobotProtocol

extension Robot: RobotProtocol {
  func command(_ commands: [RobotCommand]){
    
  }
  
  func report() -> RobotPlaceFacing? {
    return nil
  }
}

//MARK: private functions

extension Robot {
  
  func move(currentPlace: RobotPlace?, currentFacing: RobotFacing) -> RobotPlace? {
    return nil
  }
  
  func rotateLeft(currentFacing: RobotFacing) -> RobotFacing? {
    return nil
  }
  
  func rotateRight(currentFacing: RobotFacing) -> RobotFacing? {
    return nil
  }
  
  func place(_ place: (Int,Int), _ facing: RobotFacing) -> RobotPlaceFacing? {
    return nil
  }
  
  func incrementUptoMax(value: Int, max: Int) -> Int {
    return 0
  }
  
  func decrementDowntoMin(value: Int, min: Int = 0) -> Int {
    return 0
  }
}
