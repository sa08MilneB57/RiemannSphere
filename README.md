# Riemann Sphere Visualiser

Written in Processing 3.
## Download and Install
 - On windows, download the appropriate zip file marked "RiemannSphere Windows XX-Bit.zip"
 - Otherwise, download Processing 3 from https://processing.org/ and everything EXCEPT the zip files. Use Processing 3 to open RiemannSphere.pde and click "play"

## Description 
Visualises the Riemann Sphere by plotting functions (Including multivariable and some special functions) on the Complex Plane (using one of several colouring methods) on either a flat cartesian co-ordinate grid, or its stereographic projection to the Riemann Sphere.

## Controls
Dragging Mouse	Control Camera / Spinbox

	TAB			Open Function Menu
	
	 P 			Switch between sphere and plane
	 
	 #			Next colour map (SHIFT for previous)
	 
	[/]			Change scaling for height in plane mode
	
SHIFT + [/]		Change scaling for colour maps (grid size)



## Currently available single-variable functions (w=f(z)):
	+ w = z
	+ w = 1/z
	+ w = z²
	+ w = z³
	+ w = (z²+1) / (z²-1)
	+ w = exp(z)
	+ w = ln(z)
	+ w = sin(z)
	+ w = cos(z)
	+ w = tan(z)
	+ w = sinh(z)
	+ w = cosh(z)
	+ w = tanh(z)
	+ w = asin(z)
	+ w = acos(z)
	+ w = atan(z)
	+ w = asinh(z)
	+ w = acosh(z)
	+ w = atanh(z)	
	+ w = Binet(z) (Fibonacci numbers function.)
	+ w = 25th Iteration of the Mandelbrot Set at z
	+ w = exp(-z^2) (Gaussian)
	+ w = exp(-|z|^2) (Gaussian in magnitude)
	+ w = erf(z) (Error Function)
	+ w = Zeta(z) (Riemann Zeta Function)
	+ w = Gamma(z) (Gamma Function)
	+ w = 1/Gamma(z) (Reciprocal Gamma Function)

## Currently available multivariable functions
	+ w = Binomial (z choose K)
	+ w = Mobius Transform (Az + B)/(Cz + D)
	+ w = (Not ready yet. Approximation diverges quickly.) ~Ath-order Bessel Function of the First Kind~ 
Inputs lablled with a capital letter are controlled using labelled spinboxes that appear when function is selected. Apologies for how hard it can be to read the numbers. I have some work to do.

## Work-In-Progress stuff
	+ Getting a better approximation for the Bessel Functions that doesn't diverge so hard
	+ Implement integer spinboxes for the Hermite Polynomials and similar families. (You can see a complex version of a Hermite Function by using the plus and minus keys already.)
	+ Make function list adapt to screen size
	+ Refactor multivariable functions code and stop treating them all like special cases.
