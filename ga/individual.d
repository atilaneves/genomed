module ga.individual;

import std.random;


struct Individual(uint LENGTH) {

    alias bool allele;

    this(allele[LENGTH] genome) {
        _genome = genome;
    }

    Individual[2] crossover(const ref Individual other, uint pos) const {
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

    void mutate(double rate) {
        for(int i = 0; i < LENGTH; ++i) {
            if(uniform(0.0, 1.0) < rate) {
                _genome[i] ^= 1; //toggle
            }
        }
    }

    @property auto ref allele[LENGTH] genome() const pure nothrow { return _genome; }

private:

    allele[LENGTH] _genome;
}
