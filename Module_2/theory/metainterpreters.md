# The starting point - Meta-interpreters

- In Prolog, no difference between programs and data, or, using the Prolog terminology, …
- …No difference (in the representation) between predicates and terms.
- We can ask the Prolog interpreter to provide us the clauses of the (currently loaded) program
  ```prolog
  clause(Head, Body).
  ```
- We can also ask the interpreter to "execute" a term
  ```prolog
  call(T).
  ```

# Meta-interpreters

- Meta-interpreters as meta-programs, i.e., programs who execute/works/deal with other programs
  - Programs as input of meta-programs
- Used for rapid prototyping of interpreters of symbolic languages
- In Prolog, a meta-interpreter for a language L is defined as an interpreter for L, but written in Prolog
- Given the premises, would it be possible to write a Prolog interpreter for the language Prolog?
# Meta-interpreter for Pure Prolog
## aka the vanilla meta-interpreter

- Define a predicate solve(goal) that answers true if Goal can be proved using the clauses of the current program

```prolog
solve(true) :- !.
solve( (A,B) ) :- !, solve(A), solve(B).
solve(A) :- clause(A,B), solve(B).
```

- Notice: it does not deal with pre-defined predicates…
  - For each pre-defined predicate, needs to add a specific solve clause that deal with it

- Notice: no need to "call" any predicate. The vanilla meta-interpreter explores the current program, searching for the clauses, until it can prove the goal, or it fails.
- As it is, the vanilla meta-interpreter mimic the standard behaviour of the Prolog interpreter…
- … but now, we can modify it and get different behaviours

# Meta-interpreters for Pure Prolog – Example

## Right-most selection rule

Example: define a Prolog interpreter that adopts the calculus rule "right most":

```prolog
solve(true) :- !.
solve( (A,B) ) :- !, solve(A), solve(B).
solve(A) :- clause(A,B), solve(B).
```


# Meta-interpreters for Prolog – Example

Define a Prolog interpreter solve(Goal, Step) that:
- It is true if Goal can be proved
- In case Goal is proved, Step is the number of resolution steps used to prove the goal
  - In case of conjunctions, the number of steps is defined as the sum of the steps needed for each atomic conjunct

Given the program:
```prolog
a :- b, c.
b :- d.
c.
d.
```

```prolog
?- solve(a, Step)
yes Step=4
```

# Meta-interpreters for Prolog – Example

Define a Prolog interpreter solve(Goal, Step) that:
- It is true if Goal can be proved
- In case Goal is proved, Step is the number of resolution steps used to prove the goal
  - In case of conjunctions, the number of steps is defined as the sum of the steps needed for each atomic conjunct

```prolog
solve(true,0):-!.
solve((A,B),S) :- !, solve(A,SA),
                   solve(B,SB),
                   S is SA+SB.
solve(A,S) :- clause(A,B),
              solve(B,SB),
              S is 1+SB.
```

Let us suppose to represent a knowledge base in terms of rules, and for each rule we have also a "certainty" score (between 0 and 100).

Example:
```prolog
rule(a, (b,c), 10).
rule(b, true, 100).
rule(c, true, 50).
```

Define a meta-interpreter solve(Goal,CF), that is true if Goal can be proved, with certainty CF.

- For conjunctions, the certainty is the minimum of the certainties of the conjuncts

- For rules, the certainty is the product of the certainty of the rule itself times the certainty of the proof of the body (eventually divided by 100).

```prolog
rule(a, (b,c), 10).
rule(a, d, 90).
rule(b,true, 100).
rule(c,true, 50).
rule(d,true, 100).

?- solve(a,CF).
yes CF=5;
yes CF=90
```

```prolog
solve(true,100):-!.
solve((A,B),CF) :- !, solve(A,CFA),
                    solve(B,CFB),
                    min(CFA,CFB,CF).
solve(A,CFA) :- rule(A,B,CF),
                solve(B,CFB),
                CFA is ((CFB*CF)/100).
min(A,B,A) :- A<B,!.
min(A,B,B).
```