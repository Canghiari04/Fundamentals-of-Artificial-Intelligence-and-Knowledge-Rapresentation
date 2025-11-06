# Meta-predicates in Prolog

## Introduction

In Prolog, predicates (programs) and terms (data) share the same syntactical structure. This unique feature allows predicates and terms to be exchanged and exploited in different roles. Meta-predicates are predefined predicates that work with these structures.

## The `call` Predicate

### Basic Usage

The `call/1` predicate treats a term as a predicate and requests the Prolog interpreter to evaluate it:

```prolog
p(a).
q(X) :- p(X).

% Query: call(q(Y))
% Result: Y = a
```

### In Programs

```prolog
p(X) :- call(X).
q(a).

% Query: p(q(Y))
% Result: Y = a
```

Some Prolog interpreters allow the shorthand:
```prolog
p(X) :- X.  % Equivalent to p(X) :- call(X).
```

### Example: If-Then-Else Construct

```prolog
if_then_else(Cond, Goal1, Goal2) :-
    call(Cond), !,
    call(Goal1).
if_then_else(Cond, Goal1, Goal2) :-
    call(Goal2).
```

## The `fail` Predicate

### Basic Behavior

- `fail/0` takes no arguments (arity zero)
- Its evaluation always fails
- Forces **backtracking** explicitly
  (we explicitly use it force backtracking and explore other branches of the search tree)

### Applications

#### 1. Iteration Over Data

```prolog
iterate :-
    call(p(X)),
    verify(q(X)),
    fail.
iterate.

verify(q(X)) :- call(q(X)), !.
```

#### 2. Negation as Failure

```prolog
not(P) :- call(P), !, fail.
not(P).
```

#### 3. Defaults with Exceptions

```prolog
fly(X) :- penguin(X), !, fail.
fly(X) :- ostrich(X), !, fail.
fly(X) :- bird(X).
```

## Second-Order Predicates

### `setof/3` and `bagof/3`

These predicates answer second-order queries: "which is the set/list of elements X such that p(X) is true?"

#### Knowledge Base for Examples
```prolog
p(1).
p(2).
p(0).
p(1).
q(2).
r(7).
```

#### Basic Examples

```prolog
% setof returns unique elements, usually sorted
?- setof(X, p(X), S).
S = [0,1,2]

% bagof returns all elements in order of finding
?- bagof(X, p(X), S).
S = [1,2,0,1]
```

#### Conjunction of Goals

```prolog
?- setof(X, (p(X), q(X)), S).
S = [2]

?- bagof(X, (p(X), q(X)), S).
S = [2]
```

#### Complex Terms

```prolog
?- setof(p(X), p(X), S).
S = [p(0), p(1), p(2)]

?- bagof(p(X), p(X), S).
S = [p(1), p(2), p(0), p(1)]
```

### Variable Quantification

#### Knowledge Base
```prolog
father(giovanni, mario).
father(giovanni, giuseppe).
father(mario, paola).
father(mario, aldo).
father(giuseppe, maria).
```

#### Without Explicit Quantification
```prolog
?- setof(X, father(X, Y), S).
% Returns X for each specific Y value
Y = aldo, S = [mario];
Y = giuseppe, S = [giovanni];
Y = maria, S = [giuseppe];
Y = mario, S = [giovanni];
Y = paola, S = [mario]
```

#### With Existential Quantification
```prolog
?- setof(X, Y^father(X, Y), S).
S = [giovanni, mario, giuseppe]
```

#### Compound Terms
```prolog
?- setof((X, Y), father(X, Y), S).
S = [(giovanni, mario), (giovanni, giuseppe),
     (mario, paola), (mario, aldo),
     (giuseppe, maria)]
```

## The `findall/3` Predicate

### Behavior
- Similar to `setof` and `bagof`
- Variables not in first argument are automatically existentially quantified
- Returns empty list if no solutions exist (instead of failing)

### Examples

```prolog
?- findall(X, father(X, Y), S).
S = [giovanni, mario, giuseppe]

% Equivalent to: setof(X, Y^father(X, Y), S)
```

## Working with Rules

Meta-predicates work with both facts and rules:

```prolog
p(X, Y) :- q(X), r(X).
q(0).
q(1).
r(0).
r(2).

?- findall(X, p(X, Y), S).
S = [0]
```

## Practical Application: Implication Verification

Verify that all sons of a person are employees:

```prolog
father(p, Y) → employee(Y)

imply(Y) :-
    setof(X, father(Y, X), L),
    verify(L).

verify([]).
verify([H|T]) :-
    employee(H),
    verify(T).
```

## Key Points Summary

| Predicate | Behavior | Empty Case |
|-----------|----------|------------|
| `call(T)` | Executes term T as predicate | Fails if T fails |
| `fail` | Always fails, forces backtracking | Always fails |
| `setof(X,P,S)` | S is set of X satisfying P | Fails if no solutions |
| `bagof(X,P,L)` | L is list of X satisfying P | Fails if no solutions |
| `findall(X,P,L)` | L is list of X satisfying P | Returns [] if no solutions |

These meta-predicates provide powerful meta-programming capabilities, allowing Prolog programs to reason about and manipulate other Prolog programs dynamically.

## Iteration through setof
```prolog
% Iteration through setof
% Execute the procedure q on each element for which p is true
iterate :-
    setof(X, p(X), L),
    filter(L).

filter([]).
filter([H|T]) :-
    call(q(H)),
    filter(T).

% Which difference with the implementation made through fail? What about backtrackability?

% Verifying properties of terms
% var(Term) - true if Term is currently a variable
% nonvar(Term) - true if Term currently is not a free variable
% number(Term) - true if Term is a number
% ground(Term) - true if Term holds no free variables.

% Accessing the structure of a term
% Term =.. List
% [SWI documentation]
% – List is a list whose head is the functor of Term and the
%   remaining arguments are the arguments of the term.
% – Either side of the predicate may be a variable, but not both.

% Examples:
% ?- foo(hello, X) =.. List.
% List = [foo, hello, X]
% 
% ?- Term =.. [baz, foo(1)].
% Term = baz(foo(1))
```
## Accessing the clauses of a program
In Prolog, terms and predicates are represented with
the same structure
In particular, a clause (a query) is represented as a
term

```prolog

% Example: given
% h.
% h :- b1, b2, …, bn.
% They correspond to the terms:
% (h, true)
% (h, ','(b1, ','(b2, ','( ...','( bn-1, bn) ...)))
```
## Accessing the clauses of a program – the predicate clause
```prolog

% clause(Head, Body)
% true if (Head, Body) is unified with a clause stored
% within the database program
% When evaluated
% – Head must be instantiated to a non-numeric term
% – Body can be a variable or a term describing the body of a
% clause
% Its evaluation opens choice points, if more clauses
% with the same head are available
```
```prolog
% The predicate clause – example
% Program:
?- dynamic(p/1).
?- dynamic(q/2).
p(1).
q(X,a) :- p(X), r(a).
q(2,Y) :- d(Y).

?- clause(p(1),BODY).
yes BODY=true

?- clause(p(X),true).
yes X=1

?- clause(q(X,Y), BODY).
yes X=_1 Y=a BODY=p(_1),r(a);
X=2 Y=_2 BODY=d(_2);
no

?- clause(HEAD,true).
Error - invalid key to data-base
```

# Other amenities… Loading modules and libraries

- Modern Prolog interpreters come equipped with a huge library of code.
- To load a library:
  ```prolog
  use_module(library(XXX)).
  ```
- Example (SWI Prolog):
  ```prolog
  :- use_module(library(lists)).
  ```
  Load the pre-defined predicates for dealing with lists

- library(aggregate)
- library(ansi_term)
- library(apply)
- library(assoc)
- library(broadcast)
- library(charsio)
- library(check)