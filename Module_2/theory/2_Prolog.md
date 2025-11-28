## Prolog 

`A`**`Prolog`**`program is a set of definite clauses.`

## 1. Syntax
But, what is a clause? A clause is set of different logic terms, which typically are:
- __Variables__: strings starting with a __uppercase__ letter.
- __Constants__: numbers or strings starting with a __lowercase__ letter.
- __Atomic formulas__: defined as `p(t1, t2, ..., tn)` where _p_ is a predicate.
- __Compound terms__: known also as _structures_, they are defined similary to a traditional function `f(t1, t2, ..., tn)`, where _f_ is a __function symbol__ and _t1, t2, ..., tn_ are __terms__.

In this way they seem to be so difficult to understand, let's consider a more intuitive approach.
```prolog
X, X1, Goofey, _goofey, _x, _ % variables, the underscore symbol "_" is usually used for variables.

a, goofey, aB, 9, 135, a92 % constants.

p, p(a, f(x)), p(y), q(1) % atomic formulas.

f(a), f(g(1)), f(g(1), b(a), 27) % compound terms.
```

Additionally to the key elements of __prolog__, we have also different types of clauses:
- __Fact__: ```A.``` represents a statement which is always true.
- __Rule__: ```A :- B1, B2, ..., Bn``` ```A``` is true if and only if ```B1, B2, ..., Bn``` is true.
- __Goal__: ```:- B1, B2, ..., Bn``` it's a question asked to the system.

```prolog
q. % fact

p :- q, r % rule

r(z). % fact

p(x) :- q(X, g(a)) % rule
```

The comma symbol `,` represents the logical __conjuction__ $\land$, instead the neck symbol `:-` defines the implication $\leftarrow$, read from the right to the left.

## 2. Declarative and procedural interpretations
Any prolog program has two main interpretations, divide into:
- __Declarative interpretation__: variables within a clause are universally quantified. For each fact:
    ```prolog
    p(t1, t2, ..., tn).
    ```
    If `X1, X2, ..., Xn` are the variables appearing in `t1, t2, ..., tn` the intended meaning is: `∀X1, ∀X2, ..., ∀Xn` the fact `p(t1, t2, ..., tn)` is verified.

    The meaning changes when we talk about __rules__. For each rule: 
    ```prolog
    A :- B1, B2, ..., Bk.
    ``` 
    If `Y1, Y2, ..., Yn` are the variables appearing only in the body of the rule the intended meaning is: `∀X1, ∀X2, ..., ∀Xn` such that `∃Y1, ∃Y2, ..., ∃Yn (B1, B2, ..., Bn))  → A)`, in other words for each variable `Xi` if exist variables `Y1, Y2, ..., Yn` the head of the clause `A` is verified. Let's see an example for a better understanding.
    ```prolog
    happyperson(X) :- has(X, Y), car(Y) % for each person X, if exists a car Y (anyone) that X holds, X is a happy person.
    ```
    If `X1, X2, ..., Xn` are the variables appearing in both the body and the head of the rule the intended meaning is: `∀X1, ∀X2, ..., ∀Xn ∀Y1, ∀Y2, ..., ∀Yn ((B1, B2, ..., Bn) → A)`, in other words for each variable `Xi` and variable `Yi` the head of the clause `A` is verified.
    ```prolog
    father(X, Y). % defining the facts of the universe described.
    mother(X, Y).

    grandfather(X, Y) :- father(X, Z), father(Z, Y) % rules highly dependent from the facts.
    grandmother(X, Y) :- mother(X, Z), mother(Z, Y)
    ```
- __Procedural interpretation__: a procedure is a set of clauses with the same head and the same number of parameters required. Prolog adopts the __SLD resolution process__ and it has two main charateristics, which are:
    - It selects the __left-most__ literal in any possible query.
        ```prolog
        ? :- G1, G2, ..., Gn.
        ```
    - It performs __Depth-First Search__ strategy. According to the search strategy selected,