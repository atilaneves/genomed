module ga.util;

import std.algorithm;
import std.range;

auto maxElement(alias F = (a) => a, R)(R range) if(isInputRange!R) {
    return minCount!("a > b")(map!(F)(range))[0];
}


auto minElement(alias F = (a) => a, R)(R range) if(isInputRange!R) {
    return minCount!("a < b")(map!(F)(range))[0];
}
