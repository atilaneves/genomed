module ga.algorithm;

import ga.individual;
import ga.selection;

import std.stdio;
import std.algorithm;
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

    double getHighestFitness() const pure {
        return minCount!("a > b")(getFitnesses())[0];
    }

    ref const(GenomeType) getFittest() const pure {
        const haystack = (*_currentPopulation)[0..$];
        immutable max = getHighestFitness();
        return find!((a, b) => a.fitness >= b)(haystack, max)[0].genome;

    }

    auto getFitnesses() const pure {
        return map!(a => a.fitness)((*_currentPopulation)[0..$]);
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
