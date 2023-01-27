---------------------- MODULE AsyncTerminationDetection ---------------------
\* * TLA+ is an expressive language and we usually define operators on-the-fly.
 \* * That said, the TLA+ reference guide "Specifying Systems" (download from:
 \* * https://lamport.azurewebsites.net/tla/book.html) defines a handful of
 \* * standard modules.  Additionally, a community-driven repository has been
 \* * collecting more modules (http://modules.tlapl.us). In our spec, we are
 \* * going to need operators for natural numbers.
EXTENDS Naturals

\* * A constant is a parameter of a specification. In other words, it is a
 \* * "variable" that cannot change throughout a behavior, i.e., a sequence
 \* * of states. Below, we declares N to be a constant of this spec.
 \* * We don't know what value N has or even what its type is; TLA+ is untyped and
 \* * everything is a set. In fact, even 23 and "frob" are sets and 23="frob" is 
 \* * syntactically correct.  However, we don't know what elements are in the sets 
 \* * 23 and "frob" (nor do we care). The value of 23="frob" is undefined, and TLA+
 \* * users call this a "silly expression".
CONSTANT N

\* * We should declare what we assume about the parameters of a spec--the constants.
 \* * In this spec, we assume constant N to be a (positive) natural number, by
 \* * stating that N is in the set of Nat (defined in Naturals.tla) without 0 (zero).
 \* * Note that the TLC model-checker, which we will meet later, checks assumptions
 \* * upon startup.
ASSUME NIsPosNat == N \in Nat \ {0}

\* a ring of nodes
Nodes == 0 .. N-1 


VARIABLE 
      \* maintain the activation status of our nodes
      active, 
      \* the  in-flight messages from other nodes that the node has yet to receive
      pending

\* the spec's variable
vars == << active, pending >>

\* for all variables in var, initialize them to their initial values
Init == 
     \* all nodes are active and there is no message pending
    /\ active \in [Nodes -> TRUE]
    /\ pending \in [Nodes -> 0]
    \* or element wise.
    \* /\ active = [n \in Nodes |-> TRUE]
    \* /\ pending = [n \in Nodes |-> 0]

\* TLA+ does not enforce type, and it is best to enforce that yourself
TypeOK == 
    /\ active \in [Nodes -> BOOLEAN]
    /\ pending \in [Nodes -> Nat]

\* define behavior which move the state forward.
\* two or more actions do not happen simultaneously. 
\* to model behavior happened at two nodes at once, the action needs to be at proper granularity with the parameters

\* node n terminates
Terminate(n) == 
    /\ active[n] 
    /\ active' = [ active EXCEPT ![n] = FALSE ]
    /\ UNCHANGED pending

SendMsg(m, n) == 
    \* TODO You should now be able to specify SendMsg and Wakeup (Note that the @
    \* TODO symbol refers to the old value in a function update).
    /\ active[m]
    /\ pending' = [ pending EXCEPT ![n] = @ + 1 ]
    /\ UNCHANGED active


RcvMsg(n) == 
    /\ pending[n] > 0
    /\ pending' = [ pending EXCEPT ![n] = @ - 2 ]
    /\ active' = [ active EXCEPT ![n] = TRUE ]

=============================================================================
\* Modification History
\* Created Sun Jan 10 15:19:20 CET 2021 by Stephan Merz @muenchnerkindl