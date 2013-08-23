import unit_threaded.check;
import ga.individual;


void testXover() {
    const father = Individual!5([1, 1, 1, 1, 1]);
    const mother = Individual!5([0, 0, 0, 0, 0]);
    {
        const children = father.crossover(mother, 2);
        checkEqual(children.length, 2);
        checkEqual(children[0].genome, [1, 1, 0, 0, 0]);
        checkEqual(children[1].genome, [0, 0, 1, 1, 1]);
    }
    {
        const children = mother.crossover(father, 4);
        checkEqual(children.length, 2);
        checkEqual(children[0].genome, [0, 0, 0, 0, 1]);
        checkEqual(children[1].genome, [1, 1, 1, 1, 0]);
    }
}

void testMutate() {
    auto ind = Individual!4([1, 1, 1, 1]);

    ind.mutate(0.0); //0%, no mutation
    checkEqual(ind.genome, [1, 1, 1, 1]);

    ind.mutate(1.0); //100%, all of them mutate
    checkEqual(ind.genome, [0, 0, 0, 0]);
}
