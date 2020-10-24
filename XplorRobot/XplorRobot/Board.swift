import Foundation

class Board {

  var dimensions: Int
  var blocker: [(Int,Int)] = []
 
  init(dimensions: Int, blocker: [(Int,Int)] = []) {
    self.dimensions = dimensions
    
    setBlockers(blocker)
  }
  
  func setBlockers(_ newBlockers: [(Int,Int)]) {
    for blocker in newBlockers {
      if let validBlocker = blockerValidator(blocker: blocker) {
        self.blocker.append(validBlocker)
      }
    }
  }
  
  func blockerValidator(blocker: (Int,Int)) -> (Int,Int)? {
    guard blocker.0 <= dimensions, blocker.1 <= dimensions else { return nil }
    guard blocker.0 >= 0, blocker.1 >= 0 else { return nil }
    
    return blocker
  }
  
}

