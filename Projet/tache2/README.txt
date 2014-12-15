%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% README-Ammonia Synthesis Simulation Tool %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HOW TO USE THE TOOL?

Warning:All the other functions provided must be present in the same 
emplacement that RUN otherwise it wont work.

To run the Ammonia Synthesis Simulaiton Tool:
1. Run the RUN.m file.
2. Input the parameters (without units) and click calculate
	- T1[K] Primary Reformer temperature.
	- M[t/day] Ammonia daily flow in tons.
	- T[K] Synthesis Reactor temperature.
	- p[bar], Synthesis Reactor pressure.
	- mu, the purge split fraction.
3. Wait until the results are displayed in the screen.
4. To start a new simulation, start step (2).

HOW DOES THE TOOL WORK?

The functions Cp, deltaH, deltaS, deltaSelem, K are used in outil.
The function outil calculates the flow, storing the values in a global variable,
these values will then be displayed by RUN.
Once the RUN gui executed, it takes the input arguments and use them to
execute outil
