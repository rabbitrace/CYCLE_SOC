(globals
  version = 3
  io_order = counterclockwise
)
(iopad
  (topleft
    (inst
      name = "CORNER_1"
      cell = "PCORNER"
    )
  )
  (topright
    (inst
      name = "CORNER_2"
      cell = "PCORNER"
    )
  )
  (bottomleft
    (inst
      name = "CORNER_3"
      cell = "PCORNER"
    )
  )
  (bottomright
    (inst
      name = "CORNER_4"
      cell = "PCORNER"
    )
  )
  (top
    (locals
      io_order = counterclockwise
    )
    (inst
      name = "PAD_SegE"
      cell = "PDO08CDG"
    )
    (inst
      name = "PAD_SegD"
      cell = "PDO08CDG"
    )
    (inst
      name = "PADS_GND_1"
      cell = "PVSS2DGZ"
    )
    (inst
      name = "PAD_SegC"
      cell = "PDO08CDG"
    )
    (inst
      name = "PAD_SegB"
      cell = "PDO08CDG"
    )
    (inst
      name = "PAD_SegA"
      cell = "PDO08CDG"
    )
  )
  (bottom
    (locals
      io_order = counterclockwise
    )
    (inst
      name = "PAD_nMode"
      cell = "PDUDGZ"
    )
    (inst
      name = "PAD_nTrip"
      cell = "PDUDGZ"
    )
    (inst
      name = "PADS_VDD_1"
      cell = "PVDD2DGZ"
    )
    (inst
      name = "PAD_nFork"
      cell = "PDUDGZ"
    )
    (inst
      name = "PAD_nCrank"
      cell = "PDUDGZ"
    )
    (inst
      name = "PAD_nDigit_3"
      cell = "PDO08CDG"
    )
  )
  (left
    (locals
      io_order = counterclockwise
    )
    (inst
      name = "PAD_ScanEnable"
      cell = "PDIDGZ"
    )
    (inst
      name = "PAD_Clock"
      cell = "PDB02DGZ"
    )
    (inst
      name = "PAD_nReset"
      cell = "PDIDGZ"
    )
    (inst
      name = "CORE_VDD_1"
      cell = "PVDD1DGZ"
    )
    (inst
      name = "PAD_Test"
      cell = "PDIDGZ"
    )
    (inst
      name = "PAD_SDI"
      cell = "PDIDGZ"
    )
    (inst
      name = "PAD_SDO"
      cell = "PDO08CDG"
    )
  )
  (right
    (locals
      io_order = counterclockwise
    )
    (inst
      name = "PAD_nDigit_2"
      cell = "PDO08CDG"
    )
    (inst
      name = "PAD_nDigit_1"
      cell = "PDO08CDG"
    )
    (inst
      name = "PAD_nDigit_0"
      cell = "PDO08CDG"
    )
    (inst
      name = "CORE_GND_1"
      cell = "PVSS1DGZ"
    )
    (inst
      name = "PAD_DP"
      cell = "PDO08CDG"
    )
    (inst
      name = "PAD_SegG"
      cell = "PDO08CDG"
    )
    (inst
      name = "PAD_SegF"
      cell = "PDO08CDG"
    )
  )
)
