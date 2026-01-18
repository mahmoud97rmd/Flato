enum BlockType {
  // Conditions
  priceAbove,
  priceBelow,
  emaCrossUp,
  emaCrossDown,
  rsiBelow,
  rsiAbove,

  // Logical connectors
  and,
  or,

  // Actions
  buy,
  sell,
}
