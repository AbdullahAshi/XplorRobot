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
    case block([RobotPlace])
  }

  private let board: Board
  private var dimensions: Int {
    return board.dimensions
  }
  private var currentFacing: RobotFacing = .north
  private var currentPlace: RobotPlace?
  var maxIndex: Int {
    return dimensions - 1
  }
  
  init(board: Board) {
    self.board = board
  }
}

//MARK: Robot Interface - RobotProtocol

extension Robot: RobotProtocol {
  /// The first valid command to the robot is a PLACE command, after that, any sequence of commands may be issued, in any order, including another PLACE command. The application should discard all commands in the sequence until a valid PLACE command has been executed.
  /// A robot that is not on the table can choose the ignore the MOVE, LEFT, RIGHT and REPORT commands.
  func command(_ commands: [RobotCommand]){
    for command in commands {
      switch command {
      case .place(let proposedRobotFacingPlace):
        if let robotFacingPlace = place(at: (proposedRobotFacingPlace.0, proposedRobotFacingPlace.1), facing: proposedRobotFacingPlace.2, max: maxIndex) {
          currentPlace = (robotFacingPlace.0, robotFacingPlace.1)
          currentFacing = robotFacingPlace.2
        } else { continue }
      case .left:
        guard currentPlace != nil else { continue }
        currentFacing = rotateLeft(currentFacing: currentFacing)
      case .right:
        guard currentPlace != nil else { continue }
        currentFacing = rotateRight(currentFacing: currentFacing)
      case .move:
        guard let currentPlace = currentPlace else { continue }
        let robotPlace = moveIfValid(currentPlace: currentPlace, currentFacing: currentFacing, max: maxIndex, blocker: board.blocker)
        self.currentPlace = robotPlace
      case .block(let newBlockers):
        guard currentPlace != nil else { continue }
        board.setBlockers(newBlockers)
      }
    }
  }
  
  func report() -> RobotPlaceFacing? {
    return currentPlace != nil ? (currentPlace!.0, currentPlace!.1, currentFacing) : nil
  }
}

//MARK: private helper functions

extension Robot {
  func place(at place: (Int,Int), facing: RobotFacing, max: Int) -> RobotPlaceFacing? {
    guard place.0 <= max, place.1 <= max else { return nil }
    guard place.0 >= 0, place.1 >= 0 else { return nil }
    
    return (place.0, place.1, facing)
  }
  
  func moveIfValid(currentPlace: RobotPlace, currentFacing: RobotFacing, max: Int, blocker: [(Int, Int)]) -> RobotPlace? {
    let placeToBe = move(currentPlace: currentPlace, currentFacing: currentFacing, max: max)
    for block in blocker {
      if (placeToBe.0 == block.0) && (placeToBe.1 == block.1) {
        return nil
      }
    }
    return placeToBe
  }
  
  //movement that would result in the robot falling from the table must be prevented, however further valid movement commands must still be allowed.
  func move(currentPlace: RobotPlace, currentFacing: RobotFacing, max: Int) -> RobotPlace {
    switch currentFacing {
    case .north:
      return (currentPlace.0, incrementUptoMax(value: currentPlace.1, max: max))
    case .south:
      return (currentPlace.0, decrementDowntoMin(value: currentPlace.1, min: 0))
    case .east:
      return (incrementUptoMax(value: currentPlace.0, max: max), currentPlace.1)
    case .west:
      return (decrementDowntoMin(value: currentPlace.0, min: 0), currentPlace.1)
    }
  }
  
  func rotateLeft(currentFacing: RobotFacing) -> RobotFacing {
    switch currentFacing {
    case .north:
      return .west
    case .south:
      return .east
    case .east:
      return .north
    case .west:
      return .south
    }
  }
  
  func rotateRight(currentFacing: RobotFacing) -> RobotFacing {
    switch currentFacing {
    case .north:
      return .east
    case .south:
      return .west
    case .east:
      return .south
    case .west:
      return .north
    }
  }
}

//MARK: private low-level functions

extension Robot {
  func incrementUptoMax(value: Int, max: Int) -> Int {
    return min(value + 1, max)
  }
  
  func decrementDowntoMin(value: Int, min: Int = 0) -> Int {
    return max(value - 1, 0)
  }
}


//block x y , igonred if not applicable

// create board object + blocker (done)
// expose board blocker (done)
//adopt to thos blockers
