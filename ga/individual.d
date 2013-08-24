module ga.individual;

import std.random;


struct Individual(uint LENGTH, T = bool) {

    alias T allele;
    alias allele[LENGTH] GenomeType;

    this(GenomeType genome) {
        _genome = genome;
    }

    Individual[2] crossover(const ref Individual other, uint pos) const
        in {
            assert(pos < LENGTH);
        }
        body {
            auto child1 = Individual!LENGTH();
            auto child2 = Individual!LENGTH();

            for(int i = 0; i < pos; ++i) {
                child1._genome[i] = this._genome[i];
                child2._genome[i] = other._genome[i];
            }

            for(int i = pos; i < LENGTH; ++i) {
                child2._genome[i] = this._genome[i];
                child1._genome[i] = other._genome[i];
            }

            return [child1, child2];
        }

    void mutate(double rate)
        in {
            assert(rate >= 0.0);
            assert(rate <= 1.0);
        }
        body {
            for(int i = 0; i < LENGTH; ++i) {
                if(uniform(0.0, 1.0) < rate) {
                    _genome[i] ^= 1; //toggle
                }
            }
        }

    void calculateFitness(alias F)() pure nothrow {
        _fitness = F(_genome);
    }

    @property auto ref GenomeType genome() const pure nothrow { return _genome; }
    @property double fitness() const pure nothrow { return _fitness; }

private:

    GenomeType _genome = void;
    double _fitness;
}

template Population(uint populationSize, uint genomeSize, T = bool) {
    alias Individual!(genomeSize, T)[populationSize] Population;
}
