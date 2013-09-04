module ga.selection;

import ga.individual;
import ga.util;

import std.random;
import std.algorithm;


void tournament(uint numParticipants = 2, uint genomeSize, T)(
    in double mutationRate,
    in Individual!(genomeSize, T)[] oldPopulation,
    Individual!(genomeSize, T)[]  newPopulation)
{

    uint index;

    while(index < oldPopulation.length) {
        const father = getWinner!(numParticipants)(oldPopulation);
        const mother = getWinner!(numParticipants)(oldPopulation);

        immutable xoverPoint = uniform(0, genomeSize);
        auto children = father.crossover(mother, xoverPoint);
        foreach(ref child; children) child.mutate(mutationRate);

        newPopulation[index++] = children[0];
        newPopulation[index++] = children[1];
    }

}

private ref const(Individual!(genomeSize, T))
getWinner(uint numParticipants, uint genomeSize, T)(in Individual!(genomeSize, T)[] population) {

    ulong participantIndices[numParticipants] = void;
    foreach(ref i; participantIndices) {
        i = uniform(0, population.length);
    }

    const indicesSlice = participantIndices[0..$];
    immutable maxFitness = maxElement!(a => population[a].fitness)(indicesSlice);
    immutable winnerIndex = find!((a, b) => population[a].fitness == b)(indicesSlice, maxFitness)[0];
    return population[winnerIndex];
}
