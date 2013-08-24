module ga.selection;

import ga.individual;
import std.random;

void tournament(alias F, uint numParticipants = 2, uint populationSize, uint genomeSize, T)(
    double mutationRate,
    ref const(Individual!(genomeSize, T)[populationSize]) oldPopulation,
    ref Individual!(genomeSize, T)[populationSize] newPopulation) {

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

    uint participantIndices[numParticipants];
    foreach(ref i; participantIndices) {
        i = uniform(0, populationSize);
    }

    double maxFitness = 0;
    uint winnerIndex;
    foreach(i; participantIndices) {
        immutable fitness = F(population[i].genome);
        if(fitness > maxFitness) {
            maxFitness = fitness;
            winnerIndex = i;
        }
    }

    return population[winnerIndex];
}
