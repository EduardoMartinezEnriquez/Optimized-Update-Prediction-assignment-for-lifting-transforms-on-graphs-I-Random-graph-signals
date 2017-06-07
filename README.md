Optimized Update/Prediction Assignment for Lifting Transforms on Graphs
========
This is the source code related with the paper "Optimized Update/Prediction Assignment for Lifting Transforms on Graphs", 
Eduardo Martínez-Enríquez, Jesús Cid-Sueiro, Fernando Díaz-de-María and Antonio Ortega.
========
RANDOMLY GENERATED GRAPH SIGNALS

- To obtain the results with randomly generated graph signals (Fig.4 of the paper), run "Test_main.m" with the parameters
given in Fig.4, a, b and c. Note that the results will not be exactly the same (because in this Section the
graphs and signal are randomly generated), but should be quite similar.

Please, note that GSP toolbox is used in this script. GSP is a Free software, released under 
the GNU General Public License (GPLv3). Please, download the GSPBox for Windows at 
https://lts2.epfl.ch/gsp/ and type >>gsp_install from matlab to be able to run this script.

- To obtain results with randomly generated graph signals of Figure 5 of the paper, just run "Test_main.m" 
changing the statistical parameters related with the graph and signal generation (N, var_ep, var_et, and c).

- To obtain the results of the mean and standard deviation of the Degree (Figure 7) run "Test_main.m".

- To obtain the result of computational complexity (Figure 6), please, comment the error evaluation in the function greedy_MAM.m. The 
time for every iteration of the complete process is located in vectors time_MAM and time_WMC. Results in the paper are obtained with 
a sensor network toplogy and the following parameters: var_ep=400; nu_et=0; var_et=100; c=100. 
To obtain results with the greedy exhaustive approach, decomment the code lines in the "Test_main.m" function 
under the comment %GREEDY EXHAUSTIVE ALGORITHM FOR THE PROPOSED (MAM) UPA SOLUTION. The energy results are the same than using greedy_MAM, 
but the algorithm is much slower.
NOTE: The algorithms use parfor commands (execute loop iterations in parallel) from the Parallel Computing Toolbox. 
"Parfor" loops can be changed to "for" loops, but the execution time will be higher.
