import unit_threaded.check;
import ga.util;


void testMaxElement() {
    checkEqual(maxElement([1, -2, 3, 4]),  4);
    checkEqual(maxElement([1, 5, 3, 4]),  5);
    checkEqual(maxElement([7, 5, 3, 4, 6]),  7);
}

void testMinElement() {
    checkEqual(minElement([1, -2, 3, 4, 0]),  -2);
    checkEqual(minElement([4, 3, 5, 4, 7]),  3);
}
