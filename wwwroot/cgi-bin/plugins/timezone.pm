#!/usr/bin/perl
#-----------------------------------------------------------------------------
# TimeZone AWStats plugin
# Allow AWStats to correct a bad timezone for user of IIS that use strange
# log format.
#-----------------------------------------------------------------------------
# Perl Required Modules: None
#-----------------------------------------------------------------------------
# $Revision: 1.1 $ - $Author: eldy $ - $Date: 2002-07-23 00:29:43 $


# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!! This plugin reduces AWStats speed by a factor 2 !!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$Plugin_timezone=1;



#-----------------------------------------------------------------------------
# PLUGIN GLOBAL VARIABLES
#-----------------------------------------------------------------------------
$Plugin_timezoneSeconds=0;
#...


#-----------------------------------------------------------------------------
# PLUGIN Init_pluginname FUNCTION
#-----------------------------------------------------------------------------
sub Init_timezone {
	my $TZ=shift;
	if (! $TZ) { $Plugin_timezone=0; }	# We do not need this plugin if TZ=0
	$Plugin_timezoneSeconds=($TZ*3600);
	return 1;
}


#-----------------------------------------------------------------------------
# PLUGIN ShowField_pluginname FUNCTION
#-----------------------------------------------------------------------------
#...



#-----------------------------------------------------------------------------
# PLUGIN Filter_pluginname FUNCTION
#-----------------------------------------------------------------------------
#...



1;	# Do not remove this line
