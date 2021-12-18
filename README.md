# Riemann Sphere Visualiser

Written in Processing 3.
## Download and Install
 - On windows, download the appropriate zip file marked "RiemannSphere Windows XX-Bit.zip"
 - Otherwise, download Processing 3 from https://processing.org/ and everything EXCEPT the zip files. Use Processing 3 to open RiemannSphere.pde and click "play"

## Description 
Visualises the Riemann Sphere by plotting functions (Including multivariable and some special functions) on the Complex Plane (using one of several colouring methods) on either a flat cartesian co-ordinate grid, or its stereographic projection to the Riemann Sphere.

## Controls
	ESC 			Exit program
	
    Dragging Mouse		Control Camera / Spinbox
    
    Right-Click & Drag 	When used on a spinbox, activates snapping to nearest integer/gridpoint(use polar grid for polar snapping)
    
	TAB			Open/Close Function Menu
	
	 P 			Switch between sphere and plane mode
	 
	 #			Next colour map (SHIFT for previous)
	 
	[/]			Change scaling for height in plane mode
	
    SHFT + [/]	Change scaling for colour maps (grid size)
    
   	 '			Enable/Disable mapping of |z| to height in plane mode



## Currently available single-variable functions (w=f(z)):

	w = z
	w = 1/z
	w = z²
	w = z³
	w = (z²+1) / (z²-1)
	w = exp(z)
	w = ln(z)
	w = sin(z)
	w = cos(z)
	w = tan(z)
	w = sinh(z)
	w = cosh(z)
	w = tanh(z)
	w = asin(z)
	w = acos(z)
	w = atan(z)
	w = asinh(z)
	w = acosh(z)
	w = atanh(z)	
	w = Binet(z) (Fibonacci numbers function.)
	w = 25th Iteration of the Mandelbrot Set at z
	w = exp(-z^2) (Gaussian)
	w = exp(-|z|^2) (Gaussian in magnitude)
	w = erf(z) (Error Function)
	w = Zeta(z) (Riemann Zeta Function)
	w = Gamma(z) (Gamma Function)
	w = 1/Gamma(z) (Reciprocal Gamma Function)

## Currently available multivariable functions

	w = Binomial (z choose K)
	w = Mobius Transform (Az + B)/(Cz + D)
	w = Atomic Singular Inner Function (Got the idea from https://blogs.ams.org/visualinsight/2013/10/15/atomic-singular-inner-function/ and assumed it would work as well with numbers other than 5)
	w = Polynomials from COEFFICIENTS
	w = Polynomials from ROOTS (Constructed as product of monomials of the form "(z - root)")
	w = Hermite Function (not polynomial, QHO solution, gaussian part has an absolute value on it)
Inputs lablled with capital letters are controlled using labelled spinboxes that appear when function is selected. Apologies for how hard it can be to read the numbers. I have some work to do.

## Work-In-Progress stuff
	w = ~Ath-order Bessel Function of the First Kind~ needs a better approximation for the Bessel Functions that doesn't diverge so hard
	Make function list adapt to screen size
	Hurwitz Zeta Function?
	Add something that lets the user change the level of detail and the range out to which everything is plotted. (Achievable if you download the source and run it in Processing by changing the variables RANGE and DETAIL in the main file) as of now it goes out to magnitude 16 by default.
	Add a new spinbox for non-integer reals. Mostly to adjust settings and whatnot but maybe for functions or adjusting branch cuts.
