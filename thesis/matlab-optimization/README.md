## Genetic Algorithm Optimization with MATLAB

* GA is part of a group of stochastic algorithm
* Here, our aim is to minimize predetermined objective function(total mass in our study~single objective optimization), which is `total_mass=mass_structure+mass_epoxy+mass_magnet+mass_copper+mass_steel` in our matlab .m file
* For this purpose MATLAB `optimtool()` function and its gui will be used 
* Constrains are mainly some of the design parameters which are choosed by user, for example : number of phases, air-gap length, rotational speed,axial length.
* Penalty factor will be used in order to convert constrained optimization to unconstrained optimization.
* Generally, a GA flowchart is given as follows,<br/>
![](./images/ga_flow.PNG)
