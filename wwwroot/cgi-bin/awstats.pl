#!/usr/bin/perl
# With some other Unix Os, first line may be
#!/usr/local/bin/perl
# With Apache for Windows and ActiverPerl, first line may be
#!c:/program files/activeperl/bin/perl
#-Description-------------------------------------------
# Free realtime web server logfile analyzer to show advanced web statistics.
# Works from command line or as a CGI. You must use this script as often as
# necessary from your scheduler to update your statistics.
# See README.TXT file for setup and benchmark informations.
# See COPYING.TXT file about AWStats GNU General Public License.
#-------------------------------------------------------
# ALGORITHM SUMMARY
# Read config file
# Init variables
# If 'update'
#   Get last history file name
#   Read this last history file (LastLine, data arrays, ...)
#   Loop on each new line in log file
#     If line older than LastLine, skip
#     If new line
#        If other month/year, save data arrays, reset them
#        Analyse record and complete data arrays
#     End of new line
#   End of loop
# End of 'update'
# Save data arrays
# Reset data arrays if not required month/year
# Loop for each month of current year
#   If required month, read 1st and 2nd part of history file for this month
#   If not required month, read 1st part of history file for this month
# End of loop
# If 'output'
#   Show data arrays in HTML page
# End of 'output'
#-------------------------------------------------------
#use diagnostics;
#use strict;


#-------------------------------------------------------
# Defines
#-------------------------------------------------------

# ---------- Init variables (Variable $TmpHashxxx are not initialized) --------
($AddOn, $ArchiveFileName, $ArchiveLogRecords, $BarHeight, $BarWidth,
$DIR, $DNSLookup, $Debug, $DefaultFile,
$DirCgi, $DirData, $DirIcons, $DirLang,
$DetailedReportsOnNewWindows, $Expires, $Extension, $FileConfig, $FileSuffix, $FirstDayOfWeek,
$FirstTime, $HTMLHeadSection, $HTMLEndSection, $Host, $HostAlias, $LastTime, $LastUpdate,
$LogFile, $LogFormat, $LogFormatString, $Logo, $LogoLink,
$MaxNbOfDays, $MaxNbOfHostsShown, $MaxNbOfKeywordsShown, $MaxNbOfLoginShown,
$MaxNbOfPageShown, $MaxNbOfRefererShown, $MaxNbOfRobotShown,
$MinHitFile, $MinHitHost, $MinHitKeyword, $MinHitLogin, $MinHitRefer, $MinHitRobot,
$MonthRequired, $NbOfLinesForCorruptedLog,
$HTMLOutput, $PROG, $PageCode,
$PurgeLogFile, $QueryString, $RatioBytes, $RatioHits, $RatioHosts, $RatioPages,
$ShowHeader, $ShowMenu, $ShowMonthDayStats,
$ShowDaysOfWeekStats, $ShowHoursStats, 
$ShowDomainsStats, $ShowHostsStats, $ShowAuthenticatedUsers, $ShowRobotsStats, 
$ShowPagesStats, $ShowFileTypesStats, $ShowFileSizesStats,
$ShowBrowsersStats, $ShowOSStats, $ShowOriginStats,
$ShowKeyphrasesStats, $ShowKeywordsStats,
$ShowCompressionStats, $ShowHTTPErrorsStats,
$ShowFlagLinks, $ShowLinksOnURL, $ShowLinksOnUrl, $ShowSteps,
$SiteConfig, $SiteDomain, $SiteToAnalyze, $SiteToAnalyzeWithoutwww,
$TotalBytes, $TotalDifferentPages, $TotalErrors, $TotalHits,
$TotalHostsKnown, $TotalHostsUnKnown, $TotalPages, $TotalUnique, $TotalVisits,
$URLFilter, $URLWithQuery, $UserAgent, $YearRequired, 
$color_Background, $color_TableBG, $color_TableBGRowTitle,
$color_TableBGTitle, $color_TableBorder, $color_TableRowTitle, $color_TableTitle,
$color_h, $color_k, $color_link, $color_p, $color_s, $color_v, $color_w, $color_weekend,
$found, $internal_link) = ();
$WarningMessages= 1;
# ---------- Init arrays --------
@HostAliases = @Message = @OnlyFiles = @SkipDNSLookupFor = @SkipFiles = @SkipHosts = @DOWIndex = ();
# ---------- Init hash arrays --------
%DayBytes = %DayHits = %DayPages = %DayUnique = %DayVisits =
%FirstTime = %HistoryFileAlreadyRead = %LastTime = %LastUpdate =
%MonthBytes = %MonthHits = %MonthHostsKnown = %MonthHostsUnknown = %MonthPages = %MonthUnique = %MonthVisits =
%monthlib = %monthnum = ();

$VERSION="3.2 (build 17)";
$Lang="en";

# Default value
$MAXROWS       = 200000;	# Max number of rows for not limited HTML arrays
$SortDir       = -1;		# -1 = Sort order from most to less, 1 = reverse order (Default = -1)
$VisitTimeOut  = 10000;		# Laps of time to consider a page load as a new visit. 10000 = one hour (Default = 10000)
$FullHostName  = 1;			# 1 = Use name.domain.zone to refer host clients, 0 = all hosts in same domain.zone are one host (Default = 1, 0 never tested)
$MaxLengthOfURL= 72;		# Maximum length of URL shown on stats page. This affects only URL visible text, link still work (Default = 72)
$MaxNbOfDays   = 31;
$NbOfLinesForBenchmark=5000;
$ShowBackLink  = 1;
$Sort          = "";
$CENTER        = "";
$WIDTH         = "600";
# Images for graphics
$BarImageVertical_v   = "barrevv.png";
#$BarImageHorizontal_v = "barrehv.png";
$BarImageVertical_u   = "barrevu.png";
#$BarImageHorizontal_u = "barrehu.png";
$BarImageVertical_p   = "barrevp.png";
$BarImageHorizontal_p = "barrehp.png";
$BarImageVertical_h   = "barrevh.png";
$BarImageHorizontal_h = "barrehh.png";
$BarImageVertical_k   = "barrevk.png";
$BarImageHorizontal_k = "barrehk.png";

$AddOn=0;
#require "${DIR}addon.pl"; $AddOn=1; 		# Keep this line commented in standard version

# URL with such end signature are kind of URL we only need to count as hits
@NotPageList= (
			"\\.gif","\\.jpg","\\.jpeg","\\.png","\\.bmp",
#			"\\.zip","\\.arj","\\.gz","\\.z",
#			"\\.pdf","\\.doc","\\.ppt","\\.rtf","\\.txt",
#			"\\.mp3","\\.wma"
			);

# Those addresses are shown with those lib (First column is full exact relative URL, second column is text to show instead of URL)
%Aliases    = (
			"/",                                    "<b>HOME PAGE</b>",
			"/cgi-bin/awstats.pl",					"<b>AWStats stats page</b>",
			"/cgi-bin/awstats/awstats.pl",			"<b>AWStats stats page</b>",
			# Following the same example, you can put here HTML text you want to see in links instead of URL text.
			"/YourRelativeUrl",						"<b>Your HTML text</b>",
			"/YourRelativeUrl",						"<b>Your HTML text</b>"
			);

# These table is used to make fast reverse DNS lookup for particular IP adresses. You can add your own IP adresses resolutions.
%MyDNSTable = (
"256.256.256.1", "myworkstation1",
"256.256.256.2", "myworkstation2"
);

# HTTP codes with tooltip
%httpcode = (
"201", "Partial Content", "202", "Request recorded, will be executed later", "204", "Request executed", "206", "Partial Content",
"301", "Moved Permanently", "302", "Found",
"400", "Bad Request", "401", "Unauthorized", "403", "Forbidden", "404", "Not Found", "408", "Request Timeout",
"500", "Internal Error", "501", "Not implemented", "502", "Received bad response from real server", "503", "Server busy", "504", "Gateway Time-Out", "505", "HTTP version not supported",
"200", "OK", "304", "Not Modified"	# 200 and 304 are not errors
);



#-------------------------------------------------------
# Functions
#-------------------------------------------------------

sub html_head {
	if ($HTMLOutput) {
		# Write head section
		my $sitetoanalyze=$SiteToAnalyze; $sitetoanalyze =~ s/\\\./\./g;
	  	print "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n\n";
	    print "<html>\n";
		print "<head>\n";
		if ($PageCode) { print "<META HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=$PageCode\"\n"; }		# If not defined, iso-8859-1 is used in major countries
		if ($Expires)  {
			my $date=localtime(time()+$Expires);
			print "<META HTTP-EQUIV=\"expires\" CONTENT=\"$date\">\n";
		} 
		print "<meta http-equiv=\"description\" content=\"$PROG - Advanced Web Statistics for $sitetoanalyze\">\n";
		print "<meta http-equiv=\"keywords\" content=\"$sitetoanalyze, free, advanced, realtime, web, server, logfile, log, analyzer, analysis, statistics, stats, perl, analyse, performance, hits, visits\">\n";
		print "<meta name=\"robots\" content=\"index,follow\">\n";
		print "<title>$Message[7] $sitetoanalyze</title>\n";
		# Do not use " for number in a style section
		print <<EOF;
<STYLE TYPE="text/css">
<!--
BODY { font: 12px arial, verdana, helvetica, sans-serif; background-color: #$color_Background; }
TH { font: 12px arial, verdana, helvetica, sans-serif; text-align:center; color: #$color_titletext; }
TH.AWL { font-size: 14px; font-weight: bold; }
TD { font: 12px arial, verdana, helvetica, sans-serif; text-align:center; color: #$color_text; }
.AWL { font: 12px arial, verdana, helvetica, sans-serif; text-align:left; color: #$color_text; }
A { font: normal 12px arial, verdana, helvetica, sans-serif; }
A:link    { color: #$color_link; text-decoration: none; }
A:visited { color: #$color_link; text-decoration: none; }
A:hover   { color: #$color_hover; text-decoration: underline; }
DIV { font: 12px arial,verdana,helvetica; text-align:justify; }
.TABLEBORDER { background-color: #$color_TableBorder; }
.TABLEFRAME { background-color: #$color_TableBG; padding: 2px 2px  2px 2px; margin-top: 0 }
.TABLEDATA { background-color: #$color_Background; }
.TABLETITLEFULL  { font: bold 14px verdana, arial, helvetica, sans-serif; background-color: #$color_TableBGTitle; text-align: center; width: 66%; margin-bottom: 0; padding: 2px; }
.TABLETITLEBLANK { font: bold 14px verdana, arial, helvetica, sans-serif; background-color: #$color_Background; }
.CTooltip { position:absolute; top:0px; left:0px; z-index:2; width:280; visibility:hidden; font: 8pt MS Comic Sans,arial,sans-serif; background-color: #FFFFE6; padding: 8px; border: 1px solid black; }

.tablecontainer  { width: 100% }
\@media projection {
.tablecontainer { page-break-before: always; }
}

//-->
</STYLE>
EOF
		print "</head>\n\n";
		print "<body>\n";
		# Write logo, flags and product name
		if ($ShowHeader) {
			print "<table WIDTH=$WIDTH>\n";
			print "<tr valign=middle><td class=AWL width=150 style=\"font: 18px arial,verdana,helvetica; font-weight: bold\">AWStats\n";
			Show_Flag_Links($Lang);
			print "</td>\n";
			if ($LogoLink =~ "http://awstats.sourceforge.net") {
				print "<td class=AWL width=450><a href=\"$LogoLink\" target=\"_newawstats\"><img src=\"$DirIcons/other/$Logo\" border=0 alt=\"$PROG Official Web Site\" title=\"$PROG Official Web Site\"></a></td></tr>\n";
			}
			else {
				print "<td class=AWL width=450><a href=\"$LogoLink\" target=\"_newawstats\"><img src=\"$DirIcons/other/$Logo\" border=0></a></td></tr>\n";
			}
			#print "<b><font face=\"verdana\" size=1><a href=\"$HomeURL\">HomePage</a> &#149\; <a href=\"javascript:history.back()\">Back</a></font></b><br>\n";
			print "<tr><td class=AWL colspan=2>$Message[54]</td></tr>\n";
			print "</table>\n";
			#print "<hr>\n";
		}
	}
}


sub html_end {
	if ($HTMLOutput) {
		print "$CENTER<br><br><br>\n";
		print "<FONT COLOR=\"#$color_text\"><b>Advanced Web Statistics $VERSION</b> - <a href=\"http://awstats.sourceforge.net\" target=\"_newawstats\">Created by $PROG</a><br>\n";
		print "<br>\n";
		print "$HTMLEndSection</font>\n";
		print "</body>\n";
		print "</html>\n";
	}
}

sub tab_head {
	my $title=shift;
	my $tooltip=shift;
	print "<div class=\"tablecontainer\">\n";
	print "<TABLE CLASS=\"TABLEFRAME\" BORDER=0 CELLPADDING=2 CELLSPACING=0 WIDTH=\"100%\">\n";
	if ($tooltip) {
		print "<TR><TD class=\"TABLETITLEFULL\" onmouseover=\"ShowTooltip($tooltip);\" onmouseout=\"HideTooltip($tooltip);\">$title </TD>";
	}
	else {
		print "<TR><TD class=\"TABLETITLEFULL\">$title </TD>";
	}
	print "<TD class=\"TABLETITLEBLANK\"> &nbsp; </TD></TR>\n";
	print "<TR><TD colspan=2><TABLE CLASS=\"TABLEDATA\" BORDER=1 BORDERCOLOR=\"#$color_TableBorder\" CELLPADDING=2 CELLSPACING=0 WIDTH=\"100%\">";
}

sub tab_end {
	print "\n</TABLE></TD></TR></TABLE>";
	print "</div>\n\n";
}

sub UnescapeURLParam {
	$_[0] =~ tr/\+/ /s;
	$_[0] =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;		# Decode encoded URL
	$_[0] =~ tr/\'\(\)\"/    /s;									# "&" and "=" must not be in this list
}

sub error {
	if ($_[0] eq "Format error") {
		# Files seems to have bad format
		print "AWStats did not found any valid log lines that match your <b>LogFormat</b> parameter, in the ${NbOfLinesForCorruptedLog}th first non commented lines read of your log.<br>\n";
		print "<font color=#880000>Your log file <b>$_[2]</b> must have a bad format or <b>LogFormat</b> parameter setup does not match this format.</font><br><br>\n";
		print "Your <b>LogFormat</b> parameter is <b>$LogFormat</b>, this means each line in your log file need to have ";
		if ($LogFormat == 1) {
			print "<b>\"combined log format\"</b> like this:<br>\n";
			print "<font color=#888888><i>111.22.33.44 - - [10/Jan/2001:02:14:14 +0200] \"GET / HTTP/1.1\" 200 1234 \"http://www.fromserver.com/from.htm\" \"Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)\"</i></font><br>\n";
		}
		if ($LogFormat == 2) {
			print "<b>\"MSIE Extended W3C log format\"</b> like this:<br>\n";
			print "<font color=#888888><i>date time c-ip c-username cs-method cs-uri-sterm sc-status sc-bytes cs-version cs(User-Agent) cs(Referer)</i></font><br>\n";
		}
		if ($LogFormat == 3) {
			print "<b>\"WebStar native log format\"</b><br>\n";
		}
		if ($LogFormat == 4) {
			print "<b>\"common log format\"</b> like this:<br>\n";
			print "<font color=#888888><i>111.22.33.44 - - [10/Jan/2001:02:14:14 +0200] \"GET / HTTP/1.1\" 200 1234</i></font><br>\n";
		}
		if ($LogFormat != 1 && $LogFormat != 2 && $LogFormat != 3 && $LogFormat != 4) {
			print "the following personalised log format:<br>\n";
			print "<font color=#888888><i>$LogFormat</i></font><br>\n";
		}
		print "<br>";
		print "And this is a sample of what AWStats found in your log (the record number $NbOfLinesForCorruptedLog in your log):<br>\n";
		print ($ENV{"GATEWAY_INTERFACE"} ne ""?"<font color=#888888><i>":"");
		print "$_[1]";
		print ($ENV{"GATEWAY_INTERFACE"} ne ""?"</i></font><br><br>":"");
		print "\n";
		print "Note: If your $NbOfLinesForCorruptedLog first lines in your log files are wrong because they are result of a worm virus attack,\n";
		print "you can increase the NbOfLinesForCorruptedLog parameter in config file.\n";
		print "\n";
	}			
   	if ($_[0] ne "Format error" && $_[0] ne "") {
   		print ($ENV{"GATEWAY_INTERFACE"} ne ""?"<br><font color=#880000>":"");
   		print "$_[0]";
   		print ($ENV{"GATEWAY_INTERFACE"} ne ""?"</font><br>":"");
   		print "\n";
   	}
   	if ($ENV{"GATEWAY_INTERFACE"} ne "") { print "<br><b>\n"; }
	if ($_[0] ne "") { print "Setup ($FileConfig file, web server or logfile permissions) may be wrong.\n"; }
	if ($ENV{"GATEWAY_INTERFACE"} ne "") { print "</b><br>\n"; }
	print "See README.TXT for informations on how to setup $PROG.\n";
   	if ($ENV{"GATEWAY_INTERFACE"} ne "") { print "</BODY>\n</HTML>\n"; }
    die;
}

sub warning {
	if ($WarningMessages == 1) {
		my $messagestring=$_[0];
    	if ($ENV{"GATEWAY_INTERFACE"} ne "") {
    		$messagestring =~ s/\n/\<br\>/g;
    		print "$messagestring<br>\n";
    	}
    	else {
	    	print "$messagestring\n";
    	}
	}
}

sub debug {
	my $level = $_[1] || 1;
	if ($Debug >= $level) { 
		my $debugstring = $_[0];
		if ($ENV{"GATEWAY_INTERFACE"} ne "") { $debugstring =~ s/^ /&nbsp&nbsp /; $debugstring .= "<br>"; }
		print "DEBUG $level - ".time." : $debugstring\n";
	}
}

sub SkipHost {
	foreach my $match (@SkipHosts) { if ($_[0] =~ /$match/i) { return 1; } }
	0; # Not in @SkipHosts
}

sub SkipFile {
	foreach my $match (@SkipFiles) { if ($_[0] =~ /$match/i) { return 1; } }
	0; # Not in @SkipFiles
}

sub OnlyFile {
	if ($OnlyFiles[0] eq "") { return 1; }
	foreach my $match (@OnlyFiles) { if ($_[0] =~ /$match/i) { return 1; } }
	0; # Not in @OnlyFiles
}

sub SkipDNSLookup {
	foreach my $match (@SkipDNSLookupFor) { if ($_[0] =~ /$match/i) { return 1; } }
	0; # Not in @SkipDNSLookupFor
}

sub DayOfWeek {
	my ($day, $month, $year) = @_;
	if ($month < 3) {  $month += 10;  $year--; } 
	else { $month -= 2; }
	my $cent = sprintf("%1i",($year/100));
	my $y = ($year % 100);
	my $dw = (sprintf("%1i",(2.6*$month)-0.2) + $day + $y + sprintf("%1i",($y/4)) + sprintf("%1i",($cent/4)) - (2*$cent)) % 7;
	$dw += 7 if ($dw<0);
	&debug("day of week for $day $month $year= $dw",3);
	return $dw;
}

sub DateIsValid {
	my ($day, $month, $year) = @_;
	if ($day < 1) { return 0; }
	if ($month==1 || $month==3 || $month==5 || $month==7 || $month==8 || $month==10 || $month==12) {
		if ($day > 31) { return 0; }		
	}
	if ($month==4 || $month==6 || $month==9 || $month==11) {
		if ($day > 30) { return 0; }
	}
	if ($month==2) {
		if ($day > 28) { return 0; }		
	}
	return 1;
}



#------------------------------------------------------------------------------
# Function:     read config file
# Input:		$DIR $PROG $SiteConfig
# Output:		Global variables
#------------------------------------------------------------------------------
sub Read_Config_File {
	$FileConfig="";
	if (! $SiteConfig) { $SiteConfig=$ENV{"SERVER_NAME"}; }		# For backward compatibility
	foreach my $dir ("$DIR","/etc/opt/awstats","/etc/awstats","/etc") {
		my $searchdir=$dir;
		if (($searchdir ne "") && (!($searchdir =~ /\/$/)) && (!($searchdir =~ /\\$/)) ) { $searchdir .= "/"; }
		if ($FileConfig eq "") { if (open(CONFIG,"$searchdir$PROG.$SiteConfig.conf")) { $FileConfig="$searchdir$PROG.$SiteConfig.conf"; $FileSuffix=".$SiteConfig"; } }
		if ($FileConfig eq "") { if (open(CONFIG,"$searchdir$PROG.conf"))  { $FileConfig="$searchdir$PROG.conf"; $FileSuffix=""; } }
	}
	if ($FileConfig eq "") { error("Error: Couldn't open config file \"$PROG.$SiteConfig.conf\" nor \"$PROG.conf\" : $!"); }
	&debug("Call to Read_Config_File [FileConfig=\"$FileConfig\"]");
	while (<CONFIG>) {
		chomp $_; s/\r//;
		$_ =~ s/#.*//;								# Remove comments
		$_ =~ tr/\t /  /s;							# Change all blanks into " "
		$_ =~ s/=/�/;								# Change first "=" into "�" to split
		my @felter=split(/�/,$_);						
		my $param=$felter[0];
		my $value=$felter[1];
		$value =~ s/^ *//; $value =~ s/ *$//;
		$value =~ s/^\"//; $value =~ s/\"$//;
		# Read main section
		if ($param =~ /^LogFile/) {
			$LogFile=$value;
			# Replace %YYYY %YY %MM %DD %HH with current value
			$LogFile =~ s/%YYYY/$nowyear/g;
			$LogFile =~ s/%YY/$nowsmallyear/g;
			$LogFile =~ s/%MM/$nowmonth/g;
			$LogFile =~ s/%DD/$nowday/g;
			$LogFile =~ s/%HH/$nowhour/g;
			next;
			}
		if ($param =~ /^LogFormat/)            { $LogFormat=$value; next; }
		if ($param =~ /^AllowToUpdateStatsFromBrowser/)	{ $AllowToUpdateStatsFromBrowser=$value; next; }
		if ($param =~ /^HostAliases/) {
			my @felter=split(/\s+/,$value);
			$i=0; foreach $elem (@felter)      { $HostAliases[$i]=$elem; $i++; }
			next;
			}
		if ($param =~ /^DirData/)               { $DirData=$value; next; }
		if ($param =~ /^DirCgi/)                { $DirCgi=$value; next; }
		if ($param =~ /^DirIcons/)              { $DirIcons=$value; next; }
		if ($param =~ /^DNSLookup/)             { $DNSLookup=$value; next; }
		if ($param =~ /^PurgeLogFile/)          { $PurgeLogFile=$value; next; }
		if ($param =~ /^ArchiveLogRecords/)     { $ArchiveLogRecords=$value; next; }
		# Read optional section
		if ($param =~ /^SiteDomain/)			{ $SiteDomain=$value; next; }
		if ($param =~ /^Lang/)                  { $Lang=$value; next; }
		if ($param =~ /^DirLang/)               { $DirLang=$value; next; }
		if ($param =~ /^DefaultFile/)           { $DefaultFile=$value; next; }
		if ($param =~ /^SkipHosts/) {
			my @felter=split(/\s+/,$value);
			$i=0; foreach $elem (@felter)       { $SkipHosts[$i]=$elem; $i++; }
			next;
			}
		if ($param =~ /^SkipDNSLookupFor/) {
			my @felter=split(/\s+/,$value);
			$i=0; foreach $elem (@felter)       { $SkipDNSLookupFor[$i]=$elem; $i++; }
			next;
			}
		if ($param =~ /^SkipFiles/) {
			my @felter=split(/\s+/,$value);
			$i=0; foreach $elem (@felter)       { $SkipFiles[$i]=$elem; $i++; }
			next;
			}
		if ($param =~ /^OnlyFiles/) {
			my @felter=split(/\s+/,$value);
			$i=0; foreach $elem (@felter)       { $OnlyFiles[$i]=$elem; $i++; }
			next;
			}
		if ($param =~ /^URLWithQuery/)          { $URLWithQuery=$value; next; }
		if ($param =~ /^WarningMessages/)       { $WarningMessages=$value; next; }
		if ($param =~ /^NbOfLinesForCorruptedLog/) { $NbOfLinesForCorruptedLog=$value; next; }
		if ($param =~ /^FirstDayOfWeek/)       	{ $FirstDayOfWeek=$value; next; }
		if ($param =~ /^MaxNbOfDomain/)         { $MaxNbOfDomain=$value; next; }
		if ($param =~ /^MaxNbOfHostsShown/)     { $MaxNbOfHostsShown=$value; next; }
		if ($param =~ /^MinHitHost/)            { $MinHitHost=$value; next; }
		if ($param =~ /^MaxNbOfRobotShown/)     { $MaxNbOfRobotShown=$value; next; }
		if ($param =~ /^MinHitRobot/)           { $MinHitRobot=$value; next; }
		if ($param =~ /^MaxNbOfLoginShown/)     { $MaxNbOfLoginShown=$value; next; }
		if ($param =~ /^MinHitLogin/)           { $MinHitLogin=$value; next; }
		if ($param =~ /^MaxNbOfPageShown/)      { $MaxNbOfPageShown=$value; next; }
		if ($param =~ /^MinHitFile/)            { $MinHitFile=$value; next; }
		if ($param =~ /^MaxNbOfRefererShown/)   { $MaxNbOfRefererShown=$value; next; }
		if ($param =~ /^MinHitRefer/)           { $MinHitRefer=$value; next; }
		if ($param =~ /^MaxNbOfKeywordsShown/)  { $MaxNbOfKeywordsShown=$value; next; }
		if ($param =~ /^MinHitKeyword/)         { $MinHitKeyword=$value; next; }
		if ($param =~ /^SplitSearchString/)     { $SplitSearchString=$value; next; }
		if ($param =~ /^Expires/)               { $Expires=$value; next; }
		if ($param =~ /^ShowHeader/)             { $ShowHeader=$value; next; }
		if ($param =~ /^ShowMenu/)               { $ShowMenu=$value; next; }
		if ($param =~ /^ShowMonthDayStats/)      { $ShowMonthDayStats=$value; next; }
		if ($param =~ /^ShowDaysOfWeekStats/)    { $ShowDaysOfWeekStats=$value; next; }
		if ($param =~ /^ShowHoursStats/)         { $ShowHoursStats=$value; next; }
		if ($param =~ /^ShowDomainsStats/)       { $ShowDomainsStats=$value; next; }
		if ($param =~ /^ShowHostsStats/)         { $ShowHostsStats=$value; next; }
		if ($param =~ /^ShowAuthenticatedUsers/) { $ShowAuthenticatedUsers=$value; next; }
		if ($param =~ /^ShowRobotsStats/)        { $ShowRobotsStats=$value; next; }
		if ($param =~ /^ShowPagesStats/)         { $ShowPagesStats=$value; next; }
		if ($param =~ /^ShowFileTypesStats/)     { $ShowFileTypesStats=$value; next; }
		if ($param =~ /^ShowFileSizesStats/)     { $ShowFileSizesStats=$value; next; }
		if ($param =~ /^ShowBrowsersStats/)      { $ShowBrowsersStats=$value; next; }
		if ($param =~ /^ShowOSStats/)            { $ShowOSStats=$value; next; }
		if ($param =~ /^ShowOriginStats/)        { $ShowOriginStats=$value; next; }
		if ($param =~ /^ShowKeyphrasesStats/)    { $ShowKeyphrasesStats=$value; next; }
		if ($param =~ /^ShowKeywordsStats/)      { $ShowKeywordsStats=$value; next; }
		if ($param =~ /^ShowCompressionStats/)   { $ShowCompressionStats=$value; next; }
		if ($param =~ /^ShowHTTPErrorsStats/)    { $ShowHTTPErrorsStats=$value; next; }
		if ($param =~ /^ShowFlagLinks/)         { $ShowFlagLinks=$value; next; }
		if ($param =~ /^ShowLinksOnUrl/)        { $ShowLinksOnUrl=$value; next; }
		if ($param =~ /^DetailedReportsOnNewWindows/) { $DetailedReportsOnNewWindows=$value; next; }
		if ($param =~ /^HTMLHeadSection/)       { $HTMLHeadSection=$value; next; }
		if ($param =~ /^HTMLEndSection/)        { $HTMLEndSection=$value; next; }
		if ($param =~ /^BarWidth/)              { $BarWidth=$value; next; }
		if ($param =~ /^BarHeight/)             { $BarHeight=$value; next; }
		if ($param =~ /^Logo$/)                 { $Logo=$value; next; }
		if ($param =~ /^LogoLink/)              { $LogoLink=$value; next; }
		if ($param =~ /^color_Background/)      { $color_Background=$value; next; }
		if ($param =~ /^color_TableTitle/)      { $color_TableTitle=$value; next; }
		if ($param =~ /^color_TableBGTitle/)    { $color_TableBGTitle=$value; next; }
		if ($param =~ /^color_TableRowTitle/)   { $color_TableRowTitle=$value; next; }
		if ($param =~ /^color_TableBGRowTitle/) { $color_TableBGRowTitle=$value; next; }
		if ($param =~ /^color_TableBG/)         { $color_TableBG=$value; next; }
		if ($param =~ /^color_TableBorder/)     { $color_TableBorder=$value; next; }
		if ($param =~ /^color_link/)            { $color_link=$value; next; }
		if ($param =~ /^color_hover/)           { $color_hover=$value; next; }
		if ($param =~ /^color_text/)            { $color_text=$value; next; }
		if ($param =~ /^color_titletext/)       { $color_titletext=$value; next; }
		if ($param =~ /^color_weekend/)         { $color_weekend=$value; next; }
		if ($param =~ /^color_v/)               { $color_v=$value; next; }
		if ($param =~ /^color_w/)               { $color_w=$value; next; }
		if ($param =~ /^color_p/)               { $color_p=$value; next; }
		if ($param =~ /^color_h/)               { $color_h=$value; next; }
		if ($param =~ /^color_k/)               { $color_k=$value; next; }
		if ($param =~ /^color_s/)               { $color_s=$value; next; }
	}
	close CONFIG;
}


#------------------------------------------------------------------------------
# Function:     Get the reference databases
# Parameter:	None
# Input:		$DIR
# Output:		Arrays and Hash tables are defined in memory
#------------------------------------------------------------------------------
sub Read_Ref_Data {
	foreach my $file ("browsers.pl","domains.pl","operating_systems.pl","robots.pl","search_engines.pl") {
		my $FileRef="";
		foreach my $dir ("${DIR}db","./db") {
			my $searchdir=$dir;
			if (($searchdir ne "") && (!($searchdir =~ /\/$/)) && (!($searchdir =~ /\\$/)) ) { $searchdir .= "/"; }
			if ($FileRef eq "") {
				if (-s "${searchdir}${file}") {
					$FileRef="${searchdir}${file}";
					&debug("Call to Read_Ref_Data [FileRef=\"$FileRef\"]");
					require "$FileRef";
				}
			}
		}
		if ($FileRef eq "") {
			my $filetext=$file; $filetext =~ s/\.pl$//; $filetext =~ s/_/ /g;
			&warning("Warning: Can't read file \"$file\" ($filetext detection will not work correctly).\nCheck if file is in ${DIR}db directory and is readable.");
		}
	}
	# Check if OSHashID and OSArrayID are correct
	if (scalar keys %OSHashID != @OSArrayID) { error("Error: Not same number of records of OSHashID (".(scalar keys %OSHashID).") and/or OSArrayID (".(@OSArrayID).") in source file."); }
}

#------------------------------------------------------------------------------
# Function:     Get the messages for a specified language
# Parameter:	Language id
# Input:		$DIR
# Output:		$Message table is defined in memory
#------------------------------------------------------------------------------
sub Read_Language_Data {
	my $FileLang="";
	foreach my $dir ("$DirLang","${DIR}lang","./lang") {
		my $searchdir=$dir;
		if (($searchdir ne "") && (!($searchdir =~ /\/$/)) && (!($searchdir =~ /\\$/)) ) { $searchdir .= "/"; }
		if ($FileLang eq "") { if (open(LANG,"${searchdir}awstats-$_[0].txt")) { $FileLang="${searchdir}awstats-$_[0].txt"; } }
	}
	# If file not found, we try english
	foreach my $dir ("$DirLang","${DIR}lang","./lang") {
		my $searchdir=$dir;
		if (($searchdir ne "") && (!($searchdir =~ /\/$/)) && (!($searchdir =~ /\\$/)) ) { $searchdir .= "/"; }
		if ($FileLang eq "") { if (open(LANG,"${searchdir}awstats-en.txt")) { $FileLang="${searchdir}awstats-en.txt"; } }
	}
	&debug("Call to Read_Language_Data [FileLang=\"$FileLang\"]");
	if ($FileLang ne "") {
		$i = 0;
		while (<LANG>) {
			chomp $_; s/\r//;
			if ($_ =~ /^PageCode/i) {
				$_ =~ s/^PageCode=//i;
				$_ =~ s/#.*//;								# Remove comments
				$_ =~ tr/\t /  /s;							# Change all blanks into " "
				$_ =~ s/^ *//; $_ =~ s/ *$//;
				$_ =~ s/^\"//; $_ =~ s/\"$//;
				$PageCode = $_;
			}
			if ($_ =~ /^Message/i) {
				$_ =~ s/^Message\d+=//i;
				$_ =~ s/#.*//;								# Remove comments
				$_ =~ tr/\t /  /s;							# Change all blanks into " "
				$_ =~ s/^ *//; $_ =~ s/ *$//;
				$_ =~ s/^\"//; $_ =~ s/\"$//;
				$Message[$i] = $_;
				$i++;
			}
		}
	}
	else {
		&warning("Warning: Can't find language files for \"$_[0]\". English will be used.");
	}
	close(LANG);
}


#------------------------------------------------------------------------------
# Function:     Get the tooltip texts for a specified language
# Parameter:	Language id
# Input:		None
# Output:		Full tooltips text
#------------------------------------------------------------------------------
sub Read_Language_Tooltip {
	my $FileLang="";
	foreach my $dir ("$DirLang","${DIR}lang","./lang") {
		my $searchdir=$dir;
		if (($searchdir ne "") && (!($searchdir =~ /\/$/)) && (!($searchdir =~ /\\$/)) ) { $searchdir .= "/"; }
		if ($FileLang eq "") { if (open(LANG,"${searchdir}awstats-tt-$_[0].txt")) { $FileLang="${searchdir}awstats-tt-$_[0].txt"; } }
	}
	# If file not found, we try english
	foreach my $dir ("$DirLang","${DIR}lang","./lang") {
		my $searchdir=$dir;
		if (($searchdir ne "") && (!($searchdir =~ /\/$/)) && (!($searchdir =~ /\\$/)) ) { $searchdir .= "/"; }
		if ($FileLang eq "") { if (open(LANG,"${searchdir}awstats-tt-en.txt")) { $FileLang="${searchdir}awstats-tt-en.txt"; } }
	}
	&debug("Call to Read_Language_Tooltip [FileLang=\"$FileLang\"]");
	if ($FileLang ne "") {
		my $aws_VisitTimeout = $VisitTimeOut/10000*60;
		my $aws_NbOfRobots = scalar keys %RobotHashIDLib;
		my $aws_NbOfSearchEngines = scalar keys %SearchEnginesHashIDLib;
		while (<LANG>) {
			# Search for replaceable parameters
			s/#PROG#/$PROG/;
			s/#MaxNbOfRefererShown#/$MaxNbOfRefererShown/;
			s/#VisitTimeOut#/$aws_VisitTimeout/;
			s/#RobotArray#/$aws_NbOfRobots/;
			s/#SearchEnginesArray#/$aws_NbOfSearchEngines/;
			print "$_";
		}
	}
	close(LANG);
}


#--------------------------------------------------------------------
# Input: All lobal variables
# Ouput: Change on some global variables
#--------------------------------------------------------------------
sub Check_Config {
	&debug("Call to Check_Config");
	# Main section
	if ($LogFormat =~ /^[\d]$/ && $LogFormat !~ /[1-4]/)  { error("Error: LogFormat parameter is wrong. Value is '$LogFormat' (should be 1 or 2 or a 'personalised AWtats log format string')"); }
	if ($DNSLookup !~ /[0-1]/)                            { error("Error: DNSLookup parameter is wrong. Value is '$DNSLookup' (should be 0 or 1)"); }
	if ($AllowToUpdateStatsFromBrowser !~ /[0-1]/) { $AllowToUpdateStatsFromBrowser=1; }	# For compatibility, is 1 if not defined
	if ($PurgeLogFile !~ /[0-1]/)                 { $PurgeLogFile=0; }
	if ($ArchiveLogRecords !~ /[0-1]/)            { $ArchiveLogRecords=1; }
	# Optional section
	if ($DefaultFile eq "")                       { $DefaultFile="index.html"; }
	if ($URLWithQuery !~ /[0-1]/)                 { $URLWithQuery=0; }
	if ($WarningMessages !~ /[0-1]/)              { $WarningMessages=1; }
	if ($NbOfLinesForCorruptedLog !~ /[\d][\d]*/) { $NbOfLinesForCorruptedLog=50; }
	if ($FirstDayOfWeek !~ /[0-1]/)               { $FirstDayOfWeek=1; }
	if ($MaxNbOfDomain !~ /^[\d][\d]*/)           { $MaxNbOfDomain=25; }
	if ($MaxNbOfHostsShown !~ /^[\d][\d]*/)       { $MaxNbOfHostsShown=25; }
	if ($MinHitHost !~ /^[\d][\d]*/)              { $MinHitHost=1; }
	if ($MaxNbOfLoginShown !~ /^[\d][\d]*/)       { $MaxNbOfLoginShown=10; }
	if ($MinHitLogin !~ /^[\d][\d]*/)             { $MinHitLogin=1; }
	if ($MaxNbOfRobotShown !~ /^[\d][\d]*/)       { $MaxNbOfRobotShown=25; }
	if ($MinHitRobot !~ /^[\d][\d]*/)             { $MinHitRobot=1; }
	if ($MaxNbOfPageShown !~ /^[\d][\d]*/)        { $MaxNbOfPageShown=25; }
	if ($MinHitFile !~ /^[\d][\d]*/)              { $MinHitFile=1; }
	if ($MaxNbOfRefererShown !~ /^[\d][\d]*/)     { $MaxNbOfRefererShown=25; }
	if ($MinHitRefer !~ /^[\d][\d]*/)             { $MinHitRefer=1; }
	if ($MaxNbOfKeywordsShown !~ /^[\d][\d]*/)    { $MaxNbOfKeywordsShown=25; }
	if ($MinHitKeyword !~ /^[\d][\d]*/)           { $MinHitKeyword=1; }
	if ($MaxNbOfLastHosts !~ /^[\d][\d]*/)        { $MaxNbOfLastHosts=1000; }
	if ($SplitSearchString !~ /[0-1]/)            { $SplitSearchString=0; }
	if ($Expires !~ /^[\d][\d]*/)                 { $Expires=0; }
	if ($ShowHeader !~ /[0-1]/)                   { $ShowHeader=1; }
	if ($ShowMenu !~ /[0-1]/)                     { $ShowMenu=1; }
	if ($ShowMonthDayStats !~ /[0-1]/)            { $ShowMonthDayStats=1; }
	if ($ShowDaysOfWeekStats !~ /[0-1]/)          { $ShowDaysOfWeekStats=1; }
	if ($ShowHoursStats !~ /[0-1]/)               { $ShowHoursStats=1; }
	if ($ShowDomainsStats !~ /[0-1]/)             { $ShowDomainsStats=1; }
	if ($ShowHostsStats !~ /[0-1]/)               { $ShowHostsStats=1; }
	if ($ShowAuthenticatedUsers !~ /[0-1]/)       { $ShowAuthenticatedUsers=1; }
	if ($ShowRobotsStats !~ /[0-1]/)              { $ShowRobotsStats=1; }
	if ($ShowPagesStats !~ /[0-1]/)               { $ShowPagesStats=1; }
	if ($ShowFileTypesStats !~ /[0-1]/)           { $ShowFileTypesStats=1; }
	if ($ShowFileSizesStats !~ /[0-1]/)           { $ShowFileSizeStats=1; }
	if ($ShowBrowsersStats !~ /[0-1]/)            { $ShowBrowsersStats=1; }
	if ($ShowOSStats !~ /[0-1]/)                  { $ShowOSStats=1; }
	if ($ShowOriginStats !~ /[0-1]/)              { $ShowOriginStats=1; }
	if ($ShowKeyphrasesStats !~ /[0-1]/)          { $ShowKeyphrasesStats=1; }
	if ($ShowKeywordsStats !~ /[0-1]/)            { $ShowKeywordsStats=1; }
	if ($ShowCompressionStats !~ /[0-1]/)         { $ShowCompressionStats=1; }
	if ($ShowHTTPErrorsStats !~ /[0-1]/)          { $ShowHTTPErrorsStats=1; }
	if ($ShowLinksOnURL !~ /[0-1]/)               { $ShowLinksOnURL=1; }
	if ($DetailedReportsOnNewWindows !~ /[0-1]/)  { $DetailedReportsOnNewWindows=1; }
	if ($BarWidth !~ /^[\d][\d]*/)                { $BarWidth=260; }
	if ($BarHeight !~ /^[\d][\d]*/)               { $BarHeight=180; }
	if ($Logo eq "")                              { $Logo="awstats_logo1.png"; }
	if ($LogoLink eq "")                          { $LogoLink="http://awstats.sourceforge.net"; }
	$color_Background =~ s/#//g; if ($color_Background !~ /^[0-9|A-Z][0-9|A-Z]*$/i)           { $color_Background="FFFFFF";	}
	$color_TableBGTitle =~ s/#//g; if ($color_TableBGTitle !~ /^[0-9|A-Z][0-9|A-Z]*$/i)       { $color_TableBGTitle="CCCCDD"; }
	$color_TableTitle =~ s/#//g; if ($color_TableTitle !~ /^[0-9|A-Z][0-9|A-Z]*$/i)           { $color_TableTitle="000000"; }
	$color_TableBG =~ s/#//g; if ($color_TableBG !~ /^[0-9|A-Z][0-9|A-Z]*$/i)                 { $color_TableBG="CCCCDD"; }
	$color_TableRowTitle =~ s/#//g; if ($color_TableRowTitle !~ /^[0-9|A-Z][0-9|A-Z]*$/i)     { $color_TableRowTitle="FFFFFF"; }
	$color_TableBGRowTitle =~ s/#//g; if ($color_TableBGRowTitle !~ /^[0-9|A-Z][0-9|A-Z]*$/i) { $color_TableBGRowTitle="ECECEC"; }
	$color_TableBorder =~ s/#//g; if ($color_TableBorder !~ /^[0-9|A-Z][0-9|A-Z]*$/i)         { $color_TableBorder="ECECEC"; }
	$color_text =~ s/#//g; if ($color_text !~ /^[0-9|A-Z][0-9|A-Z]*$/i)           { $color_text="000000"; }
	$color_titletext =~ s/#//g; if ($color_titletext !~ /^[0-9|A-Z][0-9|A-Z]*$/i) { $color_titletext="000000"; }
	$color_link =~ s/#//g; if ($color_link !~ /^[0-9|A-Z][0-9|A-Z]*$/i)           { $color_link="0011BB"; }
	$color_hover =~ s/#//g; if ($color_hover !~ /^[0-9|A-Z][0-9|A-Z]*$/i)         { $color_hover="605040"; }
	$color_weekend =~ s/#//g; if ($color_weekend !~ /^[0-9|A-Z][0-9|A-Z]*$/i)     { $color_weekend="EAEAEA"; }
	$color_v =~ s/#//g; if ($color_v !~ /^[0-9|A-Z][0-9|A-Z]*$/i)                 { $color_v="F3F300"; }
	$color_w =~ s/#//g; if ($color_w !~ /^[0-9|A-Z][0-9|A-Z]*$/i)                 { $color_w="FF9933"; }
	$color_p =~ s/#//g; if ($color_p !~ /^[0-9|A-Z][0-9|A-Z]*$/i)                 { $color_p="4477DD"; }
	$color_h =~ s/#//g; if ($color_h !~ /^[0-9|A-Z][0-9|A-Z]*$/i)                 { $color_h="66F0FF"; }
	$color_k =~ s/#//g; if ($color_k !~ /^[0-9|A-Z][0-9|A-Z]*$/i)                 { $color_k="339944"; }
	$color_s =~ s/#//g; if ($color_s !~ /^[0-9|A-Z][0-9|A-Z]*$/i)                 { $color_s="8888DD"; }
	# Default value	for Messages
	if ($Message[0] eq "") { $Message[0]="Unknown"; }
	if ($Message[1] eq "") { $Message[1]="Unknown (unresolved ip)"; }
	if ($Message[2] eq "") { $Message[2]="Others"; }
	if ($Message[3] eq "") { $Message[3]="View details"; }
	if ($Message[4] eq "") { $Message[4]="Day"; }
	if ($Message[5] eq "") { $Message[5]="Month"; }
	if ($Message[6] eq "") { $Message[6]="Year"; }
	if ($Message[7] eq "") { $Message[7]="Statistics of"; }
	if ($Message[8] eq "") { $Message[8]="First visit"; }
	if ($Message[9] eq "") { $Message[9]="Last visit"; }
	if ($Message[10] eq "") { $Message[10]="Number of visits"; }
	if ($Message[11] eq "") { $Message[11]="Unique visitors"; }
	if ($Message[12] eq "") { $Message[12]="Visit"; }
	if ($Message[13] eq "") { $Message[13]="Keyword"; }
	if ($Message[14] eq "") { $Message[14]="Search"; }
	if ($Message[15] eq "") { $Message[15]="Percent"; }
	if ($Message[16] eq "") { $Message[16]="Traffic"; }
	if ($Message[17] eq "") { $Message[17]="Domains/Countries"; }
	if ($Message[18] eq "") { $Message[18]="Visitors"; }
	if ($Message[19] eq "") { $Message[19]="Pages-URL"; }
	if ($Message[20] eq "") { $Message[20]="Hours"; }
	if ($Message[21] eq "") { $Message[21]="Browsers"; }
	if ($Message[22] eq "") { $Message[22]="HTTP Errors"; }
	if ($Message[23] eq "") { $Message[23]="Referers"; }
	if ($Message[24] eq "") { $Message[24]="Search&nbsp;Keywords"; }
	if ($Message[25] eq "") { $Message[25]="Visitors domains/countries"; }
	if ($Message[26] eq "") { $Message[26]="hosts"; }
	if ($Message[27] eq "") { $Message[27]="pages"; }
	if ($Message[28] eq "") { $Message[28]="different pages"; }
	if ($Message[29] eq "") { $Message[29]="Access"; }
	if ($Message[30] eq "") { $Message[30]="Other words"; }
	if ($Message[31] eq "") { $Message[31]="Pages not found"; }
	if ($Message[32] eq "") { $Message[32]="HTTP Error codes"; }
	if ($Message[33] eq "") { $Message[33]="Netscape versions"; }
	if ($Message[34] eq "") { $Message[34]="IE versions"; }
	if ($Message[35] eq "") { $Message[35]="Last Update"; }
	if ($Message[36] eq "") { $Message[36]="Connect to site from"; }
	if ($Message[37] eq "") { $Message[37]="Origin"; }
	if ($Message[38] eq "") { $Message[38]="Direct address / Bookmarks"; }
	if ($Message[39] eq "") { $Message[39]="Origin unknown"; }
	if ($Message[40] eq "") { $Message[40]="Links from an Internet Search Engine"; }
	if ($Message[41] eq "") { $Message[41]="Links from an external page (other web sites except search engines)"; }
	if ($Message[42] eq "") { $Message[42]="Links from an internal page (other page on same site)"; }
	if ($Message[43] eq "") { $Message[43]="keywords used on search engines"; }
	if ($Message[44] eq "") { $Message[44]="Kb"; }
	if ($Message[45] eq "") { $Message[45]="Unresolved IP Address"; }
	if ($Message[46] eq "") { $Message[46]="Unknown OS (Referer field)"; }
	if ($Message[47] eq "") { $Message[47]="Required but not found URLs (HTTP code 404)"; }
	if ($Message[48] eq "") { $Message[48]="IP Address"; }
	if ($Message[49] eq "") { $Message[49]="Error&nbsp;Hits"; }
	if ($Message[50] eq "") { $Message[50]="Unknown browsers (Referer field)"; }
	if ($Message[51] eq "") { $Message[51]="Visiting robots"; }
	if ($Message[52] eq "") { $Message[52]="visits/visitor"; }
	if ($Message[53] eq "") { $Message[53]="Robots/Spiders visitors"; }
	if ($Message[54] eq "") { $Message[54]="Free realtime logfile analyzer for advanced web statistics"; }
	if ($Message[55] eq "") { $Message[55]="of"; }
	if ($Message[56] eq "") { $Message[56]="Pages"; }
	if ($Message[57] eq "") { $Message[57]="Hits"; }
	if ($Message[58] eq "") { $Message[58]="Versions"; }
	if ($Message[59] eq "") { $Message[59]="Operating Systems"; }
	if ($Message[60] eq "") { $Message[60]="Jan"; }
	if ($Message[61] eq "") { $Message[61]="Feb"; }
	if ($Message[62] eq "") { $Message[62]="Mar"; }
	if ($Message[63] eq "") { $Message[63]="Apr"; }
	if ($Message[64] eq "") { $Message[64]="May"; }
	if ($Message[65] eq "") { $Message[65]="Jun"; }
	if ($Message[66] eq "") { $Message[66]="Jul"; }
	if ($Message[67] eq "") { $Message[67]="Aug"; }
	if ($Message[68] eq "") { $Message[68]="Sep"; }
	if ($Message[69] eq "") { $Message[69]="Oct"; }
	if ($Message[70] eq "") { $Message[70]="Nov"; }
	if ($Message[71] eq "") { $Message[71]="Dec"; }
	if ($Message[72] eq "") { $Message[72]="Navigation"; }
	if ($Message[73] eq "") { $Message[73]="Files type"; }
	if ($Message[74] eq "") { $Message[74]="Update now"; }
	if ($Message[75] eq "") { $Message[75]="Bytes"; }
	if ($Message[76] eq "") { $Message[76]="Back to main page"; }
	if ($Message[77] eq "") { $Message[77]="Top"; }
	if ($Message[78] eq "") { $Message[78]="dd mmm yyyy - HH:MM"; }
	if ($Message[79] eq "") { $Message[79]="Filter"; }
	if ($Message[80] eq "") { $Message[80]="Full list"; }
	if ($Message[81] eq "") { $Message[81]="Hosts"; }
	if ($Message[82] eq "") { $Message[82]="Known"; }
	if ($Message[83] eq "") { $Message[83]="Robots"; }
	if ($Message[84] eq "") { $Message[84]="Sun"; }
	if ($Message[85] eq "") { $Message[85]="Mon"; }
	if ($Message[86] eq "") { $Message[86]="Tue"; }
	if ($Message[87] eq "") { $Message[87]="Wed"; }
	if ($Message[88] eq "") { $Message[88]="Thu"; }
	if ($Message[89] eq "") { $Message[89]="Fri"; }
	if ($Message[90] eq "") { $Message[90]="Sat"; }
	if ($Message[91] eq "") { $Message[91]="Days of week"; }
	if ($Message[92] eq "") { $Message[92]="Who"; }
	if ($Message[93] eq "") { $Message[93]="When"; }
	if ($Message[94] eq "") { $Message[94]="Authenticated users"; }
	if ($Message[95] eq "") { $Message[95]="Min"; }
	if ($Message[96] eq "") { $Message[96]="Average"; }
	if ($Message[97] eq "") { $Message[97]="Max"; }
	if ($Message[98] eq "") { $Message[98]="Web compression"; }
	if ($Message[99] eq "") { $Message[99]="Bandwith saved"; }
	if ($Message[100] eq "") { $Message[100]="Before compression"; }
	if ($Message[101] eq "") { $Message[101]="After compression"; }
	if ($Message[102] eq "") { $Message[102]="Total"; }
}

#--------------------------------------------------------------------
# Input: year,month,0|1		(0=read only 1st part, 1=read all file)
#--------------------------------------------------------------------
sub Read_History_File {
	my $year=sprintf("%04i",shift);
	my $month=sprintf("%02i",shift);
	my $part=shift;
	&debug("Call to Read_History_File [$year,$month,$part]");
	if ($HistoryFileAlreadyRead{"$year$month"}) { return 0; }			# Protect code to invoke function only once for each month/year
	$HistoryFileAlreadyRead{"$year$month"}=1;							# Protect code to invoke function only once for each month/year
	if ($AddOn) { AddOn_Filename(); }
	if (! -s "$DirData/$PROG$AddOnDay$month$year$FileSuffix.txt") {
		# If file not exists, return
		&debug(" No history file");
		return 0;
	}	

	# If session for read (no update), file can be open with share
	# POSSIBLE CHANGE HERE	
	open(HISTORY,"$DirData/$PROG$AddOnDay$month$year$FileSuffix.txt") || error("Error: Couldn't open for read file \"$DirData/$PROG$AddOnDay$month$year$FileSuffix.txt\" : $!");	# Month before Year kept for backward compatibility
	$MonthUnique{$year.$month}=0; $MonthPages{$year.$month}=0; $MonthHits{$year.$month}=0; $MonthBytes{$year.$month}=0; $MonthHostsKnown{$year.$month}=0; $MonthHostsUnKnown{$year.$month}=0;
	my $readdomain=0;my $readbrowser=0;my $readnsver=0;my $readmsiever=0;
	my $reados=0;my $readrobot=0;my $readunknownreferer=0;my $readunknownrefererbrowser=0;
	my $readse=0;my $readsearchwords=0;my $readerrors=0;

	while (<HISTORY>) {
		chomp $_; s/\r//;
		my @field=split(/\s+/,$_);
		# Analyze config line
	    if ($field[0] eq "LastLine")        { if ($LastLine{$year.$month} < int($field[1])) { $LastLine{$year.$month}=int($field[1]); }; next; }
		if ($field[0] eq "FirstTime")       { $FirstTime{$year.$month}=int($field[1]); next; }
	    if ($field[0] eq "LastTime")        { if ($LastTime{$year.$month} < int($field[1])) { $LastTime{$year.$month}=int($field[1]); }; next; }
		if ($field[0] eq "TotalVisits")     { $MonthVisits{$year.$month}=int($field[1]); next; }
	    if ($field[0] eq "LastUpdate")      {
	    	if ($LastUpdate{$year.$month} < $field[1]) {
		    	$LastUpdate{$year.$month}=int($field[1]);
		    	#$LastUpdateLinesRead{$year.$month}=int($field[2]);
		    	#$LastUpdateNewLinesRead{$year.$month}=int($field[3]);
		    	#$LastUpdateLinesCorrupted{$year.$month}=int($field[4]); 
		    };
	    	next;
	    }
	    if ($field[0] eq "BEGIN_VISITOR")   {
			&debug(" Begin of VISITOR section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			while ($field[0] ne "END_VISITOR") {
		    	if ($field[0] ne "Unknown") { if ($field[1] > 0) { $MonthUnique{$year.$month}++; } $MonthHostsKnown{$year.$month}++; }
				if ($part && ($QueryString !~ /output=/i || $QueryString =~ /output=lasthosts/i)) {
		        	if ($field[1] > 0) { $_hostmachine_p{$field[0]}+=$field[1]; }
		        	if ($field[2] > 0) { $_hostmachine_h{$field[0]}+=$field[2]; }
		        	if ($field[3] > 0) { $_hostmachine_k{$field[0]}+=$field[3]; }
		        	if (! $_hostmachine_l{$field[0]} && $field[4] > 0) { $_hostmachine_l{$field[0]}=int($field[4]); }
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of VISITOR section");
			next;
    	}
	    if ($field[0] eq "BEGIN_UNKNOWNIP")   {
			&debug(" Begin of UNKNOWNIP section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			my $count=0;
			while ($field[0] ne "END_UNKNOWNIP") {
				$count++;
		    	$MonthUnique{$year.$month}++; $MonthHostsUnknown{$year.$month}++;
				if ($part && ($UpdateStats || $QueryString =~ /output=unknownip/i || $QueryString =~ /output=lasthosts/i)) {	# Init of $_unknownip_l not needed in other cases
		        	if (! $_unknownip_l{$field[0]}) { $_unknownip_l{$field[0]}=int($field[1]); }
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of UNKNOWN_IP section ($count entries)");
			next;
    	}
	    if ($field[0] eq "BEGIN_LOGIN")   {
			&debug(" Begin of LOGIN section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			my $count=0;
			while ($field[0] ne "END_LOGIN") {
				$count++;
            	if ($part) {
			    	if ($field[1] > 0) { $_login_p{$field[0]}+=$field[1]; }
			    	if ($field[2] > 0) { $_login_h{$field[0]}+=$field[2]; }
			    	if ($field[3] > 0) { $_login_k{$field[0]}+=$field[3]; }
		        	if (! $_login_l{$field[0]} && $field[4] > 0) { $_login_l{$field[0]}=int($field[4]); }
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of LOGIN section ($count entries)");
			next;
    	}
	    if ($field[0] eq "BEGIN_TIME")      {
			&debug(" Begin of TIME section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			while ($field[0] ne "END_TIME") {
		    	$MonthPages{$year.$month}+=$field[1]; $MonthHits{$year.$month}+=$field[2]; $MonthBytes{$year.$month}+=$field[3];
				if ($part) {
		        	$_time_p[$field[0]]+=$field[1];
		        	$_time_h[$field[0]]+=$field[2];
		        	$_time_k[$field[0]]+=$field[3];
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of TIME section");
			next;
	    }
	    if ($field[0] eq "BEGIN_DAY")      {
			&debug(" Begin of DAY section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			while ($field[0] ne "END_DAY" ) {
				if ($QueryString !~ /output=/i) {
					$DayPages{$field[0]}=int($field[1]); $DayHits{$field[0]}=int($field[2]); $DayBytes{$field[0]}=int($field[3]); $DayVisits{$field[0]}=int($field[4]); $DayUnique{$field[0]}=int($field[5]);
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of DAY section");
			next;
	    }
		if ($field[0] eq "BEGIN_SIDER")  {
			&debug(" Begin of SIDER section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			my $count=0;my $countadd=0;
			while ($field[0] ne "END_SIDER") {
				$count++;
				if ($part) {
					my $addsider=0;
					if ($UpdateStats) { $addsider=1; }
					if (!$UpdateStats) {
						# In this case we count TotalDifferentPages because we don't fill _sider_p completely
						$TotalDifferentPages++;
						if ($HTMLOutput && $QueryString =~ /output=urldetail/i && (!$URLFilter || $field[0] =~ /$URLFilter/)) { $addsider=1; }
						if ($HTMLOutput && $QueryString !~ /output=/i && $countadd < $MaxNbOfPageShown) { $addsider=1; }
					}
					if ($addsider) {					
						$countadd++;
						$_sider_p{$field[0]}+=$field[1];
					}
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of SIDER section ($count entries loaded)");
			next;
		}
	    if ($field[0] eq "BEGIN_PAGEREFS")   {
			&debug(" Begin of PAGEREFS section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			my $count=0;
			while ($field[0] ne "END_PAGEREFS") {
				$count++;
				if ($part) {
					$_pagesrefs_h{$field[0]}+=$field[1];
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of PAGEREFS section ($count entries)");
			next;
    	}
	    if ($field[0] eq "BEGIN_FILETYPES")   {
			&debug(" Begin of FILETYPES section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			my $count=0;
			while ($field[0] ne "END_FILETYPES") {
				$count++;
				if ($part) {
					$_filetypes_h{$field[0]}+=$field[1];
					$_filetypes_k{$field[0]}+=$field[2];
					$_filetypes_gz_in{$field[0]}+=$field[3];
					$_filetypes_gz_out{$field[0]}+=$field[4];
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of FILETYPES section ($count entries)");
			next;
    	}
	    if ($field[0] eq "BEGIN_SIDER_404")   {
			&debug(" Begin of SIDER_404 section");
			$_=<HISTORY>;
			chomp $_; s/\r//;
			if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
			my @field=split(/\s+/,$_);
			my $count=0;
			while ($field[0] ne "END_SIDER_404") {
				$count++;
				if ($part) {
					$_sider404_h{$field[0]}+=$field[1];
					if ($UpdateStats || $QueryString =~ /output=notfounderror/i) {
						$_referer404_h{$field[0]}=$field[2];
					}
				}
				$_=<HISTORY>;
				chomp $_; s/\r//;
				if ($_ eq "") { error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost)."); }
				@field=split(/\s+/,$_);
			}
			&debug(" End of SIDER_404 section ($count entries)");
			next;
		}

		# SECOND PART: If $part == 0, it means we don't need this part of data.
		if ($part) {
	        if ($field[0] eq "BEGIN_DOMAIN") { $readdomain=1; next; }
			if ($field[0] eq "END_DOMAIN")   { $readdomain=0; next; }
	        if ($field[0] eq "BEGIN_BROWSER") { $readbrowser=1; next; }
	        if ($field[0] eq "END_BROWSER") { $readbrowser=0; next; }
	        if ($field[0] eq "BEGIN_NSVER") { $readnsver=1; next; }
	        if ($field[0] eq "END_NSVER") { $readnsver=0; next; }
	        if ($field[0] eq "BEGIN_MSIEVER") { $readmsiever=1; next; }
	        if ($field[0] eq "END_MSIEVER") { $readmsiever=0; next; }
	        if ($field[0] eq "BEGIN_OS") { $reados=1; next; }
	        if ($field[0] eq "END_OS") { $reados=0; next; }
	        if ($field[0] eq "BEGIN_ROBOT") { $readrobot=1; next; }
	        if ($field[0] eq "END_ROBOT") { $readrobot=0; next; }
	        if ($field[0] eq "BEGIN_UNKNOWNREFERER") { $readunknownreferer=1; next; }
	        if ($field[0] eq "END_UNKNOWNREFERER")   { $readunknownreferer=0; next; }
	        if ($field[0] eq "BEGIN_UNKNOWNREFERERBROWSER") { $readunknownrefererbrowser=1; next; }
	        if ($field[0] eq "END_UNKNOWNREFERERBROWSER")   { $readunknownrefererbrowser=0; next; }
	        if ($field[0] eq "BEGIN_SEREFERRALS") { $readse=1; next; }
	        if ($field[0] eq "END_SEREFERRALS") { $readse=0; next; }
	        if ($field[0] eq "BEGIN_SEARCHWORDS") { $readsearchwords=1; next; }
	        if ($field[0] eq "END_SEARCHWORDS") { $readsearchwords=0; next; }
	        if ($field[0] eq "BEGIN_ERRORS") { $readerrors=1; next; }
	        if ($field[0] eq "END_ERRORS") { $readerrors=0; next; }
	        if ($readunknownreferer) {
	        	if (! $_unknownreferer_l{$field[0]}) { $_unknownreferer_l{$field[0]}=int($field[1]); }
	        	next;
	        }
			if ($readdomain) {
				$_domener_p{$field[0]}+=$field[1];
				$_domener_h{$field[0]}+=$field[2];
				$_domener_k{$field[0]}+=$field[3];
				next;
			}
	        if ($readbrowser) { $_browser_h{$field[0]}+=$field[1]; next; }
	        if ($readnsver) { $_nsver_h[$field[0]]+=$field[1]; next; }
	        if ($readmsiever) { $_msiever_h[$field[0]]+=$field[1]; next; }
	        if ($reados) { $_os_h{$field[0]}+=$field[1]; next; }
	        if ($readrobot) {
				$_robot_h{$field[0]}+=$field[1];
	        	if (! $_robot_l{$field[0]}) { $_robot_l{$field[0]}=int($field[2]); }
				next;
			}
	        if ($readunknownrefererbrowser) {
	        	if (! $_unknownrefererbrowser_l{$field[0]}) { $_unknownrefererbrowser_l{$field[0]}=int($field[1]); }
	        	next;
	        }
	        if ($field[0] eq "From0") { $_from_p[0]+=$field[1]; $_from_h[0]+=$field[2]; next; }
	        if ($field[0] eq "From1") { $_from_p[1]+=$field[1]; $_from_h[1]+=$field[2]; next; }
	        if ($field[0] eq "From2") { $_from_p[2]+=$field[1]; $_from_h[2]+=$field[2]; next; }
	        if ($field[0] eq "From3") { $_from_p[3]+=$field[1]; $_from_h[3]+=$field[2]; next; }
	        if ($field[0] eq "From4") { $_from_p[4]+=$field[1]; $_from_h[4]+=$field[2]; next; }
			# Next 5 lines are to read old awstats history files ("Fromx" section was "HitFromx" in such files)
	        if ($field[0] eq "HitFrom0") { $_from_p[0]+=0; $_from_h[0]+=$field[1]; next; }
	        if ($field[0] eq "HitFrom1") { $_from_p[1]+=0; $_from_h[1]+=$field[1]; next; }
	        if ($field[0] eq "HitFrom2") { $_from_p[2]+=0; $_from_h[2]+=$field[1]; next; }
	        if ($field[0] eq "HitFrom3") { $_from_p[3]+=0; $_from_h[3]+=$field[1]; next; }
	        if ($field[0] eq "HitFrom4") { $_from_p[4]+=0; $_from_h[4]+=$field[1]; next; }
	        if ($readse) { $_se_referrals_h{$field[0]}+=$field[1]; next; }
	        if ($readsearchwords) { $_keyphrases{$field[0]}+=$field[1]; next; }
	        if ($readerrors) { $_errors_h{$field[0]}+=$field[1]; next; }
		}
	}
	close HISTORY;
	if (! $LastLine{$year.$month}) { $LastLine{$year.$month}=$LastTime{$year.$month}; }		# For backward compatibility, if LastLine does not exist
	if ($readdomain || $readbrowser || $readnsver || $readmsiever || $reados || $readrobot || $readunknownreferer || $readunknownrefererbrowser || $readse || $readsearchwords || $readerrors) {
		# History file is corrupted
		error("Error: History file \"$DirData/$PROG$month$year$FileSuffix.txt\" is corrupted. Restore a recent backup of this file, or remove it (data for this month will be lost).");
	}
}

#--------------------------------------------------------------------
# Function:    Show flags for 5 major languages
# Input:       Year, Month
#--------------------------------------------------------------------
sub Save_History_File {
	my $year=sprintf("%04i",shift);
	my $month=sprintf("%02i",shift);
	&debug("Call to Save_History_File [$year,$month]");
	open(HISTORYTMP,">$DirData/$PROG$month$year$FileSuffix.tmp.$$") || error("Error: Couldn't open file \"$DirData/$PROG$month$year$FileSuffix.tmp.$$\" : $!");	# Month before Year kept for backward compatibility

	print HISTORYTMP "LastLine $LastLine{$year.$month}\n";
	print HISTORYTMP "FirstTime $FirstTime{$year.$month}\n";
	print HISTORYTMP "LastTime $LastTime{$year.$month}\n";
	if ($LastUpdate{$year.$month} < int("$nowyear$nowmonth$nowday$nowhour$nowmin$nowsec")) { $LastUpdate{$year.$month}=int("$nowyear$nowmonth$nowday$nowhour$nowmin$nowsec"); }
	print HISTORYTMP "LastUpdate $LastUpdate{$year.$month} $NbOfLinesRead $NbOfNewLinesProcessed $NbOfLinesCorrupted\n";
	print HISTORYTMP "TotalVisits $MonthVisits{$year.$month}\n";

	# When
	print HISTORYTMP "BEGIN_DAY\n";
    foreach my $key (keys %DayHits) {
    	 if ($key =~ /^$year$month/) {	# Found a day entry of the good month
    	 	print HISTORYTMP "$key $DayPages{$key} $DayHits{$key} $DayBytes{$key} $DayVisits{$key} $DayUnique{$key}\n"; next;
    	 	}
    	 }
    print HISTORYTMP "END_DAY\n";
	print HISTORYTMP "BEGIN_TIME\n";
	for (my $ix=0; $ix<=23; $ix++) { print HISTORYTMP "$ix $_time_p[$ix] $_time_h[$ix] $_time_k[$ix]\n"; next; }
	print HISTORYTMP "END_TIME\n";

	# Who
	print HISTORYTMP "BEGIN_DOMAIN\n";
	foreach my $key (keys %_domener_h) {
		my $page=$_domener_p{$key}; if ($page == "") {$page=0;}
		my $bytes=$_domener_k{$key}; if ($bytes == "") {$bytes=0;}
		print HISTORYTMP "$key $page $_domener_h{$key} $bytes\n"; next;
	}
	print HISTORYTMP "END_DOMAIN\n";
	print HISTORYTMP "BEGIN_VISITOR\n";
	foreach my $key (keys %_hostmachine_h) {
		my $page=$_hostmachine_p{$key}; if ($page == "") {$page=0;}
		my $bytes=$_hostmachine_k{$key}; if ($bytes == "") {$bytes=0;}
		print HISTORYTMP "$key $page $_hostmachine_h{$key} $bytes $_hostmachine_l{$key}\n"; next;
	}
	print HISTORYTMP "END_VISITOR\n";
	print HISTORYTMP "BEGIN_UNKNOWNIP\n";
	foreach my $key (keys %_unknownip_l) { print HISTORYTMP "$key $_unknownip_l{$key}\n"; next; }
	print HISTORYTMP "END_UNKNOWNIP\n";
	print HISTORYTMP "BEGIN_LOGIN\n";
	foreach my $key (keys %_login_h) { print HISTORYTMP "$key $_login_p{$key} $_login_h{$key} $_login_k{$key} $_login_l{$key}\n"; next; }
	print HISTORYTMP "END_LOGIN\n";
	print HISTORYTMP "BEGIN_ROBOT\n";
	foreach my $key (keys %_robot_h) { print HISTORYTMP "$key $_robot_h{$key} $_robot_l{$key}\n"; next; }
	print HISTORYTMP "END_ROBOT\n";

	# Navigation
	# Save page list in score sorted order to allow to show reports faster and saving memory.
	print HISTORYTMP "BEGIN_SIDER\n";
	foreach my $key (sort {$SortDir*$_sider_p{$a} <=> $SortDir*$_sider_p{$b}} keys %_sider_p) { print HISTORYTMP "$key $_sider_p{$key}\n"; next; }
	print HISTORYTMP "END_SIDER\n";
	print HISTORYTMP "BEGIN_FILETYPES\n";
	foreach my $key (keys %_filetypes_h) { print HISTORYTMP "$key $_filetypes_h{$key} $_filetypes_k{$key} $_filetypes_gz_in{$key} $_filetypes_gz_out{$key}\n"; next; }
	print HISTORYTMP "END_FILETYPES\n";
	print HISTORYTMP "BEGIN_BROWSER\n";
	foreach my $key (keys %_browser_h) { print HISTORYTMP "$key $_browser_h{$key}\n"; next; }
	print HISTORYTMP "END_BROWSER\n";
	print HISTORYTMP "BEGIN_NSVER\n";
	for (my $i=1; $i<=$#_nsver_h; $i++) { print HISTORYTMP "$i $_nsver_h[$i]\n"; next; }
	print HISTORYTMP "END_NSVER\n";
	print HISTORYTMP "BEGIN_MSIEVER\n";
	for (my $i=1; $i<=$#_msiever_h; $i++) { print HISTORYTMP "$i $_msiever_h[$i]\n"; next; }
	print HISTORYTMP "END_MSIEVER\n";
	print HISTORYTMP "BEGIN_OS\n";
	foreach my $key (keys %_os_h) { print HISTORYTMP "$key $_os_h{$key}\n"; next; }
	print HISTORYTMP "END_OS\n";

	# Referer
	print HISTORYTMP "BEGIN_UNKNOWNREFERER\n";
	foreach my $key (keys %_unknownreferer_l) { print HISTORYTMP "$key $_unknownreferer_l{$key}\n"; next; }
	print HISTORYTMP "END_UNKNOWNREFERER\n";
	print HISTORYTMP "BEGIN_UNKNOWNREFERERBROWSER\n";
	foreach my $key (keys %_unknownrefererbrowser_l) { print HISTORYTMP "$key $_unknownrefererbrowser_l{$key}\n"; next; }
	print HISTORYTMP "END_UNKNOWNREFERERBROWSER\n";
	print HISTORYTMP "From0 $_from_p[0] $_from_h[0]\n";
	print HISTORYTMP "From1 $_from_p[1] $_from_h[1]\n";
	print HISTORYTMP "From2 $_from_p[2] $_from_h[2]\n";
	print HISTORYTMP "From3 $_from_p[3] $_from_h[3]\n";
	print HISTORYTMP "From4 $_from_p[4] $_from_h[4]\n";
	print HISTORYTMP "BEGIN_SEREFERRALS\n";
	foreach my $key (keys %_se_referrals_h) { print HISTORYTMP "$key $_se_referrals_h{$key}\n"; next; }
	print HISTORYTMP "END_SEREFERRALS\n";
	print HISTORYTMP "BEGIN_PAGEREFS\n";
	foreach my $key (keys %_pagesrefs_h) { print HISTORYTMP "$key $_pagesrefs_h{$key}\n"; next; }
	print HISTORYTMP "END_PAGEREFS\n";
	print HISTORYTMP "BEGIN_SEARCHWORDS\n";
	foreach my $key (keys %_keyphrases) { if ($_keyphrases{$key}) { print HISTORYTMP "$key $_keyphrases{$key}\n"; } next; }
	print HISTORYTMP "END_SEARCHWORDS\n";

	# Other
	print HISTORYTMP "BEGIN_ERRORS\n";
	foreach my $key (keys %_errors_h) { print HISTORYTMP "$key $_errors_h{$key}\n"; next; }
	print HISTORYTMP "END_ERRORS\n";
	print HISTORYTMP "BEGIN_SIDER_404\n";
	foreach my $key (keys %_sider404_h) { print HISTORYTMP "$key $_sider404_h{$key} $_referer404_h{$key}\n"; next; }
	print HISTORYTMP "END_SIDER_404\n";

	close(HISTORYTMP);
}

#--------------------------------------------------------------------
# Input: Global variables
#--------------------------------------------------------------------
sub Init_HashArray {
	my $year=sprintf("%04i",shift);
	my $month=sprintf("%02i",shift);
	&debug("Call to Init_HashArray [$year,$month]");
	# We purge data read for $year and $month so it's like we never read it
	$HistoryFileAlreadyRead{"$year$month"}=0;
	# Delete/Reinit all arrays with name beginning by _
	@_msiever_h = @_nsver_h = ();
	for (my $ix=0; $ix<5; $ix++) {	$_from_p[$ix]=0; $_from_h[$ix]=0; }
	for (my $ix=0; $ix<=23; $ix++) { $_time_h[$ix]=0; $_time_k[$ix]=0; $_time_p[$ix]=0; }
	# Delete/Reinit all hash arrays with name beginning by _
	%_browser_h = %_domener_h = %_domener_k = %_domener_p = %_errors_h =
	%_filetypes_h = %_filetypes_k = %_filetypes_gz_in = %_filetypes_gz_out =
	%_hostmachine_h = %_hostmachine_k = %_hostmachine_l = %_hostmachine_p =
	%_keyphrases = %_os_h = %_pagesrefs_h = %_robot_h = %_robot_l = 
	%_login_h = %_login_p = %_login_k = %_login_l =
	%_se_referrals_h = %_sider404_h = %_sider_h = %_sider_k = %_sider_p =
	%_unknownip_l = %_unknownreferer_l =	%_unknownrefererbrowser_l = ();
}

#--------------------------------------------------------------------
# Function:      Show flags for other language translations
# Input:         Current languade id (en, fr, ...)
#--------------------------------------------------------------------
sub Show_Flag_Links {
	my $CurrentLang = shift;
	if ($ShowFlagLinks eq "0") { $ShowFlagLinks = ""; }						# For backward compatibility
	if ($ShowFlagLinks eq "1") { $ShowFlagLinks = "en fr de it nl es"; }	# For backward compatibility
	my @flaglist=split(/\s+/,$ShowFlagLinks);
	print "<br>\n";
	foreach my $flag (@flaglist) {
		if ($flag ne $CurrentLang) {
			my $lng=$flag;
			if ($flag eq "en") { $lng="English"; }
			if ($flag eq "fr") { $lng="French"; }
			if ($flag eq "de") { $lng="German"; }
			if ($flag eq "it") { $lng="Italian"; }
			if ($flag eq "nl") { $lng="Dutch"; }
			if ($flag eq "es") { $lng="Spanish"; }
			print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$flag\"><img src=\"$DirIcons\/flags\/$flag.png\" height=14 border=0 alt=\"$lng\" title=\"$lng\"></a>&nbsp;\n";
		}
	}
}

#------------------------------------------------------------------------------
# Function:      Format value in bytes in a string (Bytes, Kb, Mb, Gb)
# Input:         bytes
#------------------------------------------------------------------------------
sub Format_Bytes {
	my $bytes = shift;
	my $fudge = 1;
	if ($bytes >= $fudge * exp(3*log(1024))) { return sprintf("%.2f", $bytes/exp(3*log(1024)))." Gb"; }
	if ($bytes >= $fudge * exp(2*log(1024))) { return sprintf("%.2f", $bytes/exp(2*log(1024)))." Mb"; }
	if ($bytes >= $fudge * exp(1*log(1024))) { return sprintf("%.2f", $bytes/exp(1*log(1024)))." $Message[44]"; }
	return "$bytes $Message[75]";
}

#------------------------------------------------------------------------------
# Function:      Format a date according to Message[78] (country date format)
# Input:         day month year hour min
#------------------------------------------------------------------------------
sub Format_Date {
	my $date=shift;
	my $year=substr("$date",0,4);
	my $month=substr("$date",4,2);
	my $day=substr("$date",6,2);
	my $hour=substr("$date",8,2);
	my $min=substr("$date",10,2);
	my $dateformat=$Message[78];
	$dateformat =~ s/yyyy/$year/g;
	$dateformat =~ s/yy/$year/g;
	$dateformat =~ s/mmm/$monthlib{$month}/g;
	$dateformat =~ s/mm/$month/g;
	$dateformat =~ s/dd/$day/g;
	$dateformat =~ s/HH/$hour/g;
	$dateformat =~ s/MM/$min/g;
	return "$dateformat";
}



#--------------------------------------------------------------------
# MAIN
#--------------------------------------------------------------------
if ($ENV{"GATEWAY_INTERFACE"} ne "") {	# Run from a browser
	print("Content-type: text/html\n\n\n");
	if ($ENV{"CONTENT_LENGTH"} ne "") {
		binmode STDIN;
		read(STDIN, $QueryString, $ENV{'CONTENT_LENGTH'});
	}
	if ($ENV{"QUERY_STRING"} ne "") {
		$QueryString = $ENV{"QUERY_STRING"};
	}
	$QueryString =~ s/<script.*$//i;						# This is to avoid 'Cross Site Scripting attacks'
	if ($QueryString =~ /site=/i)   { $SiteConfig=$QueryString; $SiteConfig =~ s/.*site=//i;   $SiteConfig =~ s/&.*//; $SiteConfig =~ s/ .*//; }	# For backward compatibility
	if ($QueryString =~ /config=/i) { $SiteConfig=$QueryString; $SiteConfig =~ s/.*config=//i; $SiteConfig =~ s/&.*//; $SiteConfig =~ s/ .*//; }
	$UpdateStats=0; $HTMLOutput=1;							# No update but report by default when run from a browser
	if ($QueryString =~ /update=1/i)   { $UpdateStats=1; }					# Update is required
}
else {									# Run from command line
	if ($ARGV[0] eq "-h") { $SiteConfig = $ARGV[1]; }		# Kept for backward compatibility but useless
	$QueryString=""; for (0..@ARGV-1) { $QueryString .= "$ARGV[$_] "; }
	$QueryString =~ s/<script.*$//i;						# This is to avoid 'Cross Site Scripting attacks'
	if ($QueryString =~ /site=/i)   { $SiteConfig=$QueryString; $SiteConfig =~ s/.*site=//i;   $SiteConfig =~ s/&.*//; $SiteConfig =~ s/ .*//; }	# For backward compatibility
	if ($QueryString =~ /config=/i) { $SiteConfig=$QueryString; $SiteConfig =~ s/.*config=//i; $SiteConfig =~ s/&.*//; $SiteConfig =~ s/ .*//; }
	$UpdateStats=1;	$HTMLOutput=0;							# Update with no report by default when run from command line
	if ($QueryString =~ /-output/i)    { $UpdateStats=0; $HTMLOutput=1; }	# Report and no update if an output is required
	if ($QueryString =~ /-update/i)    { $UpdateStats=1; }					# Except if -update specified
	if ($QueryString =~ /-showsteps/i) { $ShowSteps=1; } else { $ShowSteps=0; }
}
if ($QueryString =~ /sort=/i)  		{ $Sort=$QueryString;  $Sort =~ s/.*sort=//i;  $Sort =~ s/&.*//;  $Sort =~ s/ .*//; }
if ($QueryString =~ /debug=/i) 		{ $Debug=$QueryString; $Debug =~ s/.*debug=//i; $Debug =~ s/&.*//; $Debug =~ s/ .*//; }
if ($QueryString =~ /output=urldetail:/i) 	{	
	# A filter can be defined with output=urldetail to reduce number of lines read and showed
	$URLFilter=$QueryString; $URLFilter =~ s/.*output=urldetail://; $URLFilter =~ s/&.*//; $URLFilter =~ s/ .*//;
}

($DIR=$0) =~ s/([^\/\\]*)$//; ($PROG=$1) =~ s/\.([^\.]*)$//; $Extension=$1;

# Read reference databases
&Read_Ref_Data();

if (($ENV{"GATEWAY_INTERFACE"} eq "") && ($SiteConfig eq "")) {
	print "----- $PROG $VERSION (c) Laurent Destailleur -----\n";
	print "$PROG is a free web server logfile analyzer to show you advanced web\n";
	print "statistics.\n";
	print "$PROG comes with ABSOLUTELY NO WARRANTY. It's a free software distributed\n";
	print "with a GNU General Public License (See COPYING.txt file for details).\n";
	print "\n";
	print "Syntax: $PROG.$Extension -config=virtualhostname [options]\n";
	print "  This runs $PROG in command line to update statistics of a web site, from\n";
	print "  the log file defined in config file, and/or returns a HTML report.\n";
	print "  First, $PROG tries to read $PROG.virtualhostname.conf as the config file.\n";
	print "  If not found, $PROG tries to read $PROG.conf\n";
	print "  See README.TXT file to know how to create the config file.\n";
	print "\n";
	print "Options to update statistics:\n";
	print "  -update     to update statistics (default)\n";
	print "  -showsteps  to add benchmark information every $NbOfLinesForBenchmark lines processed\n";
	print "  Be care to process log files in chronological order when updating statistics.\n";
	print "\n";
	print "Options to show statistics:\n";
	print "  -output     to output a HTML report (no update made except if -update is set)\n";
	print "  -lang=LL    to output a HTML report in language LL (en,de,es,fr,it,nl,...)\n";
	print "  -month=MM   to output a HTML report for an old month=MM\n";
	print "  -year=YYYY  to output a HTML report for an old year=YYYY\n";
	print "  Warning: Those 'date' options doesn't allow you to process old log file.\n";
	print "  It only allows you to see a report for a chosen month/year period instead\n";
	print "  of current month/year.\n";
	print "\n";
#	print "Common options:\n";
#	print "  -debug=X             to add debug informations lesser than level X\n";
#	print "\n";
	print "Now supports/detects:\n";
	print "  Reverse DNS lookup\n";
	print "  Number of visits, unique visitors, list of last visits\n";
	print "  Hosts list and unresolved IP addresses list\n";
	print "  Days of week and rush hours\n";
	print "  Authenticated users\n";
	print "  Most often viewed pages\n";
	print "  ".(scalar keys %DomainsHashIDLib)." domains/countries\n";
	print "  ".(scalar keys %BrowsersHashIDLib)." browsers\n";
	print "  ".(scalar keys %OSHashLib)." operating systems\n";
	print "  ".(scalar keys %RobotHashIDLib)." robots\n";
	print "  ".(scalar keys %SearchEnginesHashIDLib)." search engines (and keywords/keyphrases used from them)\n";
	print "  All HTTP errors\n";
	print "  Report by day/month/year\n";
	print "  And a lot of other advanced options...\n";
	print "New versions and FAQ at http://awstats.sourceforge.net\n";
	exit 0;
}

# Get current time
$nowtime=time;
($nowsec,$nowmin,$nowhour,$nowday,$nowmonth,$nowyear) = localtime($nowtime);
if ($nowyear < 100) { $nowyear+=2000; } else { $nowyear+=1900; }
$nowsmallyear=$nowyear;$nowsmallyear =~ s/^..//;
if (++$nowmonth < 10) { $nowmonth = "0$nowmonth"; }
if ($nowday < 10) { $nowday = "0$nowday"; }
if ($nowhour < 10) { $nowhour = "0$nowhour"; }
if ($nowmin < 10) { $nowmin = "0$nowmin"; }
if ($nowsec < 10) { $nowsec = "0$nowsec"; }
# Get tomorrow time (will be used to discard some record with corrupted date (future date))
($tomorrowsec,$tomorrowmin,$tomorrowhour,$tomorrowday,$tomorrowmonth,$tomorrowyear) = localtime($nowtime+86400);
if ($tomorrowyear < 100) { $tomorrowyear+=2000; } else { $tomorrowyear+=1900; }
$tomorrowsmallyear=$tomorrowyear;$tomorrowsmallyear =~ s/^..//;
if (++$tomorrowmonth < 10) { $tomorrowmonth = "0$tomorrowmonth"; }
if ($tomorrowday < 10) { $tomorrowday = "0$tomorrowday"; }
if ($tomorrowhour < 10) { $tomorrowhour = "0$tomorrowhour"; }
if ($tomorrowmin < 10) { $tomorrowmin = "0$tomorrowmin"; }
if ($tomorrowsec < 10) { $tomorrowsec = "0$tomorrowsec"; }
$timetomorrow=int($tomorrowyear.$tomorrowmonth.$tomorrowday.$tomorrowhour.$tomorrowmin.$tomorrowsec);

# Read config file
&Read_Config_File;
if ($QueryString =~ /lang=/i) { $Lang=$QueryString; $Lang =~ s/.*lang=//i; $Lang =~ s/&.*//; $Lang =~ s/ .*//; }
if ($Lang eq "") { $Lang="en"; }

# Change old values of Lang into new for compatibility
if ($Lang eq "0") { $Lang="en"; }
if ($Lang eq "1") { $Lang="fr"; }
if ($Lang eq "2") { $Lang="nl"; }
if ($Lang eq "3") { $Lang="es"; }
if ($Lang eq "4") { $Lang="it"; }
if ($Lang eq "5") { $Lang="de"; }
if ($Lang eq "6") { $Lang="pl"; }
if ($Lang eq "7") { $Lang="gr"; }
if ($Lang eq "8") { $Lang="cz"; }
if ($Lang eq "9") { $Lang="pt"; }
if ($Lang eq "10") { $Lang="kr"; }

# Get the output strings
&Read_Language_Data($Lang);

# Check and correct bad parameters
&Check_Config;

# Init other parameters
if ($ENV{"GATEWAY_INTERFACE"} ne "") { $DirCgi=""; }
if (($DirCgi ne "") && !($DirCgi =~ /\/$/) && !($DirCgi =~ /\\$/)) { $DirCgi .= "/"; }
if ($DirData eq "" || $DirData eq ".") { $DirData=$DIR; }	# If not defined or chosen to "." value then DirData is current dir
if ($DirData eq "")  { $DirData="."; }						# If current dir not defined then we put it to "."
$DirData =~ s/\/$//; $DirData =~ s/\\$//;
$SiteToAnalyze=$SiteDomain;
if ($SiteToAnalyze eq "") { $SiteToAnalyze=$SiteConfig; }
$SiteToAnalyze =~ tr/A-Z/a-z/;
$SiteToAnalyzeWithoutwww = $SiteToAnalyze; $SiteToAnalyzeWithoutwww =~ s/www\.//;
if ($FirstDayOfWeek == 1) { @DOWIndex = (1,2,3,4,5,6,0); }
else { @DOWIndex = (0,1,2,3,4,5,6); }

# Print html header
&html_head;

if ($DNSLookup) { use Socket; }
$NewDNSLookup=$DNSLookup;
%monthlib =  ( "01","$Message[60]","02","$Message[61]","03","$Message[62]","04","$Message[63]","05","$Message[64]","06","$Message[65]","07","$Message[66]","08","$Message[67]","09","$Message[68]","10","$Message[69]","11","$Message[70]","12","$Message[71]" );
# monthnum must be in english because it's used to translate log date in apache log files which are always in english
%monthnum =  ( "Jan","01","jan","01","Feb","02","feb","02","Mar","03","mar","03","Apr","04","apr","04","May","05","may","05","Jun","06","jun","06","Jul","07","jul","07","Aug","08","aug","08","Sep","09","sep","09","Oct","10","oct","10","Nov","11","nov","11","Dec","12","dec","12" );

# Check year and month parameters
if ($QueryString =~ /year=/i) 	{ $YearRequired=$QueryString; $YearRequired =~ s/.*year=//; $YearRequired =~ s/&.*//;  $YearRequired =~ s/ .*//; }
if ($YearRequired !~ /^[\d][\d][\d][\d]$/) { $YearRequired=$nowyear; }
if ($QueryString =~ /month=/i)	{ $MonthRequired=$QueryString; $MonthRequired =~ s/.*month=//; $MonthRequired =~ s/&.*//; $MonthRequired =~ s/ .*//; }
if ($MonthRequired ne "year" && $MonthRequired !~ /^[\d][\d]$/) { $MonthRequired=$nowmonth; }

$BrowsersHashIDLib{"netscape"}="<font color=blue>Netscape</font> <a href=\"$DirCgi$PROG.$Extension?output=browserdetail&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">($Message[58])</a>";
$BrowsersHashIDLib{"msie"}="<font color=blue>MS Internet Explorer</font> <a href=\"$DirCgi$PROG.$Extension?output=browserdetail&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">($Message[58])</a>";

# Init all global variables
if (! @HostAliases) {
	warning("Warning: HostAliases parameter is not defined, $PROG choose \"$SiteToAnalyze localhost 127.0.0.1\".");
	$HostAliases[0]="$SiteToAnalyze"; $HostAliases[1]="localhost"; $HostAliases[2]="127.0.0.1";
}
my $SiteToAnalyzeIsInHostAliases=0;
foreach my $elem (@HostAliases) { if ($elem eq $SiteToAnalyze) { $SiteToAnalyzeIsInHostAliases=1; last; } }
if ($SiteToAnalyzeIsInHostAliases == 0) { $HostAliases[@HostAliases]=$SiteToAnalyze; }
if (! @SkipFiles) { $SkipFiles[0]="\.css\$";$SkipFiles[1]="\.js\$";$SkipFiles[2]="\.class\$";$SkipFiles[3]="robots\.txt\$"; }
$LastLine=0;$FirstTime=0;$LastTime=0;$LastUpdate=0;$TotalVisits=0;$TotalHostsKnown=0;$TotalHostsUnKnown=0;$TotalUnique=0;$TotalDifferentPages=0;
for (my $ix=1; $ix<=12; $ix++) {
	my $monthix=$ix;if ($monthix < 10) { $monthix  = "0$monthix"; }
	$LastLine{$YearRequired.$monthix}=0;$FirstTime{$YearRequired.$monthix}=0;$LastTime{$YearRequired.$monthix}=0;$LastUpdate{$YearRequired.$monthix}=0;
	$MonthVisits{$YearRequired.$monthix}=0;$MonthUnique{$YearRequired.$monthix}=0;$MonthPages{$YearRequired.$monthix}=0;$MonthHits{$YearRequired.$monthix}=0;$MonthBytes{$YearRequired.$monthix}=0;$MonthHostsKnown{$YearRequired.$monthix}=0;$MonthHostsUnKnown{$YearRequired.$monthix}=0;
}
&Init_HashArray;	# Should be useless in perl (except with mod_perl that keep variables in memory).


#------------------------------------------
# UPDATE PROCESS
#------------------------------------------

if ($UpdateStats) {
	&debug("Start Update process");

	# GENERATING PerlParsingFormat
	#------------------------------------------
	# Log example records
	# 62.161.78.73 user - [dd/mmm/yyyy:hh:mm:ss +0000] "GET / HTTP/1.1" 200 1234 "http://www.from.com/from.htm" "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"
	# my.domain.com - user [09/Jan/2001:11:38:51 -0600] "OPTIONS /mime-tmp/xxx file.doc HTTP/1.1" 408 - "-" "-"
    # 2000-07-19 14:14:14 62.161.78.73 - GET / 200 1234 HTTP/1.1 Mozilla/4.0+(compatible;+MSIE+5.01;+Windows+NT+5.0) http://www.from.com/from.htm
	# 05/21/00	00:17:31	OK  	200	212.242.30.6	Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)	http://www.cover.dk/	"www.cover.dk"	:Documentation:graphics:starninelogo.white.gif	1133
	$LogFormatString=$LogFormat;
	if ($LogFormat == 1) { $LogFormatString="%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\""; }
	if ($LogFormat == 2) { $LogFormatString="date time c-ip cs-username cs-method cs-uri-stem sc-status sc-bytes cs-version cs(User-Agent) cs(Referer)"; }
	if ($LogFormat == 4) { $LogFormatString="%h %l %u %t \"%r\" %>s %b"; }
	&debug("Generate PerlParsingFormat from LogFormatString=$LogFormatString");
	$PerlParsingFormat="";
	if ($LogFormat == 1) {
		$PerlParsingFormat="([^\\s]*) ([^\\s]*) [^\\s]* \\[([^\\s]*) [^\\s]*\\] \\\"([^\\s]*) ([^\\s]*) [^\\\"]*\\\" ([\\d|-]*) ([\\d|-]*) \\\"([^\\\"]*)\\\" \\\"([^\\\"]*)\\\"";
		$pos_rc=1;$pos_logname=2;$pos_date=3;$pos_method=4;$pos_url=5;$pos_code=6;$pos_size=7;$pos_referer=8;$pos_agent=9;
		$lastrequiredfield=9;
	}
	if ($LogFormat == 2) {
		$PerlParsingFormat="([^\\s]* [^\\s]*) ([^\\s]*) ([^\\s]*) ([^\\s]*) ([^\\s]*) ([\\d|-]*) ([\\d|-]*) [^\\s]* ([^\\s]*) ([^\\s]*)";
		$pos_date=1;$pos_rc=2;$pos_logname=3;$pos_method=4;$pos_url=5;$pos_code=6;$pos_size=7;$pos_agent=8;$pos_referer=9;
		$lastrequiredfield=9;
	}
	if ($LogFormat == 3) {
		$PerlParsingFormat="([^\\t]*\\t[^\\t]*)\\t([^\\t]*)\\t([\\d]*)\\t([^\\t]*)\\t([^\\t]*)\\t([^\\t]*)\\t[^\\t]*\\t.*:([^\\t]*)\\t([\\d]*)";
		$pos_date=1;$pos_method=2;$pos_code=3;$pos_rc=4;$pos_agent=5;$pos_referer=6;$pos_url=7;$pos_size=8;
		$lastrequiredfield=8;
	}
	if ($LogFormat == 4) {
		$PerlParsingFormat="([^\\s]*) ([^\\s]*) [^\\s]* \\[([^\\s]*) [^\\s]*\\] \\\"([^\\s]*) ([^\\s]*) [^\\\"]*\\\" ([\\d|-]*) ([\\d|-]*)";
		$pos_rc=1;$pos_logname=2;$pos_date=3;$pos_method=4;$pos_url=5;$pos_code=6;$pos_size=7;
		$lastrequiredfield=7;
	}
	if ($LogFormat != 1 && $LogFormat != 2 && $LogFormat != 3 && $LogFormat != 4) {
		# Scan $LogFormat to found all required fields and generate PerlParsing
		my @fields = split(/ +/, $LogFormatString); # make array of entries
		$i = 1;
		foreach $f (@fields) {
			$found=0;
			if ($f =~ /%host$/ || $f =~ /%h$/ || $f =~ /c-ip$/) {
				$found=1; 
				$pos_rc = $i; $i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%logname$/ || $f =~ /%l$/ || $f =~ /cs-username$/) {
				$found=1; 
				$pos_logname = $i; $i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%time1$/ || $f =~ /%t$/) {
				$found=1; 
				$pos_date = $i;
				$i++;
				#$pos_zone = $i;
				$i++;
				$PerlParsingFormat .= "\\[([^\\s]*) ([^\\s]*)\\] ";
			}
			if ($f =~ /%time2$/) {
				$found=1; 
				$pos_date = $i;
				$i++;
				$PerlParsingFormat .= "([^\\s]* [^\\s]*) ";
			}
			if ($f =~ /%methodurl$/ || $f =~ /\\"%r\\"/) {
				$found=1; 
				$pos_method = $i;
				$i++;
				$pos_url = $i;
				$i++;
				$PerlParsingFormat .= "\\\"([^\\s]*) ([^\\s]*) [^\\\"]*\\\" ";
			}
			if ($f =~ /%methodurlnoprot$/) {
				$found=1; 
				$pos_method = $i;
				$i++;
				$pos_url = $i;
				$i++;
				$PerlParsingFormat .= "\\\"([^\\s]*) ([^\\s]*)\\\" ";
			}
			if ($f =~ /%method$/ || $f =~ /cs-method$/) {
				$found=1; 
				$pos_method = $i;
				$i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%url$/ || $f =~ /cs-uri-stem$/) {
				$found=1; 
				$pos_url = $i;
				$i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%query$/ || $f =~ /cs-uri-query$/) {
				$found=1; 
				$pos_query = $i;
				$i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%code$/ || $f =~ /%.*>s$/ || $f =~ /sc-status$/) {
				$found=1; 
				$pos_code = $i;
				$i++;
				$PerlParsingFormat .= "([\\d|-]*) ";
			}
			if ($f =~ /%bytesd$/ || $f =~ /%b$/ || $f =~ /sc-bytes$/) {
				$found=1; 
				$pos_size = $i; $i++;
				$PerlParsingFormat .= "([\\d|-]*) ";
			}
			if ($f =~ /%refererquot$/ || $f =~ /\\"%{Referer}i\\"/) {
				$found=1;
				$pos_referer = $i; $i++;
				$PerlParsingFormat .= "\\\"([^\\\"]*)\\\" ";
			}
			if ($f =~ /%referer$/ || $f =~ /cs\(Referer\)/) {
				$found=1;
				$pos_referer = $i; $i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%uaquot$/ || $f =~ /\\"%{User-Agent}i\\"/) {
				$found=1; 
				$pos_agent = $i; $i++;
				$PerlParsingFormat .= "\\\"([^\\\"]*)\\\" ";
			}
			if ($f =~ /%ua$/ || $f =~ /cs\(User-Agent\)/) {
				$found=1; 
				$pos_agent = $i; $i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%gzipin$/ ) {
				$found=1;
				$gzipin=$i;$i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%gzipout$/ ) {
				$found=1;
				$gzipout=$i;$i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if ($f =~ /%gzipres$/ ) {
				$found=1;
				$gzipres=$i;$i++;
				$PerlParsingFormat .= "([^\\s]*) ";
			}
			if (! $found) { $found=1; $PerlParsingFormat .= "[^\\s]* "; }
		}
		($PerlParsingFormat) ? chop($PerlParsingFormat) : error("Error: no recognised format commands in personalised LogFormat string"); 
		$lastrequiredfield=$i--;
	}
	if ($pos_rc eq "") { error("Error: Your personalised LogFormat does not include all fields required by AWStats (Add \%host in your LogFormat string)."); }
	if ($pos_date eq "") { error("Error: Your personalised LogFormat does not include all fields required by AWStats (Add \%time1 or \%time2 in your LogFormat string)."); }
	if ($pos_method eq "") { error("Error: Your personalised LogFormat does not include all fields required by AWStats (Add \%methodurl or \%method in your LogFormat string)."); }
	if ($pos_url eq "") { error("Error: Your personalised LogFormat does not include all fields required by AWStats (Add \%methodurl or \%url in your LogFormat string)."); }
	if ($pos_code eq "") { error("Error: Your personalised LogFormat does not include all fields required by AWStats (Add \%code in your LogFormat string)."); }
	if ($pos_size eq "") { error("Error: Your personalised LogFormat does not include all fields required by AWStats (Add \%bytesd in your LogFormat string)."); }
	&debug("PerlParsingFormat is $PerlParsingFormat");


	# READING THE LAST PROCESSED HISTORY FILE
	#------------------------------------------
	# Search last file
	opendir(DIR,"$DirData");
	@filearray = sort readdir DIR;
	close DIR;
	my $yearmonthmax=0;
	foreach $i (0..$#filearray) {
		if ("$filearray[$i]" =~ /^$PROG([\d][\d])([\d][\d][\d][\d])$FileSuffix\.txt$/) {
			if (int("$2$1") > $yearmonthmax) { $yearmonthmax=int("$2$1"); }
		}
	}
	my $monthtoprocess=0; my $yeartoprocess=0;
	if ($yearmonthmax =~ /^([\d][\d][\d][\d])([\d][\d])$/) {		# We found last history file
		$monthtoprocess=int($2);$yeartoprocess=int($1);
		# We read LastTime in this last history file.
		&Read_History_File($yeartoprocess,$monthtoprocess,1);
	}


	# PROCESSING CURRENT LOG
	#------------------------------------------
	&debug("Start of processing log file (monthtoprocess=$monthtoprocess, yeartoprocess=$yeartoprocess)");
	my $yearmonth=sprintf("%04i%02i",$yeartoprocess,$monthtoprocess);
	$NbOfLinesRead=0; $NbOfNewLinesProcessed=0; $NbOfLinesCorrupted=0;
	$NowNewLinePhase=0;

	# Open log file
	&debug("Open log file \"$LogFile\"");
	open(LOG,"$LogFile") || error("Error: Couldn't open server log file \"$LogFile\" : $!");

	$starttime=time();
	while (<LOG>)
	{
		if (/^#/) { next; }									# Ignore comment lines (ISS writes such comments)
		if (/^!/) { next; }									# Ignore comment lines (Webstar writes such comments)
		#if (/^$/) { next; }								# Ignore blank lines (With ISS: happens sometimes, with Apache: possible when editing log file)
		chomp $_; s/\r//;

		$NbOfLinesRead++;

		# Parse line record to get all required fields
		/^$PerlParsingFormat/;
		my @field=();
		foreach $i (1..$lastrequiredfield) { $field[$i]=$$i; }
 		&debug(" Record $NbOfLinesRead is ($lastrequiredfield fields read) : $field[$pos_rc] ; $field[$pos_logname] ; - ; $field[$pos_date] ; TZ; $field[$pos_method] ; $field[$pos_url] ; $field[$pos_code] ; $field[$pos_size] ; $field[$pos_referer] ; $field[$pos_agent]",3);

		# Check parsed parameters
		#----------------------------------------------------------------------
		if ($field[$pos_code] eq "") {
			$NbOfLinesCorrupted++;
			if ($NbOfLinesRead >= $NbOfLinesForCorruptedLog && $NbOfLinesCorrupted == $NbOfLinesRead) { error("Format error",$_,$LogFile); }	# Exit with format error
			next;
		}

		# Check filters
		#----------------------------------------------------------------------
		if ($field[$pos_method] ne 'GET' && $field[$pos_method] ne 'POST' && $field[$pos_method] !~ /OK/) { next; }	# Keep only GET, POST (OK with Webstar) but not HEAD, OPTIONS
		#if ($field[$pos_url] =~ /^RC=/) { $NbOfLinesCorrupted++; next; }			# A strange log record with IIS we need to forget
		# Split DD/Month/YYYY:HH:MM:SS or YYYY-MM-DD HH:MM:SS or MM/DD/YY\tHH:MM:SS
		$field[$pos_date] =~ tr/-\/ \t/::::/;
		my @dateparts=split(/:/,$field[$pos_date]);
		if ($field[$pos_date] =~ /^....:..:..:/) { $tmp=$dateparts[0]; $dateparts[0]=$dateparts[2]; $dateparts[2]=$tmp; }
		if ($field[$pos_date] =~ /^..:..:..:/) { $dateparts[2]+=2000; $tmp=$dateparts[0]; $dateparts[0]=$dateparts[1]; $dateparts[1]=$tmp; }
		if ($monthnum{$dateparts[1]}) { $dateparts[1]=$monthnum{$dateparts[1]}; }	# Change lib month in num month if necessary
		# Create $timeconnexion like YYYYMMDDHHMMSS
		my $timeconnexion=int($dateparts[2].$dateparts[1].$dateparts[0].$dateparts[3].$dateparts[4].$dateparts[5]);
		my $dayconnexion=$dateparts[2].$dateparts[1].$dateparts[0];
		if ($timeconnexion < 10000000000000) { $NbOfLinesCorrupted++; next; }		# Should not happen, kept in case of parasite/corrupted line
		if ($timeconnexion > $timetomorrow) { $NbOfLinesCorrupted++; next; }		# Should not happen, kept in case of parasite/corrupted line

		# Skip if not a new line
		#-----------------------
		if ($NowNewLinePhase) {
			if ($timeconnexion < $LastLine{$yearmonth}) { $NbOfLinesCorrupted++; next; }	# Should not happen, kept in case of parasite/corrupted old line
		}
		else {
			if ($timeconnexion <= $LastLine{$yearmonth}) {
				if ($ShowSteps && ($NbOfLinesRead % $NbOfLinesForBenchmark == 0)) { print "$NbOfLinesRead lines read already processed (".(time()-$starttime)." seconds, ".($NbOfLinesRead/(time()-$starttime+1))." lines/seconds)\n"; }
				next;
			}	# Already processed
			# We found a new line. This will stop comparison "<=" between timeconnexion and LastLine (we should have only new lines now)
			$NowNewLinePhase=1;	
		}

		# Here, field array, datepart array, timeconnexion and dayconnexion are init for log record
		&debug(" This is a not already processed record",3);

		# Record is approved. We found a new line
		#----------------------------------------
		$NbOfNewLinesProcessed++;
		if ($ShowSteps && ($NbOfNewLinesProcessed % $NbOfLinesForBenchmark == 0)) { print "$NbOfNewLinesProcessed lines processed (".(time()-$starttime)." seconds, ".($NbOfNewLinesProcessed/(time()-$starttime+1))." lines/seconds)\n"; }

		$LastLine{$yearmonth} = $timeconnexion;

		if (&SkipHost($field[$pos_rc])) { next; }		# Skip with some client host IP addresses
		if (&SkipFile($field[$pos_url])) { next; }		# Skip with some URLs
		if (! &OnlyFile($field[$pos_url])) { next; }	# Skip with other URLs

		# Is it in a new month section ?
		#-------------------------------
		if (((int($dateparts[1]) > $monthtoprocess) && (int($dateparts[2]) >= $yeartoprocess)) || (int($dateparts[2]) > $yeartoprocess)) {
			# Yes, a new month to process
			if ($monthtoprocess > 0) {
				&Save_History_File($yeartoprocess,$monthtoprocess);		# We save data of current processed month
 				&Init_HashArray($yeartoprocess,$monthtoprocess);		# Start init for next one
			}
			$monthtoprocess=int($dateparts[1]);$yeartoprocess=int($dateparts[2]);
			$yearmonth=sprintf("%04i%02i",$yeartoprocess,$monthtoprocess);
			&Read_History_File($yeartoprocess,$monthtoprocess,1);		# This should be useless (file must not exist)
		}

		# Check return code
		#------------------
		if (($field[$pos_code] != 200) && ($field[$pos_code] != 304)) {	# Stop if HTTP server return code != 200 and 304
			if ($field[$pos_code] =~ /^[\d][\d][\d]$/) { 				# Keep error code and next
				$_errors_h{$field[$pos_code]}++;
				if ($field[$pos_code] == 404) { $_sider404_h{$field[$pos_url]}++; $_referer404_h{$field[$pos_url]}=$field[$pos_referer]; }
				next;
			}
			else {														# Bad format record (should not happen but when using MSIndex server), next
				$NbOfLinesCorrupted++; next;
			}
		}

		$field[$pos_agent] =~ tr/\+ /__/;		# Same Agent with different writing syntax have now same name
		$UserAgent = $field[$pos_agent];
		$UserAgent =~ tr/A-Z/a-z/;

		# Robot ? If yes, we stop here
		#-----------------------------
		if (!$TmpHashNotRobot{$UserAgent}) {	# TmpHashNotRobot is a temporary hash table to increase speed

			# study $UserAgent

			my $foundrobot=0;
			foreach $bot (keys %RobotHashIDLib) { if ($UserAgent =~ /$bot/) { $_robot_h{$bot}++; $_robot_l{$bot}=$timeconnexion; $foundrobot=1; last; }	}
			if ($foundrobot == 1) { next; }
			$TmpHashNotRobot{$UserAgent}=1;		# Last time, we won't search if robot or not. We know it's not.
		}

		# Canonize and clean target URL and referrer URL
		my $urlwithnoquery;
		if ($URLWithQuery) { 				
			$urlwithnoquery=$field[$pos_url];
			$urlwithnoquery =~ s/\?.*//;
			# We combine the URL and query strings.
			if ($field[$pos_query] && ($field[$pos_query] ne "-")) { $field[$pos_url] .= "?" . $field[$pos_query]; }
		}
		else {
			# Trunc CGI parameters in URL
			$field[$pos_url] =~ s/\?.*//;
			$urlwithnoquery=$field[$pos_url];
		}
		$field[$pos_url] =~ s/\/$DefaultFile$/\//;	# Replace default page name with / only
		$field[$pos_url] =~ s/\/\//\//g;			# Because some targeted url were taped with 2 / (Ex: //rep//file.htm)

		# Analyze file type and compression
		#----------------------------------
		my $PageBool=1;
		my $extension;

		# Extension
		$found=0;
		if ($urlwithnoquery =~ /\.(...)$/)     { $found=1; }
		elsif ($urlwithnoquery =~ /\.(....)$/) { $found=1; }
		elsif ($urlwithnoquery =~ /\.(..)$/)   { $found=1; }
		elsif ($urlwithnoquery =~ /\.(.)$/)    { $found=1; }
		if ($found) {
			$extension=$1; $extension =~ tr/A-Z/a-z/;
			# Check if not a page
			foreach $cursor (@NotPageList) { if ($extension =~ /$cursor/i) { $PageBool=0; last; } }
		} else {
			$extension="Unknown";
		}
		$_filetypes_h{$extension}++;
		$_filetypes_k{$extension}+=$field[$pos_size];
		# Compression
		if ($field[$gzipin]) {
			my($a,$b)=split(":",$field[$gzipres]);
			my(undef,$in)=split(":",$field[$gzipin]);
			my(undef,$out,undef)=split(":",$field[$gzipout]);
			if ($out) {
				$_filetypes_gz_in{$extension}+=$in;
				$_filetypes_gz_out{$extension}+=$out;
			}
		}

		# Analyze: Date - Hour - Pages - Hits - Kilo
		#-------------------------------------------
		if ($PageBool) {
			# FirstTime and LastTime are First and Last human visits (so changed if access to a page)
			if (! $FirstTime{$yearmonth}) { $FirstTime{$yearmonth}=$timeconnexion; }
			$LastTime{$yearmonth} = $timeconnexion;
			$DayPages{$dayconnexion}++;
			$MonthPages{$yearmonth}++;
			$_time_p[int($dateparts[3])]++;												#Count accesses for hour (page)
			$_sider_p{$field[$pos_url]}++; 												#Count accesses for page (page)
			}
		$_time_h[int($dateparts[3])]++; $MonthHits{$yearmonth}++; $DayHits{$dayconnexion}++;	#Count accesses for hour (hit)
		$_time_k[int($dateparts[3])]+=$field[$pos_size]; $MonthBytes{$yearmonth}+=$field[$pos_size]; $DayBytes{$dayconnexion}+=$field[$pos_size];	#Count accesses for hour (kb)
		$_sider_h{$field[$pos_url]}++;													#Count accesses for page (hit)
		$_sider_k{$field[$pos_url]}+=$field[$pos_size];									#Count accesses for page (kb)

		# Analize login
		#--------------
		if ($field[$pos_logname] && $field[$pos_logname] ne "-") {
			# We found an authenticated user
			if ($PageBool) {
				$_login_p{$field[$pos_logname]}++;										#Count accesses for page (page)
			}
			$_login_h{$field[$pos_logname]}++;											#Count accesses for page (hit)
			$_login_k{$field[$pos_logname]}+=$field[$pos_size];							#Count accesses for page (kb)
			$_login_l{$field[$pos_logname]}=$timeconnexion;
		}

		# Analyze: IP-address
		#--------------------
		$found=0;
		$Host=$field[$pos_rc];
		if ($Host =~ /^[\d]+\.[\d]+\.[\d]+\.[\d]+$/) {
			my $newip;
			# Doing DNS lookup
		    if ($NewDNSLookup) {
				$newip=$TmpHashDNSLookup{$Host};	# TmpHashDNSLookup is a temporary hash table to increase speed
				if (!$newip) {						# if $newip undefined, $Host not yet resolved
					&debug("Start of reverse DNS lookup for $Host",4);
					if ($MyDNSTable{$Host}) {
						&debug("End of reverse DNS lookup, found resolution of $Host in local MyDNSTable",4);
	  					$newip = $MyDNSTable{$Host};
					}
					else {
						if (&SkipDNSLookup($Host)) {
							&debug("Skip this DNS lookup at user request",4);
						}
						else {
							$newip=gethostbyaddr(pack("C4",split(/\./,$Host)),AF_INET);	# This is very slow, may took 20 seconds
						}
						&debug("End of reverse DNS lookup for $Host",4);
					}
					if ($newip eq "") { $newip="ip"; }
					$TmpHashDNSLookup{$Host}=$newip;
				}
				# Here $Host is still xxx.xxx.xxx.xxx and $newip is name or "ip" if reverse failed)
				if ($newip ne "ip") { $Host=$newip; }
			}
		    # If we don't do lookup or if it failed, we still have an IP address in $Host
		    if (!$NewDNSLookup || $newip eq "ip") {
				  if ($PageBool) {
				  		if ($timeconnexion > ($_unknownip_l{$Host}+$VisitTimeOut)) { $MonthVisits{$yearmonth}++; }
						if (! $_unknownip_l{$Host}) { $MonthUnique{$yearmonth}++; $MonthHostsUnknown{$yearmonth}++; }
						$_unknownip_l{$Host}=$timeconnexion;		# Table of (all IP if !NewDNSLookup) or (all unknown IP) else
						$_hostmachine_p{"Unknown"}++;
						$_domener_p{"ip"}++;
				  }
				  $_hostmachine_h{"Unknown"}++;
				  $_domener_h{"ip"}++;
				  $_hostmachine_k{"Unknown"}+=$field[$pos_size];
				  $_domener_k{"ip"}+=$field[$pos_size];
				  $found=1;
		      }
		}
		else {
			if ($Host =~ /[a-z]/) { 
				&debug("The following hostname '$Host' seems to be already resolved.",3);
				$NewDNSLookup=0;
			}
		}	# Hosts seems to be already resolved, make DNS lookup inactive

		# Here, $Host = hostname or xxx.xxx.xxx.xxx
		if (!$found) {	# If not processed yet
			# Here $Host = hostname
			$_ = $Host;
			tr/A-Z/a-z/;

			# Count hostmachine
			if (!$FullHostName) { s/^[\w\-]+\.//; };
			if ($PageBool) {
				if ($timeconnexion > ($_hostmachine_l{$_}+$VisitTimeOut)) { $MonthVisits{$yearmonth}++; }
				if (! $_hostmachine_l{$_}) { $MonthUnique{$yearmonth}++; }
				$_hostmachine_p{$_}++;
				$_hostmachine_l{$_}=$timeconnexion;
				}
			if (! $_hostmachine_h{$_}) { $MonthHostsKnown{$yearmonth}++; }
			$_hostmachine_h{$_}++;
			$_hostmachine_k{$_}+=$field[$pos_size];

			# Count top-level domain
			if (/\.([\w]+)$/) { $_=$1; }
			if ($DomainsHashIDLib{$_}) {
				 if ($PageBool) { $_domener_p{$_}++; }
				 $_domener_h{$_}++;
				 $_domener_k{$_}+=$field[$pos_size];
				 }
			else {
				 if ($PageBool) { $_domener_p{"ip"}++; }
				 $_domener_h{"ip"}++;
				 $_domener_k{"ip"}+=$field[$pos_size];
			}
		}

		if ($UserAgent) {

			# Analyze: Browser
			#-----------------
			my $found=0;
			if (!$TmpHashBrowser{$UserAgent}) {
				# IE ? (For higher speed, we start whith IE, the most often used. This avoid other tests if found)
				if ($UserAgent =~ /msie/) {
					if (($UserAgent !~ /webtv/) && ($UserAgent !~ /omniweb/) && ($UserAgent !~ /opera/)) {
						$_browser_h{"msie"}++;
						if ($UserAgent =~ /msie_(\d)\./) {  # $1 now contains major version no
							$_msiever_h[$1]++;
							$found=1;
							$TmpHashBrowser{$UserAgent}="msie_$1";
						}
					}
				}
		
				# Netscape ?
				if (!$found) {
					if (($UserAgent =~ /mozilla/) && ($UserAgent !~ /compatible/) && ($UserAgent !~ /opera/)) {
				    	$_browser_h{"netscape"}++;
				    	if ($UserAgent =~ /\/(\d)\./) {		# $1 now contains major version no
				    		$_nsver_h[$1]++;
				    		$found=1;
							$TmpHashBrowser{$UserAgent}="netscape_$1";
						}
					}
				}
		
				# Other ?
				if (!$found) {
					foreach my $key (@BrowsersArrayID) {
				    	if ($UserAgent =~ /$key/) { $_browser_h{$key}++; $found=1; $TmpHashBrowser{$UserAgent}=$key; last; }
					}
				}
	
				# Unknown browser ?
				if (!$found) { $_browser_h{"Unknown"}++; $_unknownrefererbrowser_l{$field[$pos_agent]}=$timeconnexion; }
			}
			else {
				if ($TmpHashBrowser{$UserAgent} =~ /^msie_(\d)/) { $_browser_h{"msie"}++; $_msiever_h[$1]++; $found=1; }
				if (!$found && $TmpHashBrowser{$UserAgent} =~ /^netscape_(\d)/) { $_browser_h{"netscape"}++; $_nsver_h[$1]++; $found=1; }
				if (!$found) { $_browser_h{$TmpHashBrowser{$UserAgent}}++; }
			}

			# Analyze: OS
			#------------
			if (!$TmpHashOS{$UserAgent}) {
				my $found=0;
				# in OSHashID list ?
				foreach my $key (@OSArrayID) {	# Searchin ID in order of OSArrayID
					if ($UserAgent =~ /$key/) { $_os_h{$OSHashID{$key}}++; $TmpHashOS{$UserAgent}=$OSHashID{$key}; $found=1; last; }
				}
				# Unknown OS ?
				if (!$found) { $_os_h{"Unknown"}++; $_unknownreferer_l{$field[$pos_agent]}=$timeconnexion; }
			}
			else {
				$_os_h{$TmpHashOS{$UserAgent}}++;
			}
		}
		else {
			$_browser_h{"Unknown"}++;
			$_os_h{"Unknown"}++;
		}		

		# Analyze: Referer
		#-----------------
		my $found=0;
		if ($field[$pos_referer]) {

			# Direct ?
			if ($field[$pos_referer] eq "-") { 
				if ($PageBool) { $_from_p[0]++; }
				$_from_h[0]++;
				$found=1;
			}
			else {	
				# HTML link ?
				if ($field[$pos_referer] =~ /^http/i) {
					$internal_link=0;
					if ($field[$pos_referer] =~ /^http(s|):\/\/(www\.|)$SiteToAnalyzeWithoutwww/i) { $internal_link=1; }
					else {
						foreach $HostAlias (@HostAliases) {
							if ($field[$pos_referer] =~ /^http(s|):\/\/$HostAlias/i) { $internal_link=1; last; }
							}
					}
	
					if ($internal_link) {
					    # Intern (This hit came from another page of the site)
						if ($PageBool) { $_from_p[4]++; }
					    $_from_h[4]++;
						$found=1;
					}
					else {
					    # Extern (This hit came from an external web site)
						my @refurl=split(/\?/,$field[$pos_referer]);
						$refurl[0] =~ tr/A-Z/a-z/;
					    foreach my $key (keys %SearchEnginesHashIDLib) {
							if ($refurl[0] =~ /$key/) {
								# This hit came from the search engine $key
								if ($PageBool) { $_from_p[2]++; }
								$_from_h[2]++;
								$_se_referrals_h{$key}++;
								$found=1;
								# Extract keywords
								$refurl[1] =~ tr/A-Z/a-z/;				# Full param string in lowcase
								my @paramlist=split(/&/,$refurl[1]);
								if ($SearchEnginesKnownUrl{$key}) {		# Search engine with known URL syntax
									foreach my $param (@paramlist) {
										if ($param =~ /^$SearchEnginesKnownUrl{$key}/) { # We found good parameter
											&UnescapeURLParam($param);			# Change [ xxx=cache:www/zzz+aaa+bbb/ccc+ddd%20eee'fff ] into [ xxx=cache:www/zzz aaa bbb/ccc ddd eee fff ]
											# Ok, "xxx=cache:www/zzz aaa bbb/ccc ddd eee fff" is a search parameter line
											$param =~ s/.*=//;					# Cut "xxx="
											$param =~ s/^cache:[^ ]* //;
											$param =~ s/^related:[^ ]* //;
											if ($SplitSearchString) {
												my @wordlist=split(/ /,$param);	# Split aaa bbb ccc ddd eee fff into a wordlist array
												foreach $word (@wordlist) {
													if ((length $word) > 0) { $_keyphrases{$word}++; }
												}
											}
											else {
												$param =~ s/^ *//; $param =~ s/ *$//; $param =~ tr/ / /s;
												if ((length $param) > 0) { $param =~ tr/ /+/; $_keyphrases{$param}++; }
											}
											last;
										}
									}
								}
								else {									# Search engine with unknown URL syntax
									foreach my $param (@paramlist) {
										&UnescapeURLParam($param);				# Change [ xxx=cache:www/zzz+aaa+bbb/ccc+ddd%20eee'fff ] into [ xxx=cache:www/zzz aaa bbb/ccc ddd eee fff ]
										my $foundparam=1;
										foreach $paramtoexclude (@WordsToCleanSearchUrl) {
											if ($param =~ /.*$paramtoexclude.*/) { $foundparam=0; last; } # Not the param with search criteria
										}
										if ($foundparam == 0) { next; }			# Do not keep this URL parameter because is in exclude list
										# Ok, "xxx=cache:www/zzz aaa bbb/ccc ddd eee fff" is a search parameter line
										$param =~ s/.*=//;						# Cut "xxx="
										$param =~ s/^cache:[^ ]* //;
										$param =~ s/^related:[^ ]* //;
										if ($SplitSearchString) {
											my @wordlist=split(/ /,$param);		# Split aaa bbb ccc ddd eee fff into a wordlist array
											foreach $word (@wordlist) {
												if ((length $word) > 2) { $_keyphrases{$word}++; }	# Keep word only if word length is 3 or more
											}
										}
										else {
											$param =~ s/^ *//; $param =~ s/ *$//; $param =~ tr/ / /s;
											if ((length $param) > 2) { $param =~ tr/ /+/; $_keyphrases{$param}++; }
										}
									}
								}
								last;
							}
						}
						if (!$found) {
							# This hit came from a site other than a search engine
							if ($PageBool) { $_from_p[3]++; }
							$_from_h[3]++;
							if ($field[$pos_referer] =~ /http:\/\/[^\/]*\/$/i) { $field[$pos_referer] =~ s/\/$//; }	# To make htpp://www.mysite.com and http://www.mysite.com/ as same referer
							$_pagesrefs_h{$field[$pos_referer]}++;
							$found=1;
						}
					}
				}
			}
		}	

		# Origin not found
		if (!$found) {
			if ($PageBool) { $_from_p[1]++; }
			$_from_h[1]++;
		}

		# End of processing all new records.
	}
	&debug("End of processing log file(s)");

	&debug("Close log file");
	close LOG;

	# DNSLookup warning
	if ($DNSLookup && !$NewDNSLookup) { warning("Warning: <b>$PROG</b> has detected that hosts names are already resolved in your logfile <b>$LogFile</b>.<br>\nIf this is always true, you should change your setup DNSLookup=1 into DNSLookup=0 to increase $PROG speed."); }

	# Save current processed month $monthtoprocess
	if ($UpdateStats && $monthtoprocess) {	# If monthtoprocess is still 0, it means there was no history files and we found no valid lines in log file
		&Save_History_File($yeartoprocess,$monthtoprocess);		# We save data for this month,year
		if (($MonthRequired ne "year") && ($monthtoprocess != $MonthRequired)) { &Init_HashArray($yeartoprocess,$monthtoprocess); }	# Not a desired month (wrong month), so we clean data arrays
		if (($MonthRequired eq "year") && ($yeartoprocess != $YearRequired)) { &Init_HashArray($yeartoprocess,$monthtoprocess); }	# Not a desired month (wrong year), so we clean data arrays
	}

	# Archive LOG file into ARCHIVELOG
	if (($PurgeLogFile == 1) && ($ArchiveLogRecords == 1)) {
		&debug("Start of archiving log file");
		$ArchiveFileName="$DirData/${PROG}_archive$FileSuffix.log";
		open(LOG,"+<$LogFile") || error("Error: Enable to archive log records of \"$LogFile\" into \"$ArchiveFileName\" because source can't be opened for read and write: $!<br>\n");
		open(ARCHIVELOG,">>$ArchiveFileName") || error("Error: Couldn't open file \"$ArchiveFileName\" to archive current log: $!");
		while (<LOG>) {	print ARCHIVELOG $_; }
		close(ARCHIVELOG);
		chmod 0666,"$ArchiveFileName";
		&debug("End of archiving log file");
	}
	else {
		open(LOG,"+<$LogFile");
	}

	# Rename all HISTORYTMP files into HISTORYTXT
	my $allok=1;
	opendir(DIR,"$DirData");
	@filearray = sort readdir DIR;
	close DIR;
	foreach $i (0..$#filearray) {
		if ("$filearray[$i]" =~ /^$PROG([\d][\d][\d][\d][\d][\d])$FileSuffix\.tmp\..*$/) {
			if (-s "$DirData/$PROG$1$FileSuffix.tmp.$$") {	# Rename files of this session with size > 0
				if (rename("$DirData/$PROG$1$FileSuffix.tmp.$$", "$DirData/$PROG$1$FileSuffix.txt")==0) {
					$allok=0;	# At least one error in renaming working files
					# Remove file
					unlink "$DirData/$PROG$1$FileSuffix.tmp.$$";
					warning("Warning: Failed to rename \"$DirData/$PROG$1$FileSuffix.tmp.$$\" into \"$DirData/$PROG$1$FileSuffix.txt\".\nWrite permissions on \"$PROG$1$FileSuffix.txt\" might be wrong".($ENV{"GATEWAY_INTERFACE"} ne ""?" for an 'update from web'":"")." or file might be opened.");
					last;
				}
				chmod 0666,"$DirData/$PROG$1$FileSuffix.txt";
			}
		}
	}

	# Purge Log file if all renaming are ok and option is on
	if (($allok > 0) && ($PurgeLogFile == 1)) {
		truncate(LOG,0) || warning("Warning: <b>$PROG</b> couldn't purge logfile \"<b>$LogFile</b>\".<br>\nChange your logfile permissions to allow write for your web server<br>\nor change PurgeLofFile=1 into PurgeLogFile=0 in configure file<br>\n(and think to purge sometines your logile. Launch $PROG just before this to save in $PROG history text files all informations logfile contains).");
	}
	close(LOG);

}
# End of log processing



#---------------------------------------------------------------------
# SHOW REPORT
#---------------------------------------------------------------------

if ($HTMLOutput) {
	
	my @filearray;
	my %listofyears;
	my $max_p; my $max_h; my $max_k; my $max_v;
	my $rest_p; my $rest_h; my $rest_k; my $rest;
	my $total_p; my $total_h;my $total_k;

	$SiteToAnalyze =~ s/\\\./\./g;

	# Get list of all possible years
	opendir(DIR,"$DirData");
	@filearray = sort readdir DIR;
	close DIR;
	foreach my $i (0..$#filearray) {
		if ("$filearray[$i]" =~ /^$PROG([\d][\d])([\d][\d][\d][\d])$FileSuffix\.txt$/) { $listofyears{$2}=1; }
	}
	
	# Here, first part of data for processed month (old and current) are still in memory
	# If a month was already processed, then $HistoryFileAlreadyRead{"MMYYYY"} value is 1
	
	# READING NOW ALL NOT ALREADY READ HISTORY FILES FOR ALL MONTHS OF REQUIRED YEAR
	#-------------------------------------------------------------------------------
	# Loop on each month of year but only existing and not already read will be read by Read_History_File function
	for (my $ix=12; $ix>=1; $ix--) {
		my $monthix=$ix+0; if ($monthix < 10) { $monthix  = "0$monthix"; }	# Good trick to change $monthix into "MM" format
		if ($MonthRequired eq "year" || $monthix == $MonthRequired) {
			&Read_History_File($YearRequired,$monthix,1);	# Read full history file
		}
		else {
			&Read_History_File($YearRequired,$monthix,0);	# Read first part of history file is enough
		}
	}
	
	
	# Get the tooltips texts
	&Read_Language_Tooltip($Lang);
	
	# Position .style.pixelLeft/.pixelHeight/.pixelWidth/.pixelTop	IE OK	Opera OK
	#          .style.left/.height/.width/.top											Netscape OK
	# document.getElementById										IE OK	Opera OK	Netscape OK
	# document.body.offsetWidth|document.body.style.pixelWidth		IE OK	Opera OK	Netscape OK		Visible width of container
	# document.body.scrollTop                                       IE OK	Opera OK	Netscape OK		Visible width of container
	# tooltip.offsetWidth|tooltipOBJ.style.pixelWidth				IE OK	Opera OK	Netscape OK		Width of an object
	# event.clientXY												IE OK	Opera OK	Netscape KO		Return position of mouse
	print <<EOF;
	<script language="javascript">
		function ShowTooltip(fArg)
		{
			var tooltipOBJ = (document.getElementById) ? document.getElementById('tt' + fArg) : eval("document.all['tt" + fArg + "']");
			if (tooltipOBJ != null) {
			    var tooltipLft = (document.body.offsetWidth?document.body.offsetWidth:document.body.style.pixelWidth) - (tooltipOBJ.offsetWidth?tooltipOBJ.offsetWidth:(tooltipOBJ.style.pixelWidth?tooltipOBJ.style.pixelWidth:300)) - 30;
			    if (navigator.appName != 'Netscape') {
					var tooltipTop = (document.body.scrollTop>=0?document.body.scrollTop+10:event.clientY+10);
					if ((event.clientX > tooltipLft) && (event.clientY < (tooltipOBJ.scrollHeight?tooltipOBJ.scrollHeight:tooltipOBJ.style.pixelHeight) + 10)) {
						tooltipTop = (document.body.scrollTop?document.body.scrollTop:document.body.offsetTop) + event.clientY + 20;
					}
					tooltipOBJ.style.pixelLeft = tooltipLft; tooltipOBJ.style.pixelTop = tooltipTop; 
				}
				else {
					var tooltipTop = 10;
					tooltipOBJ.style.left = tooltipLft; tooltipOBJ.style.top = tooltipTop; 
				}
			    tooltipOBJ.style.visibility = "visible";
			}
		}
		function HideTooltip(fArg)
		{
			var tooltipOBJ = (document.getElementById) ? document.getElementById('tt' + fArg) : eval("document.all['tt" + fArg + "']");
			if (tooltipOBJ != null) {
			    tooltipOBJ.style.visibility = "hidden";
			}
		}
	</script>
EOF


	# MENU
	#---------------------------------------------------------------------
	if ($ShowMenu) {
		print "$CENTER<a name=\"MENU\">&nbsp;</a><BR>";
		print "<table>";
		print "<tr><th class=AWL>$Message[7] : </th><td class=AWL><font style=\"font-size: 14px;\">$SiteToAnalyze</font></th></tr>";
		print "<tr><th class=AWL valign=top>$Message[35] : </th>";
		print "<td class=AWL><font style=\"font-size: 14px;\">";
		foreach my $key (sort keys %LastUpdate) { if ($LastUpdate < $LastUpdate{$key}) { $LastUpdate = $LastUpdate{$key}; } }
		if ($LastUpdate) { print Format_Date($LastUpdate); }
		else { print "<font color=#880000>Never updated</font>"; }
		print "</font>&nbsp; &nbsp; &nbsp; &nbsp;";
		if ($AllowToUpdateStatsFromBrowser) { print "<a href=\"$DirCgi$PROG.$Extension?update=1&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[74]</a>"; }
		print "</td></tr>\n";
		if ($QueryString !~ /output=/i) {	# If main page asked
			print "<tr><td>&nbsp;</td></tr>\n";
			# When
			print "<tr><th class=AWL>$Message[93] : </th>";
			print "<td class=AWL>";
			if ($ShowMonthDayStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#SUMMARY\">$Message[5]/$Message[4]</a> &nbsp; "; }
			if ($ShowDaysOfWeekStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#DAYOFWEEK\">$Message[91]</a> &nbsp; "; }
			if ($ShowHoursStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#HOUR\">$Message[20]</a> &nbsp; "; }
			# Who
			print "<tr><th class=AWL>$Message[92] : </th>";
			print "<td class=AWL>";
			if ($ShowDomainsStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#DOMAINS\">$Message[17]</a> &nbsp; "; }
			if ($ShowHostsStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#VISITOR\">".ucfirst($Message[26])."</a> &nbsp; "; }
			if ($ShowHostsStats) { print "<a href=\"$DirCgi$PROG.$Extension?output=unknownip&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[45]</a> &nbsp;\n"; }
			if ($ShowAuthenticatedUsers) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#LOGIN\">$Message[94]</a> &nbsp; "; }
			if ($ShowRobotsStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#ROBOTS\">$Message[53]</a> &nbsp; "; }
			print "<br></td></tr>";
			# Navigation
			print "<tr><th class=AWL>$Message[72] : </th>";
			print "<td class=AWL>";
			if ($ShowPagesStats) { print "<a href=\"$DirCgi$PROG.$Extension?output=urldetail&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[19]</a> &nbsp; "; }
			if ($ShowFileTypesStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#FILETYPES\">$Message[73]</a> &nbsp; "; }
			if ($ShowFileSizesStats) {  }
			if ($ShowOSStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#OS\">$Message[59]</a> &nbsp; "; }
			if ($ShowBrowsersStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#BROWSER\">$Message[21]</a> &nbsp; "; }
			if ($ShowBrowsersStats) { print "<a href=\"$DirCgi$PROG.$Extension?output=browserdetail&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[33]</a> &nbsp; "; }
			if ($ShowBrowsersStats) { print "<a href=\"$DirCgi$PROG.$Extension?output=browserdetail&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[34]</a><br></td></tr>\n"; }
			# Referers
			print "<tr><th class=AWL>$Message[23] : </th>";
			print "<td class=AWL>";
			if ($ShowOriginStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#REFERER\">$Message[37]</a> &nbsp; "; }
			if ($ShowKeyphrasesStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#SEARCHWORDS\">$Message[24]</a><br></td></tr>\n"; }
			# Others
			print "<tr><th class=AWL>$Message[2] : </th>";
			print "<td class=AWL>";
			if ($ShowCompressionStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#FILETYPES\">$Message[98]</a> &nbsp; "; }
			if ($ShowHTTPErrorsStats) { print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang#ERRORS\">$Message[22]</a> &nbsp; "; }
			if ($ShowHTTPErrorsStats) { print "<a href=\"$DirCgi$PROG.$Extension?output=notfounderror&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[31]</a><br></td></tr>\n"; }
		}
		else {
			if ($ShowBackLink) { print "<tr><td class=AWL><a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[76]</a></td></tr>\n"; }
		}
		print "</table>\n";
		print "<br>\n<hr>\n";
	}
	
	if ($QueryString =~ /output=lasthosts/i) {
		print "$CENTER<a name=\"HOSTSLIST\">&nbsp;</a><BR>";
		&tab_head("$Message[9]",19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[81] + $Message[83]</TH><TH>$Message[9]</TH></TR>\n";
		my $count=0; my $rest=0;
		# Create %lasthost = %_unknownip_l + %_hostmachine_l + %_robot_l
		my %lasthosts=%_unknownip_l;
		foreach $key (keys %_hostmachine_l) { $lasthosts{$key}=$_hostmachine_l{$key}; }
		foreach $key (keys %_robot_l) { $lasthosts{$key}=$_robot_l{$key}; }
		foreach my $key (sort { $SortDir*$lasthosts{$a} <=> $SortDir*$lasthosts{$b} } keys %lasthosts) {
			if ($count>=$MAXROWS || $count>=$MaxNbOfLastHosts) { $rest++; next; }
			$key =~ s/<script.*$//gi;				# This is to avoid 'Cross Site Scripting attacks'
			print "<tr><td>$key </td><td>".Format_Date($lasthosts{$key})."</td></tr>\n";
			$count++;
		}
		if ($rest) {
			print "<tr><td>$Message[2]</td><td>...</td></tr>\n";
		}
		&tab_end;
		&html_end;
		exit(0);
	}
	if ($QueryString =~ /output=urldetail/i) {
		if ($AddOn) { AddOn_Filter(); }
		print "$CENTER<a name=\"URLDETAIL\">&nbsp;</a><BR>";
		&tab_head($Message[19],19);
		if ($URLFilter) { print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[79]: <b>$URLFilter</b> - ".(scalar keys %_sider_p)." $Message[28]</TH>"; }
		else { print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>".(scalar keys %_sider_p)."&nbsp; $Message[28]</TH>"; }
		print "<TH bgcolor=\"#$color_p\">&nbsp;$Message[29]&nbsp;</TH>";
		if ($AddOn) { AddOn_ShowFields(""); }
		print "<TH>&nbsp;</TH></TR>\n";
		$max_p=1; foreach my $key (values %_sider_p) { if ($key > $max_p) { $max_p = $key; } }
		my $count=0; my $rest=0;
		foreach my $key (sort { $SortDir*$_sider_p{$a} <=> $SortDir*$_sider_p{$b} } keys (%_sider_p)) {
			if ($count>=$MAXROWS) { $rest+=$_sider_p{$key}; next; }
			if ($_sider_p{$key}<$MinHitFile) { $rest+=$_sider_p{$key}; next; }
	    	print "<TR><TD CLASS=AWL>";
			my $nompage=$Aliases{$key};
			if ($nompage eq "") { $nompage=$key; }
			if (length($nompage)>$MaxLengthOfURL) { $nompage=substr($nompage,0,$MaxLengthOfURL)."..."; }
		    if ($ShowLinksOnUrl) { print "<A HREF=\"http://$SiteToAnalyze$key\">$nompage</A>"; }
		    else              	 { print "$nompage"; }
		    my $bredde=int($BarWidth*$_sider_p{$key}/$max_p)+1;
			print "</TD><TD>$_sider_p{$key}</TD>";
			if ($AddOn) { AddOn_ShowFields($key); }
			print "<TD CLASS=AWL><IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_p\" WIDTH=$bredde HEIGHT=8></TD></TR>\n";
			$count++;
		}
		&tab_end;
		&html_end;
		exit(0);
	}
	if ($QueryString =~ /output=unknownip/i) {
		print "$CENTER<a name=\"UNKOWNIP\">&nbsp;</a><BR>";
		&tab_head($Message[45],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[48] (".(scalar keys %_unknownip_l).")</TH><TH>$Message[9]</TH>\n";
		my $count=0; my $rest=0;
		foreach my $key (sort { $SortDir*$_unknownip_l{$a} <=> $SortDir*$_unknownip_l{$b} } keys (%_unknownip_l)) {
			if ($count>=$MAXROWS) { $rest++; next; }
			$key =~ s/<script.*$//gi;				# This is to avoid 'Cross Site Scripting attacks'
			print "<tr><td>$key</td><td>".Format_Date($_unknownip_l{$key})."</td></tr>\n";
			$count++;
		}
		&tab_end;
		&html_end;
		exit(0);
	}
	if ($QueryString =~ /output=browserdetail/i) {
		print "$CENTER<a name=\"NETSCAPE\">&nbsp;</a><BR>";
		&tab_head("$Message[33]<br><img src=\"$DirIcons/browser/netscape.png\">",19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[58]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[15]</TH></TR>\n";
		for (my $i=1; $i<=$#_nsver_h; $i++) {
			my $h="&nbsp;"; my $p="&nbsp;";
			if ($_nsver_h[$i] > 0 && $_browser_h{"netscape"} > 0) {
				$h=$_nsver_h[$i]; $p=int($_nsver_h[$i]/$_browser_h{"netscape"}*1000)/10; $p="$p&nbsp;%";
			}
			print "<TR><TD CLASS=AWL>Mozilla/$i.xx</TD><TD>$h</TD><TD>$p</TD></TR>\n";
		}
		&tab_end;
		print "<a name=\"MSIE\">&nbsp;</a><BR>";
		&tab_head("$Message[34]<br><img src=\"$DirIcons/browser/msie.png\">",19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[58]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[15]</TH></TR>\n";
		for ($i=1; $i<=$#_msiever_h; $i++) {
			my $h="&nbsp;"; my $p="&nbsp;";
			if ($_msiever_h[$i] > 0 && $_browser_h{"msie"} > 0) {
				$h=$_msiever_h[$i]; $p=int($_msiever_h[$i]/$_browser_h{"msie"}*1000)/10; $p="$p&nbsp;%";
			}
			print "<TR><TD CLASS=AWL>MSIE/$i.xx</TD><TD>$h</TD><TD>$p</TD></TR>\n";
		}
		&tab_end;
		&html_end;
		exit(0);
	}
	if ($QueryString =~ /output=unknownrefererbrowser/i) {
		print "$CENTER<a name=\"UNKOWNREFERERBROWSER\">&nbsp;</a><BR>";
		&tab_head($Message[50],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>Referer (".(scalar keys %_unknownrefererbrowser_l).")</TH><TH>$Message[9]</TH></TR>\n";
		my $count=0; my $rest=0;
		foreach my $key (sort { $SortDir*$_unknownrefererbrowser_l{$a} <=> $SortDir*$_unknownrefererbrowser_l{$b} } keys (%_unknownrefererbrowser_l)) {
			if ($count>=$MAXROWS) { $rest+=$_sider404_h{$key}; next; }
			$key =~ s/<script.*$//gi;				# This is to avoid 'Cross Site Scripting attacks'
			print "<tr><td CLASS=AWL>$key</td><td>".Format_Date($_unknownrefererbrowser_l{$key})."</td></tr>\n";
			$count++;
		}
		&tab_end;
		&html_end;
		exit(0);
	}
	if ($QueryString =~ /output=unknownreferer/i) {
		print "$CENTER<a name=\"UNKOWNREFERER\">&nbsp;</a><BR>";
		&tab_head($Message[46],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>Referer (".(scalar keys %_unknownreferer_l).")</TH><TH>$Message[9]</TH></TR>\n";
		my $count=0; my $rest=0;
		foreach my $key (sort { $SortDir*$_unknownreferer_l{$a} <=> $SortDir*$_unknownreferer_l{$b} } keys (%_unknownreferer_l)) {
			if ($count>=$MAXROWS) { $rest+=$_sider404_h{$key}; next; }
			$key =~ s/<script.*$//gi;				# This is to avoid 'Cross Site Scripting attacks'
			print "<tr><td CLASS=AWL>$key</td><td>".Format_Date($_unknownreferer_l{$key})."</td></tr>\n";
			$count++;
		}
		&tab_end;
		&html_end;
		exit(0);
	}
	if ($QueryString =~ /output=notfounderror/i) {
		print "$CENTER<a name=\"NOTFOUNDERROR\">&nbsp;</a><BR>";
		&tab_head($Message[47],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>URL (".(scalar keys %_sider404_h).")</TH><TH bgcolor=\"#$color_h\">$Message[49]</TH><TH>$Message[23]</TH></TR>\n";
		my $count=0; my $rest=0;
		foreach my $key (sort { $SortDir*$_sider404_h{$a} <=> $SortDir*$_sider404_h{$b} } keys (%_sider404_h)) {
			if ($count>=$MAXROWS) { $rest+=$_sider404_h{$key}; next; }
			$key =~ s/<script.*$//gi; 				# This is to avoid 'Cross Site Scripting attacks'
			my $nompage=$key;
			#if (length($nompage)>$MaxLengthOfURL) { $nompage=substr($nompage,0,$MaxLengthOfURL)."..."; }
			my $referer=$_referer404_h{$key}; $referer =~ s/<script.*$//gi;	# This is to avoid 'Cross Site Scripting attacks'
			print "<tr><td CLASS=AWL>$nompage</td><td>$_sider404_h{$key}</td><td>$referer&nbsp;</td></tr>\n";
			$count++;
		}
		&tab_end;
		&html_end;
		exit(0);
	}
	if ($QueryString =~ /output=info/i) {
		# Not yet available
		print "$CENTER<a name=\"INFO\">&nbsp;</a><BR>";
		&html_end;
		exit(0);
	}
	
	# FirstTime LastTime TotalVisits TotalUnique TotalHostsKnown TotalHostsUnknown
	my $beginmonth=$MonthRequired;my $endmonth=$MonthRequired;
	if ($MonthRequired eq "year") { $beginmonth=1;$endmonth=12; }
	for (my $monthix=$beginmonth; $monthix<=$endmonth; $monthix++) {
		$monthix=$monthix+0; if ($monthix < 10) { $monthix  = "0$monthix"; }	# Good trick to change $month into "MM" format
		if ($FirstTime{$YearRequired.$monthix} && ($FirstTime == 0 || $FirstTime > $FirstTime{$YearRequired.$monthix})) { $FirstTime = $FirstTime{$YearRequired.$monthix}; }
		if ($LastTime < $LastTime{$YearRequired.$monthix}) { $LastTime = $LastTime{$YearRequired.$monthix}; }
		$TotalVisits+=$MonthVisits{$YearRequired.$monthix};
		$TotalUnique+=$MonthUnique{$YearRequired.$monthix};
		$TotalHostsKnown+=$MonthHostsKnown{$YearRequired.$monthix};
		$TotalHostsUnknown+=$MonthHostsUnknown{$YearRequired.$monthix};
	}
	# TotalDifferentPages (if not already specifically counted, we init it from _sider_p hash table)
	if (!$TotalDifferentPages) { $TotalDifferentPages=scalar keys %_sider_p; }
	# TotalPages TotalHits TotalBytes
	for (my $ix=0; $ix<=23; $ix++) { $TotalPages+=$_time_p[$ix]; $TotalHits+=$_time_h[$ix]; $TotalBytes+=$_time_k[$ix]; }
	# TotalErrors
	foreach my $key (keys %_errors_h) { $TotalErrors+=$_errors_h{$key}; }
	# Ratio
	if ($TotalUnique > 0) { $RatioHosts=int($TotalVisits/$TotalUnique*100)/100; }
	if ($TotalVisits > 0) { $RatioPages=int($TotalPages/$TotalVisits*100)/100; }
	if ($TotalVisits > 0) { $RatioHits=int($TotalHits/$TotalVisits*100)/100; }
	if ($TotalVisits > 0) { $RatioBytes=int(($TotalBytes/1024)*100/$TotalVisits)/100; }
	
	# SUMMARY
	#---------------------------------------------------------------------
	if ($ShowMonthDayStats) {
		print "$CENTER<a name=\"SUMMARY\">&nbsp;</a><BR>";
		&tab_head("$Message[7] $SiteToAnalyze",0);

		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TD><b>$Message[8]</b></TD>";
		if ($MonthRequired eq "year") { print "<TD colspan=3 rowspan=2><font style=\"font: 18px arial,verdana,helvetica; font-weight: normal\">$Message[6] $YearRequired</font><br>"; }
		else { print "<TD colspan=3 rowspan=2><font style=\"font: 18px arial,verdana,helvetica; font-weight: normal\">$Message[5] $monthlib{$MonthRequired} $YearRequired</font><br>"; }
		# Show links for possible years
		foreach my $key (keys %listofyears) {
			print "<a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$key&month=year&lang=$Lang\">$Message[6] $key</a> &nbsp; ";
		}
		print "</TD>";
		print "<TD><b>$Message[9]</b></TD></TR>";
		
		if ($FirstTime) { print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TD>".Format_Date($FirstTime)."</TD>"; }
		else { print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TD>NA</TD>"; }
		if ($LastTime) { print "<TD>".Format_Date($LastTime)."</TD></TR>"; }
		else { print "<TD>NA</TD></TR>\n"; }
		print "<TR>";
		print "<TD width=\"20%\" bgcolor=\"#$color_v\" onmouseover=\"ShowTooltip(1);\" onmouseout=\"HideTooltip(1);\">$Message[10]</TD>";
		print "<TD width=\"20%\" bgcolor=\"#$color_w\" onmouseover=\"ShowTooltip(2);\" onmouseout=\"HideTooltip(2);\">$Message[11]</TD>";
		print "<TD width=\"20%\" bgcolor=\"#$color_p\" onmouseover=\"ShowTooltip(3);\" onmouseout=\"HideTooltip(3);\">$Message[56]</TD>";
		print "<TD width=\"20%\" bgcolor=\"#$color_h\" onmouseover=\"ShowTooltip(4);\" onmouseout=\"HideTooltip(4);\">$Message[57]</TD>";
		print "<TD width=\"20%\" bgcolor=\"#$color_k\" onmouseover=\"ShowTooltip(5);\" onmouseout=\"HideTooltip(5);\">$Message[75]</TD></TR>";
		print "<TR><TD><b>$TotalVisits</b><br>&nbsp;</TD><TD><b>$TotalUnique</b><br>($RatioHosts&nbsp;$Message[52])</TD><TD><b>$TotalPages</b><br>($RatioPages&nbsp;".lc($Message[56]."/".$Message[12]).")</TD>";
		print "<TD><b>$TotalHits</b><br>($RatioHits&nbsp;".lc($Message[57]."/".$Message[12]).")</TD><TD><b>".Format_Bytes($TotalBytes)."</b><br>($RatioBytes&nbsp;$Message[44]/".lc($Message[12]).")</TD></TR>\n";
		print "<TR valign=bottom><TD colspan=5 align=center><center>";
		# Show monthly stats
		print "<TABLE>";
		print "<TR valign=bottom>";
		$max_p=$max_h=$max_k=$max_v=1;
		for (my $ix=1; $ix<=12; $ix++) {
			my $monthix=$ix; if ($monthix < 10) { $monthix="0$monthix"; }
			if ($MonthVisits{$YearRequired.$monthix} > $max_v) { $max_v=$MonthVisits{$YearRequired.$monthix}; }
			if ($MonthUnique{$YearRequired.$monthix} > $max_v) { $max_v=$MonthUnique{$YearRequired.$monthix}; }
			if ($MonthPages{$YearRequired.$monthix} > $max_p)  { $max_p=$MonthPages{$YearRequired.$monthix}; }
			if ($MonthHits{$YearRequired.$monthix} > $max_h)   { $max_h=$MonthHits{$YearRequired.$monthix}; }
			if ($MonthBytes{$YearRequired.$monthix} > $max_k)  { $max_k=$MonthBytes{$YearRequired.$monthix}; }
		}
		for (my $ix=1; $ix<=12; $ix++) {
			my $monthix=$ix; if ($monthix < 10) { $monthix="0$monthix"; }
			my $bredde_u=0; my $bredde_v=0;my $bredde_p=0;my $bredde_h=0;my $bredde_k=0;
			if ($max_v > 0) { $bredde_v=int($MonthVisits{$YearRequired.$monthix}/$max_v*$BarHeight/2)+1; }
			if ($max_v > 0) { $bredde_u=int($MonthUnique{$YearRequired.$monthix}/$max_v*$BarHeight/2)+1; }
			if ($max_h > 0) { $bredde_p=int($MonthPages{$YearRequired.$monthix}/$max_h*$BarHeight/2)+1; }
			if ($max_h > 0) { $bredde_h=int($MonthHits{$YearRequired.$monthix}/$max_h*$BarHeight/2)+1; }
			if ($max_k > 0) { $bredde_k=int($MonthBytes{$YearRequired.$monthix}/$max_k*$BarHeight/2)+1; }
			print "<TD>";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_v\" HEIGHT=$bredde_v WIDTH=8 ALT=\"$Message[10]: $MonthVisits{$YearRequired.$monthix}\" title=\"$Message[10]: $MonthVisits{$YearRequired.$monthix}\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_u\" HEIGHT=$bredde_u WIDTH=8 ALT=\"$Message[11]: $MonthUnique{$YearRequired.$monthix}\" title=\"$Message[11]: $MonthUnique{$YearRequired.$monthix}\">";
			print "&nbsp;";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_p\" HEIGHT=$bredde_p WIDTH=8 ALT=\"$Message[56]: $MonthPages{$YearRequired.$monthix}\" title=\"$Message[56]: $MonthPages{$YearRequired.$monthix}\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_h\" HEIGHT=$bredde_h WIDTH=8 ALT=\"$Message[57]: $MonthHits{$YearRequired.$monthix}\" title=\"$Message[57]: $MonthHits{$YearRequired.$monthix}\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_k\" HEIGHT=$bredde_k WIDTH=8 ALT=\"$Message[75]: ".Format_Bytes($MonthBytes{$YearRequired.$monthix})."\" title=\"$Message[75]: ".Format_Bytes($MonthBytes{$YearRequired.$monthix})."\">";
			print "</TD>\n";
		}
		print "</TR><TR>";
		for (my $ix=1; $ix<=12; $ix++) {
			my $monthix=$ix; if ($monthix < 10) { $monthix="0$monthix"; }
			print "<TD valign=middle><a href=\"$DirCgi$PROG.$Extension?".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$monthix&lang=$Lang\">$monthlib{$monthix}</a></TD>";
		}
		print "</TR></TABLE><br>";
		# Show daily stats
		print "<TABLE>";
		print "<TR valign=bottom>";
		$max_p=$max_h=$max_k=$max_v=1;
		my $lastdaytoshowtime=$nowyear.$nowmonth.$nowday;				# Set day cursor to today
		if (($MonthRequired ne $nowmonth && $MonthRequired ne "year") || $YearRequired ne $nowyear) { 
			if ($MonthRequired eq "year") {
				$lastdaytoshowtime=$YearRequired."1231";				# Set day cursor to last day of the required year
			}
			else {
				$lastdaytoshowtime=$YearRequired.$MonthRequired."31";	# Set day cursor to last day of the required month
			}
		}
		my $firstdaytoshowtime=$lastdaytoshowtime;
		# Get max_p, max_h and max_k values
		my $nbofdaysshown=0;
		for (my $daycursor=$lastdaytoshowtime; $nbofdaysshown<$MaxNbOfDays; $daycursor--) {
			$daycursor =~ /^(\d\d\d\d)/; my $year=$1;
			$daycursor =~ /^\d\d\d\d(\d\d)/; my $month=$1;
			$daycursor =~ /^\d\d\d\d\d\d(\d\d)/; my $day=$1;
			if (! DateIsValid($day,$month,$year)) { next; }			# If not an existing day, go to next
			$nbofdaysshown++;
			$firstdaytoshowtime=$year.$month.$day;
			if ($DayPages{$year.$month.$day} > $max_p)  { $max_p=$DayPages{$year.$month.$day}; }
			if ($DayHits{$year.$month.$day} > $max_h)   { $max_h=$DayHits{$year.$month.$day}; }
			if ($DayBytes{$year.$month.$day} > $max_k)  { $max_k=$DayBytes{$year.$month.$day}; }
		}
		$nbofdaysshown=0;
		for (my $daycursor=$firstdaytoshowtime; $nbofdaysshown<$MaxNbOfDays; $daycursor++) {
			$daycursor =~ /^(\d\d\d\d)/; my $year=$1;
			$daycursor =~ /^\d\d\d\d(\d\d)/; my $month=$1;
			$daycursor =~ /^\d\d\d\d\d\d(\d\d)/; my $day=$1;
			if (! DateIsValid($day,$month,$year)) { next; }			# If not an existing day, go to next
			$nbofdaysshown++;
			my $bredde_p=0;my $bredde_h=0;my $bredde_k=0;
			if ($max_h > 0) { $bredde_p=int($DayPages{$year.$month.$day}/$max_h*$BarHeight/2)+1; }
			if ($max_h > 0) { $bredde_h=int($DayHits{$year.$month.$day}/$max_h*$BarHeight/2)+1; }
			if ($max_k > 0) { $bredde_k=int($DayBytes{$year.$month.$day}/$max_k*$BarHeight/2)+1; }
			print "<TD>";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_p\" HEIGHT=$bredde_p WIDTH=4 ALT=\"$Message[56]: $DayPages{$year.$month.$day}\" title=\"$Message[56]: $DayPages{$year.$month.$day}\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_h\" HEIGHT=$bredde_h WIDTH=4 ALT=\"$Message[57]: $DayHits{$year.$month.$day}\" title=\"$Message[57]: $DayHits{$year.$month.$day}\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_k\" HEIGHT=$bredde_k WIDTH=4 ALT=\"$Message[75]: ".Format_Bytes($DayBytes{$year.$month.$day})."\" title=\"$Message[75]: ".Format_Bytes($DayBytes{$year.$month.$day})."\">";
			print "</TD>\n";
		}
		print "<TD> &nbsp; </TD>";
		# Calculate average values
		my $avg_day_nb=0; my $avg_day_p=0; my $avg_day_h=0; my $avg_day_k=0;
		my $FirstTimeDay=$FirstTime;
		my $LastTimeDay=$LastTime;
		$FirstTimeDay =~ /^(\d\d\d\d\d\d\d\d).*/; $FirstTimeDay=$1;
		$LastTimeDay =~ /^(\d\d\d\d\d\d\d\d).*/; $LastTimeDay=$1;
		foreach my $daycursor ($FirstTimeDay..$LastTimeDay) {
			$daycursor =~ /^(\d\d\d\d)/; my $year=$1;
			$daycursor =~ /^\d\d\d\d(\d\d)/; my $month=$1;
			$daycursor =~ /^\d\d\d\d\d\d(\d\d)/; my $day=$1;
			if (! DateIsValid($day,$month,$year)) { next; }			# If not an existing day, go to next
			$avg_day_nb++;											# Increase number of day used to count
			$avg_day_p+=$DayPages{$daycursor};
			$avg_day_h+=$DayHits{$daycursor};
			$avg_day_k+=$DayBytes{$daycursor};
		}
		if ($avg_day_nb) {
			$avg_day_p=sprintf("%.2f",$avg_day_p/$avg_day_nb);
			$avg_day_h=sprintf("%.2f",$avg_day_h/$avg_day_nb);
			$avg_day_k=sprintf("%.2f",$avg_day_k/$avg_day_nb);
		}
		# Show average values
		print "<TD>";
		my $bredde_p=0;my $bredde_h=0;my $bredde_k=0;
		if ($max_h > 0) { $bredde_p=int($avg_day_p/$max_h*$BarHeight/2)+1; }
		if ($max_h > 0) { $bredde_h=int($avg_day_h/$max_h*$BarHeight/2)+1; }
		if ($max_k > 0) { $bredde_k=int($avg_day_k/$max_k*$BarHeight/2)+1; }
		print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_p\" HEIGHT=$bredde_p WIDTH=4 ALT=\"$Message[56]: $avg_day_p\" title=\"$Message[56]: $avg_day_p\">";
		print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_h\" HEIGHT=$bredde_h WIDTH=4 ALT=\"$Message[57]: $avg_day_h\" title=\"$Message[57]: $avg_day_h\">";
		print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_k\" HEIGHT=$bredde_k WIDTH=4 ALT=\"$Message[75]: ".Format_Bytes($avg_day_k)."\" title=\"$Message[75]: ".Format_Bytes($avg_day_k)."\">";
		print "</TD>\n";

		print "</TR><TR>";
		$nbofdaysshown=0;
		for (my $daycursor=$firstdaytoshowtime; $nbofdaysshown<$MaxNbOfDays; $daycursor++) {
			$daycursor =~ /^(\d\d\d\d)/; my $year=$1;
			$daycursor =~ /^\d\d\d\d(\d\d)/; my $month=$1;
			$daycursor =~ /^\d\d\d\d\d\d(\d\d)/; my $day=$1;
			if (! DateIsValid($day,$month,$year)) { next; }			# If not an existing day, go to next
			$nbofdaysshown++;
			print "<TD valign=middle".(DayOfWeek($day,$month,$year)==0||DayOfWeek($day,$month,$year)==6?" bgcolor=\"#$color_weekend\"":"").">";
			print ($day==$nowday && $month==$nowmonth?"<b>":"");
			print "$day<br><font style=\"font: 10px;\">".$monthlib{$month}."</font>";
			print ($day==$nowday && $month==$nowmonth?"</b></TD>":"</TD>");
		}
		print "<TD> &nbsp; </TD>";
		print "<TD valign=middle onmouseover=\"ShowTooltip(18);\" onmouseout=\"HideTooltip(18);\">$Message[96]</TD>";
		print "</TR></TABLE><br>";
		
		print "</center></TD></TR>";
		&tab_end;
	}	

	# BY DAY OF WEEK
	#-------------------------
	if ($ShowDaysOfWeekStats) {
		print "$CENTER<a name=\"DAYOFWEEK\">&nbsp;</a><BR>";
		&tab_head($Message[91],18);
		print "<TR>";
		print "<TD align=center><center><TABLE>";
		print "<TR valign=bottom>\n";
		$max_p=$max_h=$max_k=$max_v=1;
		# Get average value for day of week
		my $FirstTimeDay=$FirstTime;
		my $LastTimeDay=$LastTime;
		$FirstTimeDay =~ /^(\d\d\d\d\d\d\d\d).*/; $FirstTimeDay=$1;
		$LastTimeDay =~ /^(\d\d\d\d\d\d\d\d).*/; $LastTimeDay=$1;
		foreach my $daycursor ($FirstTimeDay..$LastTimeDay) {
			$daycursor =~ /^(\d\d\d\d)/; my $year=$1;
			$daycursor =~ /^\d\d\d\d(\d\d)/; my $month=$1;
			$daycursor =~ /^\d\d\d\d\d\d(\d\d)/; my $day=$1;
			if (! DateIsValid($day,$month,$year)) { next; }			# If not an existing day, go to next
			my $dayofweek=DayOfWeek($day,$month,$year);
			$avg_dayofweek[$dayofweek]++;							# Increase number of day used to count for this day of week
			$avg_dayofweek_p[$dayofweek]+=$DayPages{$daycursor};
			$avg_dayofweek_h[$dayofweek]+=$DayHits{$daycursor};
			$avg_dayofweek_k[$dayofweek]+=$DayBytes{$daycursor};
		}
		for (0..6) {
			if ($avg_dayofweek[$_]) { 
				$avg_dayofweek_p[$_]=sprintf("%.2f",$avg_dayofweek_p[$_]/$avg_dayofweek[$_]);
				$avg_dayofweek_h[$_]=sprintf("%.2f",$avg_dayofweek_h[$_]/$avg_dayofweek[$_]);
				$avg_dayofweek_k[$_]=sprintf("%.2f",$avg_dayofweek_k[$_]/$avg_dayofweek[$_]);
			}
			$max_p = $avg_dayofweek_p[$_]  if ($avg_dayofweek_p[$_] > $max_p);
			$max_h = $avg_dayofweek_h[$_]  if ($avg_dayofweek_h[$_] > $max_h);
			$max_k = $avg_dayofweek_k[$_]  if ($avg_dayofweek_k[$_] > $max_k);
        }
        for (@DOWIndex) {
			if ($max_h > 0) { $bredde_p=int($avg_dayofweek_p[$_]/$max_h*$BarHeight/2)+1; }
			if ($max_h > 0) { $bredde_h=int($avg_dayofweek_h[$_]/$max_h*$BarHeight/2)+1; }
			if ($max_k > 0) { $bredde_k=int($avg_dayofweek_k[$_]/$max_k*$BarHeight/2)+1; }
			print "<TD valign=bottom>\n";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_p\" HEIGHT=$bredde_p WIDTH=6 ALT=\"$Message[56]: $avg_dayofweek_p[$_]\" title=\"$Message[56]: $avg_dayofweek_p[$_]\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_h\" HEIGHT=$bredde_h WIDTH=6 ALT=\"$Message[57]: $avg_dayofweek_h[$_]\" title=\"$Message[57]: $avg_dayofweek_h[$_]\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_k\" HEIGHT=$bredde_k WIDTH=6 ALT=\"$Message[75]: ".Format_Bytes($avg_dayofweek_k[$_])."\" title=\"$Message[75]: ".Format_Bytes($avg_dayofweek_k[$_])."\">";
			print "</TD>\n";
        }
        print "</TR>\n<TR onmouseover=\"ShowTooltip(17);\" onmouseout=\"HideTooltip(17);\">\n";
        for (@DOWIndex) {
			print "<TD";
			if ($_ =~ /[06]/) { print " bgcolor=\"#$color_weekend\""; }
			print ">".$Message[$_+84]."</TD>";
        }
		print "</TR></TABLE></center></TD>";
		print "</TR>\n";
		&tab_end;
	}
	
	# BY HOUR
	#----------------------------
	if ($ShowHoursStats) {
		print "$CENTER<a name=\"HOUR\">&nbsp;</a><BR>";
		&tab_head($Message[20],19);
		print "<TR><TD align=center><center><TABLE><TR>\n";
		$max_p=$max_h=$max_k=1;
		for (my $ix=0; $ix<=23; $ix++) {
		  print "<TH width=16 onmouseover=\"ShowTooltip(17);\" onmouseout=\"HideTooltip(17);\">$ix</TH>";
		  if ($_time_p[$ix]>$max_p) { $max_p=$_time_p[$ix]; }
		  if ($_time_h[$ix]>$max_h) { $max_h=$_time_h[$ix]; }
		  if ($_time_k[$ix]>$max_k) { $max_k=$_time_k[$ix]; }
		}
		print "</TR>\n";
		print "<TR>\n";
		for (my $ix=1; $ix<=24; $ix++) {
			my $hr=$ix; if ($hr>12) { $hr=$hr-12; }
			print "<TH onmouseover=\"ShowTooltip(17);\" onmouseout=\"HideTooltip(17);\"><IMG SRC=\"$DirIcons\/clock\/hr$hr.png\" width=10></TH>";
		}
		print "</TR>\n";
		print "\n<TR VALIGN=BOTTOM>\n";
		for (my $ix=0; $ix<=23; $ix++) {
			my $bredde_p=0;my $bredde_h=0;my $bredde_k=0;
			if ($max_h > 0) { $bredde_p=int($BarHeight*$_time_p[$ix]/$max_h)+1; }
			if ($max_h > 0) { $bredde_h=int($BarHeight*$_time_h[$ix]/$max_h)+1; }
			if ($max_k > 0) { $bredde_k=int($BarHeight*$_time_k[$ix]/$max_k)+1; }
			print "<TD>";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_p\" HEIGHT=$bredde_p WIDTH=6 ALT=\"$Message[56]: $_time_p[$ix]\" title=\"$Message[56]: $_time_p[$ix]\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_h\" HEIGHT=$bredde_h WIDTH=6 ALT=\"$Message[57]: $_time_h[$ix]\" title=\"$Message[57]: $_time_h[$ix]\">";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageVertical_k\" HEIGHT=$bredde_k WIDTH=6 ALT=\"$Message[75]: ".Format_Bytes($_time_k[$ix])."\" title=\"$Message[75]: ".Format_Bytes($_time_k[$ix])."\">";
			print "</TD>\n";
		}
		print "</TR></TABLE></center></TD></TR>\n";
		&tab_end;
	}

	# BY COUNTRY/DOMAIN
	#---------------------------
	if ($ShowDomainsStats) {
		my @sortdomains_p=sort { $SortDir*$_domener_p{$a} <=> $SortDir*$_domener_p{$b} } keys (%_domener_p);
		print "$CENTER<a name=\"DOMAINS\">&nbsp;</a><BR>";
		&tab_head($Message[25],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH colspan=2>$Message[17]</TH><TH>Code</TH><TH bgcolor=\"#$color_p\" width=80>$Message[56]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_k\" width=80>$Message[75]</TH><TH>&nbsp;</TH></TR>\n";
		$total_p=$total_h=$total_k=0;
		$max_h=1; foreach my $key (values %_domener_h) { if ($key > $max_h) { $max_h = $key; } }
		$max_k=1; foreach my $key (values %_domener_k) { if ($key > $max_k) { $max_k = $key; } }
		$count=0; $rest_p=0;
		foreach my $key (@sortdomains_p) {
			if ($count >= $MaxNbOfDomain) { last; }
			my $bredde_p=0;my $bredde_h=0;my $bredde_k=0;
			if ($max_h > 0) { $bredde_p=int($BarWidth*$_domener_p{$key}/$max_h)+1; }	# use max_h to enable to compare pages with hits
			if ($max_h > 0) { $bredde_h=int($BarWidth*$_domener_h{$key}/$max_h)+1; }
			if ($max_k > 0) { $bredde_k=int($BarWidth*$_domener_k{$key}/$max_k)+1; }
			if ($key eq "ip") {
				print "<TR><TD><IMG SRC=\"$DirIcons\/flags\/$key.png\" height=14></TD><TD CLASS=AWL>$Message[0]</TD><TD>$key</TD>";
			}
			else {
				print "<TR><TD><IMG SRC=\"$DirIcons\/flags\/$key.png\" height=14></TD><TD CLASS=AWL>$DomainsHashIDLib{$key}</TD><TD>$key</TD>";
			}
			print "<TD>$_domener_p{$key}</TD><TD>$_domener_h{$key}</TD><TD>".Format_Bytes($_domener_k{$key})."</TD>";
			print "<TD CLASS=AWL>";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_p\" WIDTH=$bredde_p HEIGHT=6 ALT=\"$Message[56]: $_domener_p{$key}\" title=\"$Message[56]: $_domener_p{$key}\"><br>\n";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_h\" WIDTH=$bredde_h HEIGHT=6 ALT=\"$Message[57]: $_domener_h{$key}\" title=\"$Message[57]: $_domener_h{$key}\"><br>\n";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_k\" WIDTH=$bredde_k HEIGHT=6 ALT=\"$Message[75]: ".Format_Bytes($_domener_k{$key})."\" title=\"$Message[75]: ".Format_Bytes($_domener_k{$key})."\">";
			print "</TD></TR>\n";
			$total_p += $_domener_p{$key};
			$total_h += $_domener_h{$key};
			$total_k += $_domener_k{$key};
			$count++;
		}
		$rest_p=$TotalPages-$total_p;
		$rest_h=$TotalHits-$total_h;
		$rest_k=$TotalBytes-$total_k;
		if ($rest_p > 0) { 	# All other domains (known or not)
			my $bredde_p=0;my $bredde_h=0;my $bredde_k=0;
			if ($max_h > 0) { $bredde_p=int($BarWidth*$rest_p/$max_h)+1; }	# use max_h to enable to compare pages with hits
			if ($max_h > 0) { $bredde_h=int($BarWidth*$rest_h/$max_h)+1; }
			if ($max_k > 0) { $bredde_k=int($BarWidth*$rest_k/$max_k)+1; }
			print "<TR><TD colspan=3 CLASS=AWL><font color=blue>$Message[2]</font></TD><TD>$rest_p</TD><TD>$rest_h</TD><TD>".Format_Bytes($rest_k)."</TD>\n";
			print "<TD CLASS=AWL>";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_p\" WIDTH=$bredde_p HEIGHT=6 ALT=\"$Message[56]: $rest_p\" title=\"$Message[56]: $rest_p\"><br>\n";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_h\" WIDTH=$bredde_h HEIGHT=6 ALT=\"$Message[57]: $rest_h\" title=\"$Message[57]: $rest_h\"><br>\n";
			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_k\" WIDTH=$bredde_k HEIGHT=6 ALT=\"$Message[75]: ".Format_Bytes($rest_k)."\" title=\"$Message[75]: ".Format_Bytes($rest_k)."\">";
			print "</TD></TR>\n";
		}
		&tab_end;
	}
	
	# BY HOST/VISITOR
	#--------------------------
	if ($ShowHostsStats) {
		print "$CENTER<a name=\"VISITOR\">&nbsp;</a><BR>";
		$MaxNbOfHostsShown = $TotalHostsKnown+($_hostmachine_h{"Unknown"}?1:0) if $MaxNbOfHostsShown > $TotalHostsKnown;
		&tab_head("$Message[77] $MaxNbOfHostsShown $Message[55] ".($TotalHostsKnown+$TotalHostsUnknown)." $Message[26] ($TotalUnique $Message[11]) &nbsp; - &nbsp; <a href=\"$DirCgi$PROG.$Extension?output=lasthosts&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[9]</a>",19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[81] : $TotalHostsKnown $Message[82], $TotalHostsUnknown $Message[1]</TH><TH bgcolor=\"#$color_p\" width=80>$Message[56]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_k\" width=80>$Message[75]</TH><TH width=120>$Message[9]</TH></TR>\n";
		$total_p=$total_h=$total_k=0;
		$count=0;
		foreach my $key (sort { $SortDir*$_hostmachine_p{$a} <=> $SortDir*$_hostmachine_p{$b} } keys (%_hostmachine_p)) {
			if ($count>=$MaxNbOfPageShown) { last; }
			if ($_hostmachine_h{$key}<$MinHitHost) { last; }
			if ($key eq "Unknown") {
				print "<TR><TD CLASS=AWL><a href=\"$DirCgi$PROG.$Extension?output=unknownip&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[1]</a></TD><TD>$_hostmachine_p{$key}</TD><TD>$_hostmachine_h{$key}</TD><TD>".Format_Bytes($_hostmachine_k{$key})."</TD><TD><a href=\"$DirCgi$PROG.$Extension?output=unknownip&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[3]</a></TD></TR>\n";
				}
			else {
				print "<tr><td CLASS=AWL>$key</td><TD>$_hostmachine_p{$key}</TD><TD>$_hostmachine_h{$key}</TD><TD>".Format_Bytes($_hostmachine_k{$key})."</TD>";
				if ($_hostmachine_l{$key}) { print "<td>".Format_Date($_hostmachine_l{$key})."</td>"; }
				else { print "<td>-</td>"; }
				print "</tr>";
			}
			$total_p += $_hostmachine_p{$key};
			$total_h += $_hostmachine_h{$key};
			$total_k += $_hostmachine_k{$key};
			$count++;
		}
		$rest_p=$TotalPages-$total_p;
		$rest_h=$TotalHits-$total_h;
		$rest_k=$TotalBytes-$total_k;
		if ($rest_p > 0) {	# All other visitors (known or not)
			print "<TR><TD CLASS=AWL><font color=blue>$Message[2]</font></TD><TD>$rest_p</TD><TD>$rest_h</TD><TD>".Format_Bytes($rest_k)."</TD><TD>&nbsp;</TD></TR>\n";
		}
		&tab_end;
	}	
	
	# BY LOGIN
	#----------------------------
	if ($ShowAuthenticatedUsers) {
		my @sortlogin_h=sort { $SortDir*$_login_h{$a} <=> $SortDir*$_login_h{$b} } keys (%_login_h);
		print "$CENTER<a name=\"LOGIN\">&nbsp;</a><BR>";
		&tab_head($Message[94],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[94]</TH><TH bgcolor=\"#$color_p\" width=80>$Message[56]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_k\" width=80>$Message[75]</TH><TH width=120>$Message[9]</TH></TR>\n";
		$total_p=$total_h=$total_k=0;
		$max_h=1; foreach my $key (values %_login_h) { if ($key > $max_h) { $max_h = $key; } }
		$max_k=1; foreach my $key (values %_login_k) { if ($key > $max_k) { $max_k = $key; } }
		$count=0; $rest_p=0;
		foreach my $key (@sortlogin_h) {
			if ($count >= $MaxNbOfLoginShown) { last; }
			my $bredde_p=0;my $bredde_h=0;my $bredde_k=0;
			if ($max_h > 0) { $bredde_p=int($BarWidth*$_login_p{$key}/$max_h)+1; }	# use max_h to enable to compare pages with hits
			if ($max_h > 0) { $bredde_h=int($BarWidth*$_login_h{$key}/$max_h)+1; }
			if ($max_k > 0) { $bredde_k=int($BarWidth*$_login_k{$key}/$max_k)+1; }
			print "<TR><TD CLASS=AWL>$key</TD>";
			print "<TD>$_login_p{$key}</TD><TD>$_login_h{$key}</TD><TD>".Format_Bytes($_login_k{$key})."</TD>";
			if ($_login_l{$key}) { print "<td>".Format_Date($_login_l{$key})."</td>"; }
			else { print "<td>-</td>"; }
#			print "<TD CLASS=AWL>";
#			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_p\" WIDTH=$bredde_p HEIGHT=6 ALT=\"$Message[56]: $_login_p{$key}\" title=\"$Message[56]: $_login_p{$key}\"><br>\n";
#			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_h\" WIDTH=$bredde_h HEIGHT=6 ALT=\"$Message[57]: $_login_h{$key}\" title=\"$Message[57]: $_login_h{$key}\"><br>\n";
#			print "<IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_k\" WIDTH=$bredde_k HEIGHT=6 ALT=\"$Message[75]: ".Format_Bytes($_login_k{$key})."\" title=\"$Message[75]: ".Format_Bytes($_login_k{$key})."\">";
#			print "</TD>";
			print "</TR>\n";
			$total_p += $_login_p{$key};
			$total_h += $_login_h{$key};
			$total_k += $_login_k{$key};
			$count++;
		}
		&tab_end;
	}	
	
	# BY ROBOTS
	#----------------------------
	if ($ShowRobotsStats) {
		print "$CENTER<a name=\"ROBOTS\">&nbsp;</a><BR>";
		&tab_head($Message[53],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\" onmouseover=\"ShowTooltip(16);\" onmouseout=\"HideTooltip(16);\"><TH>$Message[83]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH width=120>$Message[9]</TH></TR>\n";
		my $count=0;
		foreach my $key (sort { $SortDir*$_robot_h{$a} <=> $SortDir*$_robot_h{$b} } keys (%_robot_h)) {
			print "<tr><td CLASS=AWL>$RobotHashIDLib{$key}</td><td>$_robot_h{$key}</td><td>".Format_Date($_robot_l{$key})."</td></tr>";
			$count++;
			}
		&tab_end;
	}	
		
	# BY PAGE
	#-------------------------
	if ($ShowPagesStats) {
		print "$CENTER<a name=\"PAGE\">&nbsp;</a><BR>";
		$MaxNbOfPageShown = $TotalDifferentPages if $MaxNbOfPageShown > $TotalDifferentPages;
		&tab_head("$Message[77] $MaxNbOfPageShown $Message[55] $TotalDifferentPages $Message[27] &nbsp; - &nbsp; <a href=\"$DirCgi$PROG.$Extension?output=urldetail&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[80]</a>",19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[19]</TH><TH bgcolor=\"#$color_p\" width=80>&nbsp;$Message[29]&nbsp;</TH><TH>&nbsp;</TH></TR>\n";
		$max_p=1; foreach my $key (values %_sider_p) { if ($key > $max_p) { $max_p = $key; } }
		$count=0; $rest_p=0;
		foreach my $key (sort { $SortDir*$_sider_p{$a} <=> $SortDir*$_sider_p{$b} } keys (%_sider_p)) {
			if ($count>=$MaxNbOfPageShown) { $rest_p+=$_sider_p{$key}; next; }
			if ($_sider_p{$key}<$MinHitFile) { $rest_p+=$_sider_p{$key}; next; }
		    print "<TR><TD CLASS=AWL>";
			my $nompage=$Aliases{$key};
			if ($nompage eq "") { $nompage=$key; }
			if (length($nompage)>$MaxLengthOfURL) { $nompage=substr($nompage,0,$MaxLengthOfURL)."..."; }
			if ($ShowLinksOnUrl) { print "<A HREF=\"http://$SiteToAnalyze$key\">$nompage</A>"; }
			else              	 { print "$nompage"; }
			my $bredde=int($BarWidth*$_sider_p{$key}/$max_p)+1;
			print "</TD><TD>$_sider_p{$key}</TD><TD CLASS=AWL><IMG SRC=\"$DirIcons\/other\/$BarImageHorizontal_p\" WIDTH=$bredde HEIGHT=8 ALT=\"$Message[56]: $_sider_p{$key}\" title=\"$Message[56]: $_sider_p{$key}\"></TD></TR>\n";
			$count++;
		}
		&tab_end;
	}
		
	# BY FILE TYPE
	#-------------------------
	if ($ShowFileTypesStats || $ShowCompressionStats) {
		my $Totalh=0; foreach my $key (keys %_filetypes_h) { $Totalh+=$_filetypes_h{$key}; }
		my $Totalk=0; foreach my $key (keys %_filetypes_k) { $Totalk+=$_filetypes_k{$key}; }
		print "$CENTER<a name=\"FILETYPES\">&nbsp;</a><BR>";
		if ($ShowCompressionStats) { &tab_head("$Message[73] - $Message[98]</a>",19); }
		else { &tab_head("$Message[73]</a>",19); }
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[73]</TH>";
		print "<TH bgcolor=\"#$color_h\" width=80>&nbsp;$Message[57]&nbsp;</TH><TH bgcolor=\"#$color_h\" width=80>$Message[15]</TH>";
		if ($ShowCompressionStats) {
			print "<TH bgcolor=\"#$color_k\" width=120>$Message[100]</TH><TH bgcolor=\"#$color_k\" width=120>$Message[101]</TH><TH bgcolor=\"#$color_k\" width=120>$Message[99]</TH>";
		}
		else {
			print "<TH bgcolor=\"#$color_k\" width=80>$Message[75]</TH>";
		}
		print "</TR>\n";
		$count=0; 
		foreach my $key (sort { $SortDir*$_filetypes_h{$a} <=> $SortDir*$_filetypes_h{$b} } keys (%_filetypes_h)) {
			my $p=int($_filetypes_h{$key}/$Totalh*1000)/10;
			if ($key eq "Unknown") {
				print "<TR><TD CLASS=AWL>$Message[0]</a></TD>";
			}
			else {
				print "<TR><TD CLASS=AWL>$key</TD>";
			}
			print "<TD>$_filetypes_h{$key}</TD><TD>$p&nbsp;%</TD>";
			if ($ShowCompressionStats) {
				if ($_filetypes_gz_in{$key}) {
					my $percent=int(100*(1-$_filetypes_gz_out{$key}/$_filetypes_gz_in{$key})); 
					printf("<TD>%s</TD><TD>%s</TD><TD>%s (%s%)</TD>",Format_Bytes($_filetypes_gz_in{$key}),Format_Bytes($_filetypes_k{$key}),Format_Bytes($_filetypes_gz_in{$key}-$_filetypes_gz_out{$key}),$percent);
				}
				else {
					printf("<TD>%s</TD><TD>&nbsp;</TD><TD>&nbsp;</TD>",Format_Bytes($_filetypes_k{$key}));
				}
			}
			else {
				printf("<TD>%s</TD>",Format_Bytes($_filetypes_k{$key}));
			}
			print "</TR>\n";
			$count++;
		}
		&tab_end;
	}
		
	# BY FILE SIZE
	#-------------------------
	if ($ShowFileSizesStats) {
		
	}
	
	# BY BROWSER
	#----------------------------
	if ($ShowBrowsersStats) {
		my $Total=0; foreach my $key (keys %_browser_h) { $Total+=$_browser_h{$key}; }
		print "$CENTER<a name=\"BROWSER\">&nbsp;</a><BR>";
		&tab_head($Message[21],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>Browser</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[15]</TH></TR>\n";
		$count=0; 
		foreach my $key (sort { $SortDir*$_browser_h{$a} <=> $SortDir*$_browser_h{$b} } keys (%_browser_h)) {
			my $p=int($_browser_h{$key}/$Total*1000)/10;
			if ($key eq "Unknown") {
				print "<TR><TD CLASS=AWL><a href=\"$DirCgi$PROG.$Extension?output=unknownrefererbrowser&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[0]</a></TD><TD>$_browser_h{$key}</TD><TD>$p&nbsp;%</TD></TR>\n";
			}
			else {
				print "<TR><TD CLASS=AWL>$BrowsersHashIDLib{$key}</TD><TD>$_browser_h{$key}</TD><TD>$p&nbsp;%</TD></TR>\n";
			}
			$count++;
		}
		&tab_end;
	}	
	
	# BY OS
	#----------------------------
	if ($ShowOSStats) {
		my $Total=0; foreach my $key (keys %_os_h) { $Total+=$_os_h{$key}; }
		print "$CENTER<a name=\"OS\">&nbsp;</a><BR>";
		&tab_head($Message[59],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH colspan=2>OS</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[15]</TH></TR>\n";
		$count=0; 
		foreach my $key (sort { $SortDir*$_os_h{$a} <=> $SortDir*$_os_h{$b} } keys (%_os_h)) {
			my $p=int($_os_h{$key}/$Total*1000)/10;
			if ($key eq "Unknown") {
				print "<TR><TD><IMG SRC=\"$DirIcons\/os\/unknown.png\"></TD><TD CLASS=AWL><a href=\"$DirCgi$PROG.$Extension?output=unknownreferer&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$Message[0]</a></TD><TD>$_os_h{$key}&nbsp;</TD>";
				print "<TD>$p&nbsp;%</TD></TR>\n";
				}
			else {
				my $nameicon = $OSHashLib{$key}; $nameicon =~ s/\s.*//; $nameicon =~ tr/A-Z/a-z/;
				print "<TR><TD><IMG SRC=\"$DirIcons\/os\/$nameicon.png\"></TD><TD CLASS=AWL>$OSHashLib{$key}</TD><TD>$_os_h{$key}</TD>";
				print "<TD>$p&nbsp;%</TD></TR>\n";
			}
			$count++;
		}
		&tab_end;
	}	
	
	# BY REFERENCE
	#---------------------------
	if ($ShowOriginStats) {
		print "$CENTER<a name=\"REFERER\">&nbsp;</a><BR>";
		&tab_head($Message[36],19);
		my @p_p=();
		if ($TotalPages > 0) {
			$p_p[0]=int($_from_p[0]/$TotalPages*1000)/10;
			$p_p[1]=int($_from_p[1]/$TotalPages*1000)/10;
			$p_p[2]=int($_from_p[2]/$TotalPages*1000)/10;
			$p_p[3]=int($_from_p[3]/$TotalPages*1000)/10;
			$p_p[4]=int($_from_p[4]/$TotalPages*1000)/10;
		}
		my @p_h=();
		if ($TotalHits > 0) {
			$p_h[0]=int($_from_h[0]/$TotalHits*1000)/10;
			$p_h[1]=int($_from_h[1]/$TotalHits*1000)/10;
			$p_h[2]=int($_from_h[2]/$TotalHits*1000)/10;
			$p_h[3]=int($_from_h[3]/$TotalHits*1000)/10;
			$p_h[4]=int($_from_h[4]/$TotalHits*1000)/10;
		}
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH>$Message[37]</TH><TH bgcolor=\"#$color_p\" width=80>$Message[56]</TH><TH bgcolor=\"#$color_p\" width=80>$Message[15]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[15]</TH></TR>\n";
		print "<TR><TD CLASS=AWL><b>$Message[38]:</b></TD><TD>$_from_p[0]&nbsp;</TD><TD>$p_p[0]&nbsp;%</TD><TD>$_from_h[0]&nbsp;</TD><TD>$p_h[0]&nbsp;%</TD></TR>\n";
		#------- Referrals by search engine
		print "<TR onmouseover=\"ShowTooltip(13);\" onmouseout=\"HideTooltip(13);\"><TD CLASS=AWL><b>$Message[40] :</b><br>\n";
		print "<TABLE>\n";
		$count=0; 
		foreach my $key (sort { $SortDir*$_se_referrals_h{$a} <=> $SortDir*$_se_referrals_h{$b} } keys (%_se_referrals_h)) {
			print "<TR><TD CLASS=AWL>- $SearchEnginesHashIDLib{$key} </TD><TD align=right>$_se_referrals_h{\"$key\"}</TD></TR>\n";
			$count++;
		}
		print "</TABLE></TD>\n";
		print "<TD valign=top>$_from_p[2]&nbsp;</TD><TD valign=top>$p_p[2]&nbsp;%</TD><TD valign=top>$_from_h[2]&nbsp;</TD><TD valign=top>$p_h[2]&nbsp;%</TD></TR>\n";
		#------- Referrals by external HTML link
		print "<TR onmouseover=\"ShowTooltip(14);\" onmouseout=\"HideTooltip(14);\"><TD CLASS=AWL><b>$Message[41]:</b><br>\n";
		print "<TABLE>\n";
		$count=0; $rest_h=0;
		foreach my $key (sort { $SortDir*$_pagesrefs_h{$a} <=> $SortDir*$_pagesrefs_h{$b} } keys (%_pagesrefs_h)) {
			if ($count>=$MaxNbOfRefererShown) { $rest_h+=$_pagesrefs_h{$key}; next; }
			if ($_pagesrefs_h{$key}<$MinHitRefer) { $rest_h+=$_pagesrefs_h{$key}; next; }
			my $nompage=$key;
			if (length($nompage)>$MaxLengthOfURL) { $nompage=substr($nompage,0,$MaxLengthOfURL)."..."; }
			if ($ShowLinksOnUrl && ($key =~ /^http(s|):\/\//i)) {
				print "<TR><TD CLASS=AWL>- <A HREF=\"$key\">$nompage</A></TD><TD>$_pagesrefs_h{$key}</TD></TR>\n";
			} else {
				print "<TR><TD CLASS=AWL>- $nompage</TD><TD>$_pagesrefs_h{$key}</TD></TR>\n";
			}
			$count++;
		}
		if ($rest_h > 0) {
			print "<TR><TD CLASS=AWL><font color=blue>- $Message[2]</TD><TD>$rest_h</TD>";
		}
		print "</TABLE></TD>\n";
		print "<TD valign=top>$_from_p[3]&nbsp;</TD><TD valign=top>$p_p[3]&nbsp;%</TD><TD valign=top>$_from_h[3]&nbsp;</TD><TD valign=top>$p_h[3]&nbsp;%</TD></TR>\n";
		#------- Referrals by internal HTML link
		print "<TR><TD CLASS=AWL><b>$Message[42]:</b></TD><TD>$_from_p[4]&nbsp;</TD><TD>$p_p[4]&nbsp;%</TD><TD>$_from_h[4]&nbsp;</TD><TD>$p_h[4]&nbsp;%</TD></TR>\n";
		print "<TR><TD CLASS=AWL><b>$Message[39]:</b></TD><TD>$_from_p[1]&nbsp;</TD><TD>$p_p[1]&nbsp;%</TD><TD>$_from_h[1]&nbsp;</TD><TD>$p_h[1]&nbsp;%</TD></TR>\n";
		&tab_end;
	}	
	
	# BY SEARCH PHRASES
	#----------------------------
	if ($ShowKeyphrasesStats) {
		my $TotalDifferentKeyphrases=scalar keys %_keyphrases;
		my $TotalKeyphrases=0; foreach my $key (keys %_keyphrases) { $TotalKeyphrases+=$_keyphrases{$key}; }
		print "$CENTER<a name=\"SEARCHWORDS\">&nbsp;</a><BR>";
		$MaxNbOfKeywordsShown = $TotalDifferentKeyphrases if $MaxNbOfKeywordsShown > $TotalDifferentKeyphrases;
		&tab_head("$Message[77] $MaxNbOfKeywordsShown $Message[55] $TotalDifferentKeyphrases $Message[43]",19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\" onmouseover=\"ShowTooltip(15);\" onmouseout=\"HideTooltip(15);\"><TH>$Message[13]</TH><TH bgcolor=\"#$color_s\" width=80>$Message[14]</TH><TH bgcolor=\"#$color_s\" width=80>$Message[15]</TH></TR>\n";
		$count=0; $rest=0;
		foreach my $key (sort { $SortDir*$_keyphrases{$a} <=> $SortDir*$_keyphrases{$b} } keys (%_keyphrases)) {
			if ($count>=$MaxNbOfKeywordsShown) { $rest+=$_keyphrases{$key}; next; }
			if ($_keyphrases{$key}<$MinHitKeyword) { $rest+=$_keyphrases{$key}; next; }
			my $p=int($_keyphrases{$key}/$TotalKeyphrases*1000)/10;
			my $mot = $key; $mot =~ s/\+/ /g;	# Showing $key without +
			print "<TR><TD CLASS=AWL>$mot</TD><TD>$_keyphrases{$key}</TD><TD>$p&nbsp;%</TD></TR>\n";
			$count++;
		}
		if ($rest > 0) {
			if ($TotalKeyphrases > 0) { $p=int($rest/$TotalKeyphrases*1000)/10; }
			print "<TR><TD CLASS=AWL><font color=blue>$Message[30]</TD><TD>$rest</TD>";
			print "<TD>$p&nbsp;%</TD></TR>\n";
		}
		&tab_end;
	}	

	# BY ERRORS
	#----------------------------
	if ($ShowHTTPErrorsStats) {
		print "$CENTER<a name=\"ERRORS\">&nbsp;</a><BR>";
		&tab_head($Message[32],19);
		print "<TR bgcolor=\"#$color_TableBGRowTitle\"><TH colspan=2>$Message[32]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[57]</TH><TH bgcolor=\"#$color_h\" width=80>$Message[15]</TH></TR>\n";
		$count=0;
		foreach my $key (sort { $SortDir*$_errors_h{$a} <=> $SortDir*$_errors_h{$b} } keys (%_errors_h)) {
			my $p=int($_errors_h{$key}/$TotalErrors*1000)/10;
			if ($httpcode{$key}) { print "<TR onmouseover=\"ShowTooltip($key);\" onmouseout=\"HideTooltip($key);\">"; }
			else { print "<TR>"; }
			if ($key == 404) { print "<TD><a href=\"$DirCgi$PROG.$Extension?output=notfounderror&".($SiteConfig?"config=$SiteConfig&":"")."year=$YearRequired&month=$MonthRequired&lang=$Lang\">$key</a></TD>"; }
			else { print "<TD>$key</TD>"; }
			if ($httpcode{$key}) { print "<TD CLASS=AWL>$httpcode{$key}</TD><TD>$_errors_h{$key}</TD><TD>$p&nbsp;%</TD></TR>\n"; }
			else { print "<TD CLASS=AWL>Unknown error</TD><TD>$_errors_h{$key}</TD><TD>$p&nbsp;%</TD></TR>\n"; }
			$count++;
		}
		&tab_end;
	}
	
	&html_end;

}
else {
	print "Lines in file: $NbOfLinesRead, found $NbOfNewLinesProcessed new records, $NbOfLinesCorrupted corrupted records.\n";
}

0;	# Do not remove this line




# Informations from microsoft for detecting windows version
#  Windows 95 retail, OEM     4.00.950                     7/11/95
#  Windows 95 retail SP1      4.00.950A                    7/11/95-12/31/95
#  OEM Service Release 2      4.00.1111* (4.00.950B)       8/24/96
#  OEM Service Release 2.1    4.03.1212-1214* (4.00.950B)  8/24/96-8/27/97  
#  OEM Service Release 2.5    4.03.1214* (4.00.950C)       8/24/96-11/18/97
#  Windows 98 retail, OEM     4.10.1998                    5/11/98
#  Windows 98 Second Edition  4.10.2222A                   4/23/99
#  Windows Me                 4.90.3000 
