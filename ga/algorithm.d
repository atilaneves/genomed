module ga.algorithm;

import ga.individual;
import ga.selection;
import std.stdio;


struct GeneticAlgorithm(uint populationSize, uint genomeSize, alias FITNESS_FUNC, T = bool) {

    alias Individual!(genomeSize, T) MyIndividual;
    alias MyIndividual.GenomeType GenomeType;
    alias Population!(populationSize, genomeSize, T) MyPopulation;

    ref const(GenomeType) run(double endFitness, double mutationRate) {
        init();

        uint generation = 0;

        while(getHighestFitness() < endFitness) {
            printGeneration(generation);

            enum numParticipants = 2;
            tournament!(FITNESS_FUNC, numParticipants)(mutationRate, *_currentPopulation, *_otherPopulation);
            swapPopulations();

            foreach(i, ref ind; *_currentPopulation) {
                _fitnesses[i] = FITNESS_FUNC(ind.genome);
            }

            generation++;
        }

        printGeneration(generation);
        return getFittest();
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
        }
    }

    double getHighestFitness() const pure nothrow {
        double max = 0;
        foreach(fitness; _fitnesses) {
            if(fitness > max) max = fitness;
        }

        return max;
    }

    ref const(GenomeType) getFittest() const pure nothrow {
        double max = 0;
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
