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

	r1=(r1);
	r2=(r2);

	update_plot();
endfunction

%move pen on cartesian coordinates
function move_cart(delta_x,delta_y)
	global r1;
	global r2;
	global dist;
	global calc_x;
	global calc_y;

	final_r1 = (sqrt((calc_x + delta_x)^2 + (calc_y + delta_y)^2));
	final_r2 = (sqrt((dist - (calc_x + delta_x))^2 + (calc_y + delta_y)^2));

	delta_r1 = final_r1 - r1
	delta_r2 = final_r2 - r2
	%plot target point
	plot(calc_x + delta_x, -(calc_y + delta_y), 'bo')
	hold on


	if abs(delta_r1) > abs(delta_r2)
		max_r = abs(delta_r1);
	else
		max_r = abs(delta_r2);
	endif

	dir_r1 = delta_r1/abs(delta_r1)
	dir_r2 = delta_r2/abs(delta_r2)
	interval_r1 = floor(max_r/delta_r1);
	interval_r2 = floor(max_r/delta_r2);
	for i = [1:max_r]
		step_r1 = dir_r1 * (mod(i,interval_r1) == 0);
		step_r2 = dir_r2 * (mod(i,interval_r2) == 0);
		move_pulley(step_r1,step_r2)
	endfor
	%recalculate calc_x and calc_y here
	printf('reached destination\n');
	calc_x += delta_x;
	calc_y += delta_y

endfunction


%update plot with x and y globals
function update_plot()
	global dist;
	global r1;
	global r2;
	global xlast;
	global ylast;
	x = ((r1^2 - r2^2 + dist^2)/(2*dist));
	y = sqrt(r1^2 - x^2);
	plot([0 dist],[0 0],'ro');
	plot([xlast x],[-ylast -y],'r-');
	axis([-50 150 -100 50])
	ylast=y;
	xlast=x;
	pause
endfunction



global dist = 100; %distance between servos

global x = dist/2; %initial pen position
global y = 50;
global calc_x = x; %the position our bot thinks the pen is in
global calc_y = y;
global xlast=x;
global ylast=y;

global r1 = sqrt(calc_y^2 + calc_x^2)
global r2 = sqrt((dist-x)^2 + y^2)



for i = [0:1:100]
	move_cart(4,0)
endfor

