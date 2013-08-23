import unit_threaded.check;
import ga.individual;

void testMutate() {
    auto ind = Individual!4([1, 1, 1, 1]);

    ind.mutate(0.0); //0%, no mutation
    checkEqual(ind.genome, [1, 1, 1, 1]);

    ind.mutate(1.0); //100%, all of them mutate
    checkEqual(ind.genome, [0, 0, 0, 0]);
}
