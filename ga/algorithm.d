module ga.algorithm;

import ga.individual;
import ga.selection;

import std.stdio;
import std.parallelism;


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
            calculateFitnesses();

            generation++;
        }

        printGeneration(generation);
        return getFittest();
    }

private:

    MyPopulation[2] _populations;
    MyPopulation* _currentPopulation;
    MyPopulation* _otherPopulation;

    void init() {
        _currentPopulation = &_populations[0];
        _otherPopulation   = &_populations[1];

        calculateFitnesses();
    }

    double getHighestFitness() const pure nothrow {
        double max = 0;
        foreach(const ref ind; *_currentPopulation) {
            if(ind.fitness > max) max = ind.fitness;
        }

        return max;
    }

    ref const(GenomeType) getFittest() const pure nothrow {
        double max = 0;
        const(MyIndividual)* maxInd;
        foreach(const ref ind; *_currentPopulation) {
            if(ind.fitness > max) {
                max = ind.fitness;
                maxInd = &ind;
            }
        }

        return (*maxInd).genome;
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

    void calculateFitnesses() nothrow {
        //foreach(ref ind; taskPool.parallel(*_currentPopulation)) {
        foreach(ref ind; *_currentPopulation) {
            ind.calculateFitness!(FITNESS_FUNC)();
        }
    }
}
