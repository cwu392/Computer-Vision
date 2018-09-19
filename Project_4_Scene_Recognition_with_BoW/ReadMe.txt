If you want to try LibSVM:
1. go to libsvm/
2. make
3. change your vlfeat position
4. data_path

3.*Change your vlfeat position:
modity proj4.m 
line 36: run('../../vlfeat-0.9.20/toolbox/vl_setup')

4.*Check your data position
data_path = '../data/'; 

========================================================================
Gaussian Pyramid +3 (O) %gaussian fisher encoding
Spatial Pyramid +3 (O) %spyramid fisher encoding, build_spyramid_gmm
Fisher Encoding +5 (O) %fisher encoding
RBF SVM Kernel+3 (O) %Implement 2 types: svm rbf kernel libsvm (LibSVM) 
Kernel Codebook Encoding (O) %svm rbf kernel (Kernel Method)
Experiment many different vocabulary sizes +3 (O): Provide status_number (number=vocab) for verification
========================================================================
