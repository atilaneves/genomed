import ga.algorithm;
import std.stdio;


double calcFitness(uint LENGTH)(const ref bool[LENGTH] genome) {
    uint trues;
    foreach(b; genome) {
        if(b) ++trues;
    }
    return trues;
}

void main() {
    enum populationSize = 20;
    enum genomeSize = 12;
    auto ga = GeneticAlgorithm!(populationSize, genomeSize, calcFitness)();
    enum endFitness = genomeSize;
    enum mutationRate = 0.5;
    immutable winner = ga.run(endFitness, mutationRate);

    writeln("Individual of fitness ", calcFitness(winner), " is ", winner);
}
