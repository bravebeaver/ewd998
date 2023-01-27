---- MODULE O ----
CONSTANT O(_)
THEOREM O(1) /\ O(2) <=> \E i \in {1,2}: O(i) OBVIOUS
THEOREM O(1) /\ O(2) <=> \A i \in {1,2}: O(i) OBVIOUS
THEOREM O(1) \/ O(2) <=> \E i \in {1,2}: O(i) OBVIOUS
THEOREM O(1) \/ O(2) <=> \A i \in {1,2}: O(i) OBVIOUS
=============================================================================
\* Modification History
\* Created Sun Jan 10 15:19:20 CET 2021 by Stephan Merz @muenchnerkindl