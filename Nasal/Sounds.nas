#
# Author: Slavutinsky Victor
#

#--------------------------------------------------------------------
# Sound timer

# helper 
stop_sounds = func {
}

sounds = func 
	{
		# inflight time
		var time = getprop("fdm/jsbsim/simulation/sim-time-sec");
		var prev_time = getprop("fdm/jsbsim/systems/sounds/prev-time");
		var click = getprop("fdm/jsbsim/systems/sounds/click/on");
		var click_time = getprop("fdm/jsbsim/systems/sounds/click/time-sec");
		if ((time == nil) or (prev_time == nil) or (click == nil) or (click_time == nil))
		{
			stop_sounds();
			return ( settimer(sounds, 0.1) ); 
		}
		var time_step=0;
		if ((prev_time>0) and ((time-prev_time)>0))
		{
			time_step=time-prev_time;
		}
		if (click==1)
		{
			click_time=click_time+time_step;
			if (click_time>0.5)
			{
				click_time=0;
				setprop("fdm/jsbsim/systems/sounds/click/on", 0);
			}
			setprop("fdm/jsbsim/systems/sounds/click/time-sec", click_time);
		}

		setprop("fdm/jsbsim/systems/sounds/prev-time", time);

		settimer(sounds, 0.0);
	}

# set startup configuration
init_sounds = func
{
}
