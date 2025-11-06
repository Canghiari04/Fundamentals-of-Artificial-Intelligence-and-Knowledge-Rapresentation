
male(george).
male(philip).
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
female(kydd).

parent(george,elizabeth).
parent(george,margaret).
parent(philip,charles).
parent(philip,anne).
parent(philip,andrew).
parent(philip,edward).
parent(spencer,diana).
parent(charles,william).
parent(charles,harry).
parent(mark,peter).
parent(mark,zara).
parent(andrew,beatrice).
parent(andrew,eugenie).
parent(edward,james).
parent(edward,louise).
parent(mum,elizabeth).
parent(mum,margaret).
parent(kydd,diana).
parent(elizabeth,charles).
parent(elizabeth,anne).
parent(elizabeth,andrew).
parent(elizabeth,edward).
parent(diana,william).
parent(diana,harry).
parent(anne,peter).
parent(anne,zara).
parent(sarah,beatrice).
parent(sarah,eugenie).
parent(sophie,james).
parent(sophie,louise).


father(X,Y):- parent(X,Y), male(X).
mother(X,Y):- parent(X,Y), female(X).

% SIAMO ARRIVATI QUI

sibling(X,Y):- parent(Z,X), parent(Z,Y), X \= Y.
% NO idempotence i cant be sibling of myself
% 