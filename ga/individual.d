module ga.individual;

import std.algorithm;


struct Individual(uint LENGTH) {

    alias ubyte allele;

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

    @property allele[LENGTH] genome() const pure nothrow { return _genome; }

private:

    allele[LENGTH] _genome;
}
