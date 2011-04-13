#
# Author: Slavutinsky Victor
#

#--------------------------------------------------------------------
# Chronometer

# helper 
stop_chron = func {
}

chron = func 
	{
		# check power
		var in_service = getprop("fdm/jsbsim/systems/mainpanel/serviceable" );
		if (in_service == nil)
		{
			stop_chron();
			return ( settimer(chron, 0.1) ); 
		}
		if( in_service != 1 )
		{
			stop_chron();
		 	return ( settimer(chron, 0.1) ); 
		}		

		# inflight time
		var time = getprop("sim/time/utc/day-seconds");
		var prev_time = getprop("fdm/jsbsim/systems/mainpanel/prev-time");
		var inf_sec = getprop("fdm/jsbsim/systems/mainpanel/clock-inflight-sec");
		if ((time == nil) or (prev_time == nil) or (inf_sec == nil))
		{
			stop_chron();
			return ( settimer(chron, 0.1) ); 
		}
		var time_step=0;
		if (prev_time>0)
		{
			if (prev_time>time)
			{
				time_step=time;
			}
			else
			{
				time_step=time-prev_time;
			}
		}
		inf_sec=inf_sec+time_step;
		if (inf_sec<0)
		{
			inf_sec=60*60*24*10+inf_sec;
		}
		if (inf_sec>(60*60*24*10))
		{
			inf_sec=inf_sec-60*60*24*10;
		}
		var inf_days=int(inf_sec/(60*60*24));
		setprop("fdm/jsbsim/systems/mainpanel/clock-inflight-sec", inf_sec);
		setprop("fdm/jsbsim/systems/mainpanel/clock-inflight-days", inf_days);

		# daytime time
		var daytime_sec = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-sec");
		if (daytime_sec == nil)
		{
			stop_chron();
			return ( settimer(chron, 0.1) ); 
		}
		daytime_sec=daytime_sec+time_step;
		if (daytime_sec<0)
		{
			daytime_sec=6*90*60+daytime_sec;
		}
		if (daytime_sec>(6*90*60))
		{
			daytime_sec=daytime_sec-6*90*60;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-daytime-sec", daytime_sec);

		setprop("fdm/jsbsim/systems/mainpanel/prev-time", time);

		settimer(chron, 0.1);
	}

# set startup configuration
init_chron = func
{
}

# Change main clock offset
clock_main_down = func
{
	offset_sec = getprop("instrumentation/clock/offset-sec");
	vernier_angle = getprop("fdm/jsbsim/systems/mainpanel/clock-main-vernier-angle");
	vernier_switch = getprop("fdm/jsbsim/systems/mainpanel/clock-main-vernier-switch");
	if ((offset_sec != nil) and (vernier_angle != nil) and (vernier_switch != nil))
	{
		vernier_angle=vernier_angle-5;
		if (vernier_angle<0)
		{
			vernier_angle=vernier_angle+360;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-main-vernier-angle", vernier_angle);
		if (vernier_switch==0)
		{
			offset_sec=offset_sec-1;
		}
		else
		{
			offset_sec=offset_sec-60;
		}
		setprop("instrumentation/clock/offset-sec", offset_sec);
	}
}

clock_main_up = func
{	offset_sec = getprop("instrumentation/clock/offset-sec");
	vernier_angle = getprop("fdm/jsbsim/systems/mainpanel/clock-main-vernier-angle");
	vernier_switch = getprop("fdm/jsbsim/systems/mainpanel/clock-main-vernier-switch");
	if ((offset_sec != nil) and (vernier_angle != nil) and (vernier_switch != nil))
	{
		vernier_angle=vernier_angle+5;
		if (vernier_angle<360)
		{
			vernier_angle=vernier_angle-360;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-main-vernier-angle", vernier_angle);
		if (vernier_switch==0)
		{
			offset_sec=offset_sec+1;
		}
		else
		{
			offset_sec=offset_sec+60;
		}
		setprop("instrumentation/clock/offset-sec", offset_sec);
	}
}

# Change inflight clock offset
clock_inflight_down = func
{
	sec = getprop("fdm/jsbsim/systems/mainpanel/clock-inflight-sec");
	vernier_angle = getprop("fdm/jsbsim/systems/mainpanel/clock-inflight-vernier-angle");
	vernier_switch = getprop("fdm/jsbsim/systems/mainpanel/clock-inflight-vernier-switch");
	if ((sec != nil) and (vernier_angle != nil) and (vernier_switch != nil))
	{
		vernier_angle=vernier_angle-5;
		if (vernier_angle<0)
		{
			vernier_angle=vernier_angle+360;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-inflight-vernier-angle", vernier_angle);
		if (vernier_switch==0)
		{
			sec=sec-60;
		}
		else
		{
			sec=sec-3600;
		}
		if (sec<0)
		{
			sec=sec+60*60*24*10;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-inflight-sec", sec);
	}
}

clock_inflight_up = func
{
	sec = getprop("fdm/jsbsim/systems/mainpanel/clock-inflight-sec");
	vernier_angle = getprop("fdm/jsbsim/systems/mainpanel/clock-inflight-vernier-angle");
	vernier_switch = getprop("fdm/jsbsim/systems/mainpanel/clock-inflight-vernier-switch");
	if ((sec != nil) and (vernier_angle != nil) and (vernier_switch != nil))
	{
		vernier_angle=vernier_angle+5;
		if (vernier_angle>360)
		{
			vernier_angle=vernier_angle-360;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-inflight-vernier-angle", vernier_angle);
		if (vernier_switch==0)
		{
			sec=sec+60;
		}
		else
		{
			sec=sec+3600;
		}
		if (sec>60*60*24*10)
		{
			sec=sec-60*60*24*10;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-inflight-sec", sec);
	}
}

# Change daytime clock offset
clock_daytime_down = func
{
	sec = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-sec");
	disk_sec = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-disk-sec");
	vernier_angle = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-vernier-angle");
	vernier_switch = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-vernier-switch");
	if ((sec != nil) and (disk_sec != nil) and (vernier_angle != nil) and (vernier_switch != nil))
	{
		vernier_angle=vernier_angle-5;
		if (vernier_angle<0)
		{
			vernier_angle=vernier_angle+360;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-daytime-vernier-angle", vernier_angle);
		if (vernier_switch==0)
		{
			sec=sec-60;
		}
		else
		{
			sec=sec-60;
			disk_sec=disk_sec-60;
		}
		if (sec<0)
		{
			sec=sec+6*90*60;
		}
		if (disk_sec<0)
		{
			disk_sec=disk_sec+6*90*60;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-daytime-sec", sec);
		setprop("fdm/jsbsim/systems/mainpanel/clock-daytime-disk-sec", disk_sec);
	}
}

clock_daytime_up = func
{
	sec = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-sec");
	disk_sec = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-disk-sec");
	vernier_angle = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-vernier-angle");
	vernier_switch = getprop("fdm/jsbsim/systems/mainpanel/clock-daytime-vernier-switch");
	if ((sec != nil) and (disk_sec != nil) and (vernier_angle != nil) and (vernier_switch != nil))
	{
		vernier_angle=vernier_angle+5;
		if (vernier_angle>360)
		{
			vernier_angle=vernier_angle-360;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-daytime-vernier-angle", vernier_angle);
		if (vernier_switch==0)
		{
			sec=sec+60;
		}
		else
		{
			sec=sec+60;
			disk_sec=disk_sec+60;
		}
		if (sec>6*90*60)
		{
			sec=sec-6*90*60;
		}
		if (disk_sec>6*90*60)
		{
			disk_sec=disk_sec-6*90*60;
		}
		setprop("fdm/jsbsim/systems/mainpanel/clock-daytime-sec", sec);
		setprop("fdm/jsbsim/systems/mainpanel/clock-daytime-disk-sec", disk_sec);
	}
}

#--------------------------------------------------------------------
# Main panel

# start main panel process first time
start_mainpanel= func
{
	init_chron();
	chron ();
}
