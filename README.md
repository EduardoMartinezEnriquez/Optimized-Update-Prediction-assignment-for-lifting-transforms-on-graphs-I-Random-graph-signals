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

- To obtain the result of computational complexity, decomment.... and the other non-low cost...
