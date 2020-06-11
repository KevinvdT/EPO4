// Adapted from https://stackoverflow.com/questions/5731863/mapping-a-numeric-range-onto-another
export function maprange(
  value,
  [inputBegin, inputEnd],
  [outputBegin, outputEnd]
) {
  const slope = (outputEnd - outputBegin) / (inputEnd - inputBegin);
  return outputBegin + slope * (value - inputBegin);
}
