module ga.selection;

import ga.individual;
import std.random;
import std.algorithm;


void tournament(alias F, uint numParticipants = 2, uint populationSize, uint genomeSize, T)(
    double mutationRate,
    ref const(Individual!(genomeSize, T)[populationSize]) oldPopulation,
    ref Individual!(genomeSize, T)[populationSize] newPopulation)
{

    uint index;

    while(index < populationSize) {
        const father = getWinner!(F, numParticipants)(oldPopulation);
        const mother = getWinner!(F, numParticipants)(oldPopulation);

        immutable xoverPoint = uniform(0, genomeSize);
        auto children = father.crossover(mother, xoverPoint);
        foreach(ref child; children) child.mutate(mutationRate);

        newPopulation[index++] = children[0];
        newPopulation[index++] = children[1];
    }

}

private ref const(Individual!(genomeSize, T))
getWinner(alias F, uint numParticipants, uint populationSize, uint genomeSize, T)(
    ref const(Individual!(genomeSize, T)[populationSize]) population) {

    uint participantIndices[numParticipants] = void;
    foreach(ref i; participantIndices) {
        i = uniform(0, populationSize);
    }

    const indicesSlice = participantIndices[0..$];
    immutable maxFitness = minCount!("a > b")(map!(a => population[a].fitness)(indicesSlice))[0];
    immutable winnerIndex = find!((a, b) => population[a].fitness == b)(indicesSlice, maxFitness)[0];
    return population[winnerIndex];
}
