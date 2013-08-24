module ga.algorithm;

import ga.individual;
import ga.selection;
import std.stdio;


struct GeneticAlgorithm(uint populationSize, uint genomeSize, alias FITNESS_FUNC, T = bool) {

    alias Individual!(genomeSize, T) MyIndividual;
    alias MyIndividual.GenomeType GenomeType;
    alias Population!(populationSize, genomeSize, T) MyPopulation;

    auto ref GenomeType run(double endFitness, double mutationRate) {
        init();

        uint generation = 0;
        writeln("highest: ", getHighestFitness());
        while(getHighestFitness() < endFitness) {
            writeln("highest: ", getHighestFitness());
            printGeneration(generation);

            tournament!(FITNESS_FUNC, 2)(_currentPopulation, _otherPopulation);

            swapPopulations();

            generation++;
        }

        return MyIndividual().genome;
    }

private:

    MyPopulation[2] _populations;
    MyPopulation* _currentPopulation;
    MyPopulation* _otherPopulation;
    double[populationSize] _fitnesses;

    void init() {
        _currentPopulation = &_populations[0];
        _otherPopulation   = &_populations[1];

        foreach(i, ref fitness; _fitnesses) {
            fitness = FITNESS_FUNC((*_currentPopulation)[i].genome);
            writeln("fitness", i, ": ", fitness);
        }
    }

    double getHighestFitness() const pure nothrow {
        double max = 0;
        foreach(fitness; _fitnesses) {
            if(fitness > max) max = fitness;
        }

        return max;
    }

    auto ref GenomeType getFittest() const pure nothrow {
        double max;
        ulong maxi;
        foreach(i, fitness; _fitnesses) {
            if(fitness > max) {
                max = fitness;
                maxi = i;
            }
        }

        return (*_currentPopulation)[maxi].genome;
    }

    void printGeneration(uint generation) const {
        writeln("Generation ", generation);
        foreach(const ref ind; *_currentPopulation) {
            writeln(ind.genome);
        }
        writeln();
    }

    void swapPopulations() nothrow {
        MyPopulation* tmp = _currentPopulation;
        _currentPopulation = _otherPopulation;
        _otherPopulation = tmp;
    }
}
