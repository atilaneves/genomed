module ga.algorithm;

import ga.individual;
import ga.selection;
import ga.util;

import std.stdio;
import std.algorithm;
import std.parallelism;


struct GeneticAlgorithm(uint genomeSize, alias FITNESS_FUNC, T = bool) {

    alias Individual!(genomeSize, T) MyIndividual;
    alias MyIndividual.GenomeType GenomeType;
    alias Population!(genomeSize, T) MyPopulation;

    this(uint populationSize) {
        _populations[0] = new MyIndividual[populationSize];
        _populations[1] = new MyIndividual[populationSize];
    }

    ref const(GenomeType) run(double endFitness, double mutationRate) {
        init();

        uint generation = 0;

        while(getHighestFitness() < endFitness) {
            printGeneration(generation);

            enum numParticipants = 2;
            tournament!(numParticipants)(mutationRate, _currentPopulation, _otherPopulation);
            swapPopulations();
            calculateFitnesses();

            generation++;
        }

        printGeneration(generation);
        return getFittest();
    }

private:

    MyPopulation[2] _populations;
    MyPopulation _currentPopulation;
    MyPopulation _otherPopulation;

    void init() {
        _currentPopulation = _populations[0];
        _otherPopulation   = _populations[1];

        calculateFitnesses();
    }

    double getHighestFitness() const pure {
        return maxElement(getFitnesses());
    }

    ref const(GenomeType) getFittest() const pure {
        immutable max = getHighestFitness();
        return find!((a, b) => a.fitness >= b)(_currentPopulation, max)[0].genome;

    }

    auto getFitnesses() const pure {
        return map!(a => a.fitness)(_currentPopulation);
    }

    void printGeneration(uint generation) const {
        writeln("Generation ", generation);
        foreach(const ref ind; _currentPopulation) {
            writeln(ind.genome);
        }
        writeln();
    }

    void swapPopulations() nothrow {
        MyPopulation tmp = _currentPopulation;
        _currentPopulation = _otherPopulation;
        _otherPopulation = tmp;
    }

    void calculateFitnesses() {
        foreach(ref ind; taskPool.parallel(_currentPopulation)) {
            ind.calculateFitness!(FITNESS_FUNC)();
        }
    }
}
