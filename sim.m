#!/usr/bin/octave

%extend or retract pulley strings r1 and r2
function move_pulley(delta_r1,delta_r2)
	global r1;
	global r2;
	global x;
	global y;
	global dist;
	r1 += delta_r1;
	r2 += delta_r2;


	update_plot();
endfunction

%move pen on cartesian coordinates
function move_cart(delta_x,delta_y)
	global r1;
	global r2;
	global calc_x;
	global calc_y;
	global dist;
	%delta_r1 = (x/sqrt(x^2 + y^2))*delta_x + (y/sqrt(x^2 + y^2))*delta_y;
	%delta_r2 = ((x-dist)/sqrt((dist-x)^2 + y^2))*delta_x + ((y-dist)/sqrt((dist-y)^2 + y^2))*delta_y;
	r1
	r2
	calc_x += delta_x
	calc_y += delta_y
	final_r1 = sqrt((calc_x + delta_x)^2 + (calc_y + delta_y)^2);
	final_r2 = sqrt((dist - (calc_x + delta_x))^2 + (calc_y + delta_y)^2);
	plot(calc_x + delta_x, -(calc_y + delta_y), 'bo')
	hold on
	while final_r1 > r1 | final_r2 < r2
	delta_r1 = final_r1 - r1;
	delta_r2 = final_r2 - r2;

	if delta_r1 > delta_r2
		max_r = delta_r1;
	else
		max_r = delta_r2;
	endif

	%normalize deltas by largest delta (as int), this has the effect of only moving each stepper a maximum of 1 step per loop
	delta_r1 = floor(delta_r1/abs(max_r));
	delta_r2 = floor(delta_r2/abs(max_r));

	move_pulley(delta_r1,delta_r2)
	endwhile
	%recalculate calc_x and calc_y here
	printf('reached destination\n');

endfunction


%update plot with x and y globals
function update_plot()
	global dist;
	global r1;
	global r2;
	x = ((r1^2 - r2^2 + dist^2)/(2*dist));
	y = sqrt(r1^2 - x^2);
	plot([0 dist x],[0 0 -y],'ro');
	axis([-50 150 -100 50])
	pause
endfunction



global dist = 100; %distance between servos

global x = dist/2; %initial pen position
global y = 50;
global calc_x = x; %the position our bot thinks the pen is in
global calc_y = y;

global r1 = sqrt(calc_y^2 + calc_x^2)
global r2 = sqrt((dist-x)^2 + y^2)



for i = [0:1:100]
	move_cart(1,0)
endfor

