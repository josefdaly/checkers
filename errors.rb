

class WrongPieceError < RuntimeError
  def message
    "You cannot move a piece that doesn't belong to you"
  end
end

class NoPieceSelectedError < RuntimeError
  def message
    "You must select a piece"
  end
end

class BadSequenceError < RuntimeError
  def message
    "That sequence is not going to work"
  end
end

class NoMoveError < RuntimeError
  def message
    "You must choose a piece"
  end
end
