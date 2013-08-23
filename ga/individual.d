module ga.individual;

struct Individual(uint length) {

    alias ubyte allele;

    Individual[] crossover(const ref Individual other, uint pos) const pure nothrow {
        return [];
    }

    @property allele[] genome() const pure nothrow { return []; }

private:

    allele[] _genome;
}
