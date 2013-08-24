module ga.selection;

import ga.individual;
import std.random;

void tournament(alias F, uint numParticipants = 2, uint populationSize, uint genomeSize, T)(
    // Population!(populationSize, genomeSize, T)* oldPopulation,
    // Population!(populationSize, genomeSize, T)* newPopulation) {
    Individual!(genomeSize, T)[populationSize]* oldPopulation,
    Individual!(genomeSize, T)[populationSize]* newPopulation) {

    uint index;

    while(index < populationSize) {
        immutable fatherIndex = getWinner!(F, numParticipants)(oldPopulation);
        const father = (*oldPopulation)[fatherIndex];

        immutable motherIndex = getWinner!(F, numParticipants)(oldPopulation);
        const mother = (*oldPopulation)[motherIndex];

        immutable xoverPoint = uniform(0, genomeSize);
        immutable children = father.crossover(mother, xoverPoint);

        (*newPopulation)[index++] = children[0];
        (*newPopulation)[index++] = children[1];
    }

}

private uint getWinner(alias F, uint numParticipants, uint populationSize, uint genomeSize, T)(
    Population!(populationSize, genomeSize, T)* oldPopulation) {

    uint participantIndices[numParticipants];
    foreach(ref i; participantIndices) {
        i = uniform(0, populationSize);
    }

    double maxFitness = 0;
    uint winner;
    foreach(i; participantIndices) {
        immutable fitness = F((*oldPopulation)[i].genome);
        if(fitness > maxFitness) {
            maxFitness = fitness;
            winner = i;
        }
    }

    return winner;
}
