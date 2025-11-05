:- discontiguous male/1.
:- discontiguous female/1.

male(george).
male(philip).
female(kydd).
male(spencer).
male(charles).
male(harry).
male(mark).
male(peter).
male(andrew).
male(eugenie).
male(edward).
male(james).
female(mum).
female(elizabeth).
female(diana).
female(anne).
female(sarah).
female(sophie).
female(beatrice).
female(louise).
female(zara).

father(george,elizabeth).
father(george,margaret).
father(philip,charles).
father(philip,anne).
father(philip,andrew).
father(philip,edward).
father(spencer,diana).
father(charles,william).
father(charles,harry).
father(mark, peter).
father(mark, zara).
father(andrew,beatrice).
father(andrew, eugenie).
father(edward,james).
father(edward,louise).

mother(mum,elizabeth).
mother(mum,margaret).
mother(kydd,diana).
mother(elizabeth,charles).
mother(elizabeth,anne).
mother(elizabeth,andrew).
mother(elizabeth,edward).
mother(diana,william).
mother(diana,harry).
mother(anne,peter).
mother(anne,zara).
mother(sarah,beatrice).
mother(sarah,eugenie).
mother(sophie,james).
mother(sophie,louise).

parent(X,Y):- father(X,Y).
parent(X,Y):- mother(X,Y).

% SIAMO ARRIVATI QUI

