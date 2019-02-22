Incremental-Decremental Algorithm for Computing AT-models and Persistent Homology
---------------------------------------------------------------------------------

[Changelog]
Version 01.01 (13 June 2012):
   - Initial release.

Version 01.01 (17 June 2012):
   - File "Readme" updated and file "00_Example_res_1.000.txt" added.

Version 03.00 (12 May 2013):
   - New design of algorithm. New function (calc_homology) calculates at-model from filename and resolution. And other new function allows export the results from results previous.


1. Introduction
---------------

This source code uses incremental-decremental algorithm to compute at-models and persistent homology.  Compute persistent homology is computed to provide topological evaluation of the 3D reconstruction process by the voxel carving technique.

 
2. Requirements
---------------
 
a) Installation of Matlab.

b) A file with data of voxel carving process. The file must have the following format:
   b.1) First line must start with "Cameras used in carving = XX". XX is the number cameras used in carving voxel.
   b.2) Second line must start with "X_coordinates ". And then a list of X coordinates belong points used in carving voxel.
   b.3) Third line must start with "Y_coordinates ". And then a list of Y coordinates belong points used in carving voxel.
   b.4) Fourth line must start with "Z_coordinates ". And then a list of Z coordinates belong points used in carving voxel.
   b.5) Fifth line is a blank line.
   b.6) b.2) to b.5) can repeat for distinct number cameras used in carving voxel.

c) Source code uncompressed.
 
3. Steps
--------

1- Start Matlab and access to directory of source code.

3- Execute the function "calc_homology" to calculate the values cameras minimum and maximum, and to generate nine files with the results: points, boundary, dimension, cubic complex, f, g, phi, homology and cells of homolgy.

      [ mincam, maxcam ] = calc_homology( filename, resolution );

4- After that, execute the function "export_results" to generate two files with the results: figure and csv format with the homology of all numbers of camera:

      export_results( mincam, maxcam, filename );


4. Results
----------

* filename.csv - This file contains the results of computing with all number of cameras.
* filename_camN.fig - This file contains figure with the results of computing with N cameras.
* filename_camN_points.mat - This file contains the points used in carving voxel.
* filename_camN_boundary.mat - This file contains the boundaries of points used in carving voxel.
* filename_camN_dimension.mat - This file contains the dimensiones of points used in carving voxel.
* filename_camN_C.mat - This file contains the cubic complex used in carving voxel.
* filename_camN_f.mat - This file is a savepoint data for f function of at-model.
* filename_camN_g.mat - This file is a savepoint data for g function of at-model.
* filename_camN_phi.mat - This file is a savepoint data for phi function of at-model.
* filename_camN_H.mat - This file is a savepoint data for H function of at-model.
* filename_camN_cellH.mat - This file is a savepoint data for cells generates homology.


5. Example
----------

Pending...
