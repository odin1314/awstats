# AWSTATS BROWSERS DATABASE
#-------------------------------------------------------
# If you want to add a Browser to extend AWStats database detection capabilities,
# you must add an entry in BrowsersSearchIDOrder and in BrowsersHashIDLib.
#-------------------------------------------------------
# $Revision: 1.10 $ - $Author: eldy $ - $Date: 2009-08-08 11:48:45 $

# Originale version by malu
# 2006-05-15 Sean Carlos http://www.antezeta.com/awstats.html 
# 				akregator (rss)
#				AppleSyndication  (rss)
#				BlogBridge http://www.blogbridge.com/ (rss)
#				BonEcho (Firefox 2.0 alpha)
#				FeedTools http://sporkmonger.com/projects/feedtools/ (rss)
#				gnome\-vfs.*neon http://www.webdav.org/neon/
#				GreatNews  http://www.curiostudio.com/ (rss)
#				Gregarius devlog.gregarius.net/docs/ua (rss)
#				hatena rss http://r.hatena.ne.jp/ (rss)
#				Liferea http://liferea.sourceforge.net/ (rss)
#				PubSub-RSS-Reader http://www.pubsub.com/ (rss)
# 2006-05-20 Sean Carlos http://www.antezeta.com/awstats.html
#				Potu Rss-Reader http://www.potu.com/
#				OSSProxy http://www.marketscore.com/FAQ.Aspx

#package AWSUA;


# BrowsersSearchIDOrder
# This list is used to know in which order to search Browsers IDs (Most
# frequent one are first in this list to increase detect speed).
# It contains all matching criteria to search for in log fields.
# Note: Regex IDs are in lower case and ' ' and '+' are changed into '_'
#-------------------------------------------------------
@BrowsersSearchIDOrder = (
# Most frequent standard web browsers are first in this list (except msie, netscape and firefox)
'chrome',
'firebird',
'go!zilla',
'icab',
'konqueror',
'links',
'lynx',
'omniweb',
'opera',
# Other standard web browsers
'22acidownload',
'aol\-iweng',
'amaya',
'amigavoyager',
'aweb',
'bonecho',
'bpftp',
'camino',
'chimera',
'cyberdog',
'dillo',
'doris',
'dreamcast',
'xbox',
'downloadagent',
'ecatch',
'emailsiphon',
'encompass',
'epiphany',
'friendlyspider',
'fresco',
'galeon',
'flashget',
'freshdownload',
'getright',
'leechget',
'netants',
'headdump',
'hotjava',
'ibrowse',
'intergo',
'k\-meleon',
'linemodebrowser',
'lotus\-notes',
'macweb',
'multizilla',
'ncsa_mosaic',
'netcaptor',
'netpositive',
'nutscrape',
'msfrontpageexpress',
'phoenix',
'shiira',               # Must be before safari
'safari',				# Must be after a lot of others (shiira, chrome)
'tzgeturl',
'viking',
'webfetcher',
'webexplorer',
'webmirror',
'webvcr',
# Site grabbers
'teleport',
'webcapture',
'webcopier',
# Media only browsers
'real',
'winamp',				# Works for winampmpeg and winamp3httprdr
'windows\-media\-player',
'audion',
'freeamp',
'itunes',
'jetaudio',
'mint_audio',
'mpg123',
'mplayer',
'nsplayer',
'qts',
'sonique',
'uplayer',
'xaudio',
'xine',
'xmms',
# RSS Readers
'abilon',
'aggrevator',
'aiderss',
'akregator',
'applesyndication',
'betanews_reader',
'blogbridge',
'cyndicate',
'feeddemon', 
'feedreader', 
'feedtools',
'greatnews',
'gregarius',
'hatena_rss', 
'jetbrains_omea', 
'liferea',
'netnewswire', 
'newsfire', 
'newsgator', 
'newzcrawler',
'plagger',
'pluck', 
'potu',
'pubsub\-rss\-reader',
'pulpfiction', 
'rssbandit', 
'rssreader',
'rssowl', 
'rss\sxpress',
'rssxpress',
'sage', 
'sharpreader', 
'shrook', 
'straw', 
'syndirella', 
'vienna',
'wizz\srss\snews\sreader',
# PDA/Phonecell browsers
'alcatel\-be4',
'alcatel\-be5',
'alcatel\-bf3',
'alcatel\-bf4',
'alcatel\-bf5',
'alcatel\-bg3',
'alcatel\-bh4',
'auditautomatic',
'ericssonr520',
'ericssont20',
'ericssont29',
'ericssont39',
'ericssont65',
'ericssont66',
'ericssont68',
'lg\-g7000',
'mitsu',
'mot\-c350m',
'mot\-c4',
'mot\-cb',
'mot\-d4',
'mot\-d5',
'mot\-d8',
'mot\-e1',
'mot\-f0',
'mot\-f6',
'mot\-pan4',
'mot\-phx4',
'mot\-sap4',
'mot\-t720',
'mot\-ta02',
'mot\-v66m',
'mot\-v708',
'mot\-8300',
'mot\-a\-86',
'mot\-af',
'mot\-c2',
'mot\-c350',
'mot\-c550',
'mot\-c650',
'mot\-cf',
'mot\-f5',
'mot\-fe',
'mot\-t280',
'mot\-v300',
'mot\-v400',
'mot\-v500',
'mot\-v525',
'mot\-v600',
'mot\-v60m',
'mot\-v80',
'mot\-v810',
'nokia3100',
'nokia3200',
'nokia3560',
'nokia3595',
'nokia6220',
'nokia8265',
'nokia3300',
'nokia3530',
'nokia3590',
'nokia6108',
'nokia6211',
'nokia6600',
'nokia6650',
'nokia9210',
'nokian\-gage',
'nokia3210',
'nokia3310',
'nokia3330',
'nokia3350',
'nokia3410',
'nokia3510',
'nokia3650',
'nokia5100',
'nokia5110',
'nokia5130',
'nokia5210',
'nokia5510',
'nokia6100',
'nokia6110',
'nokia6130',
'nokia6150',
'nokia6210',
'nokia6250',
'nokia6310\/',
'nokia6310i',
'nokia6500',
'nokia6510',
'nokia6610',
'nokia6800',
'nokia7110',
'nokia7210',
'nokia7250',
'nokia7650',
'nokia8110i',
'nokia8210',
'nokia8310',
'nokia8810',
'nokia8850',
'nokia8855',
'nokia8890',
'nokia8910',
'nokia9000',
'nokia9110',
'nokia9210i',
'nokia3660',
'nokia6230',
'nokia6340i',
'nokia6810',
'nokia6820',
'nokia7200',
'nokia7600',
'nokia7610',
'nokia6500',
'nokia5310',
'nokia6300',
'nokia6131',
'nokia5200',
'nokia7370',
'nokia5610',
'nokian70',
'opwv\-sdk',
'panasonic\-gad35',
'panasonic\-gad67',
'panasonic\-gad68',
'panasonic\-gad6\*',
'panasonic\-gad75',
'panasonic\-gad76',
'panasonic\-gad87',
'panasonic\-gad88',
'panasonic\-gad95',
'panasonic\-gad96',
'panasonic\-g50',
'panasonic\-g60',
'panasonic\-x60',
'panasonic\-x70',
'philips\-az\@lis238',
'philips\-az\@lis268',
'philips\-az\@lis288',
'philips\-fisio120',
'philips\-fisio121',
'philips\-fisio311',
'philips\-fisio312',
'philips\-fisio316',
'philips\-fisio610',
'philips\-fisio620',
'philips\-fisio_625',
'philips\-fisio_820',
'philips\-fisio_822',
'philips\-fisio_825',
'philips\-v21wap',
'philips\-xenium9\@9',
'r380',
'r600',
'sagem\-3xxx',
'sagem\-9xx',
'sagem\-myx\-2',
'sagem\-myx\-3',
'sagem\-myx\-5\/',
'sagem\-myx\-5d',
'sagem\-myx\-5m',
'sagem\-myx\-6',
'samsung\-sgh\-e700',
'samsung\-sgh\-s500',
'samsung\-sgh\-t500',
'samsung\-sgh\-a300',
'samsung\-sgh\-a400',
'samsung\-sgh\-a800',
'samsung\-sgh\-n100',
'samsung\-sgh\-n400_up',
'samsung\-sgh\-n500',
'samsung\-sgh\-n600',
'samsung\-sgh\-n620',
'samsung\-sgh\-r200s',
'samsung\-sgh\-r200',
'samsung\-sgh\-r210',
'samsung\-sgh\-s100',
'samsung\-sgh\-t100',
'samsung\-sgh\-t400',
'samsung\-sgh\-v200',
'samsung_sgh\-x100',
'samsung\-sgh\-e100',
'samsung\-sgh\-e708',
'samsung\-sgh\-e800',
'samsung\-sgh\-x100',
'samsung\-sgh\-x600',
'sec\-sghc100',
'sec\-sghp100',
'sec\-sghp400',
'sec\-sghq200',
'sec\-sghs200',
'sec\-spha460',
'sec\-sghs100',
'sec\-sghs300',
'sec\-sghv200',
'sec\-sghv205',
'sec\-sghd410',
'sec\-sghe105',
'sec\-sghe410',
'sec\-sghe400',
'sec\-sghe600',
'sec\-sghe710',
'sec\-sghe715',
'sec\-sghs105',
'sec\-sghx105',
'sec\-sghx426',
'sec\-sghx427',
'sec\-sghx430',
'sec\-sghx450',
'sharp\-tq\-gx10',
'sharp\-tq\-gx12',
'sie\-2128',
'sie\-6618',
'sie\-a55',
'sie\-c60',
'sie\-c62',
'sie\-m55',
'sie\-mc60',
'sie\-sl55',
'sie\-slin',
'sie\-a50',
'sie\-c3i',
'sie\-c45',
'sie\-c55',
'sie\-m50',
'sie\-me45',
'sie\-mt50',
'sie\-s35',
'sie\-s40',
'sie\-s45',
'sie\-s55',
'sie\-sl45',
'sie\-slik',
'sie\-a57',
'sie\-a60',
'sie\-c56',
'sie\-c61',
'sie\-cf62',
'sie\-m65',
'sie\-s56',
'sie\-s57c',
'sie\-s65',
'sie\-sl5e',
'sie\-st60',
'sie\-sx1',
'sonyericssonp900',
'sonyericssont230',
'sonyericssont306',
'sonyericssont316',
'sonyericssont616',
'sonyericssonz600',
'sonyericssonp800',
'sonyericssont100',
'sonyericssont200',
'sonyericssont300',
'sonyericssont310',
'sonyericssont600',
'sonyericssont610',
'sonyericssont68\/',
'sonyericssont68i',
'sonyericssont620',
'sonyericssont630',
'lg\-c1100',
'lg\-c1200',
'lg\-c2200',
'lg\-g1500',
'lg\-g3100',
'lg\-g4015',
'lg\-g5300',
'lg\-g5400',
'lg\-g7050',
'lg\-g7100',
'lg\-l1100',
'lg\-l1200',
'mot\-85',
'mot\-a\-0a',
'mot\-a\-2b',
'mot\-c357',
'mot\-c380',
'mot\-e398',
'mot\-v180',
'mot\-v220',
'mot\-v3',
'mot\-v980',
'nokia2650',
'nokia3108',
'nokia3120',
'nokia3220',
'nokia5140',
'nokia6010',
'nokia6170',
'nokia6260',
'nokia6630',
'nokia6670',
'nokia7260',
'sie\-a65',
'sie\-c65',
'sie\-c6v',
'sie\-cx65',
'sie\-cx70',
'sie\-sl65',
'sonyericssonk500i',
'sonyericssonk700c',
'sonyericssonk700i',
'sonyericssonp910i',
'sonyericssons700i',
'sonyericssont226',
'sonyericssont628',
'sonyericssonz1010',
'sonyericssonz200',
'alcatel\-be3',
'alcatel\-oh5',
'alcatel\-th3',
'alcatel\-th4',
'ericssona2628s',
'ericssonr320',
'lg\-c1300',
'lg\-c3100',
'lg\-f2100',
'lg\-g1600',
'lg\-g210',
'lg\-g4010',
'lg\-g510',
'lg\-g5310',
'lg\-g5600',
'lg\-g650',
'lg\-g7070',
'lg\-l3100',
'lg\-t5100',
'mot\-2200',
'mot\-32',
'mot\-74',
'mot\-76',
'mot\-87',
'mot\-8700',
'mot\-a\-0e',
'mot\-a\-1c',
'mot\-a760',
'mot\-a835',
'mot\-c385',
'mot\-v26x',
'mot\-v290',
'mot\-v505',
'mot\-v547',
'mot\-v551',
'mot\-v620',
'mot\-v690',
'mot\-v878',
'sie\-3618',
'sie\-a56',
'sie\-c6c',
'sie\-cx6c',
'sie\-cx6v',
'sie\-m6c',
'sie\-m6v',
'sie\-s46',
'sie\-sk65',
'sie\-sl56',
'sie\-st55',
'sagem\-mo130',
'sagem\-myc',
'sagem\-myv',
'sagem\-myx3',
'sagem\-myx5',
'sagem\-myx',
'lg\-G610',
'mot\-v550',
'mot\-a\-1f',
'mot\-c155',
'mot\-c975',
'mot\-c980',
'mot\-e380',
'mot\-e680',
'mot\-ed',
'mot\-t725e',
'mot\-v150',
'mot\-v171',
'mot\-v535',
'mot\-v545',
'mot\-v635',
'mot\-v870',
'nokia2112',
'nokia3620',
'nokia6020',
'nokia6200',
'nokia6620',
'nokia6680',
'nokia7270',
'nokia7280',
'nokia9500',
'panasonic\-a200',
'panasonic\-g70',
'panasonic\-x100',
'panasonic\-x300',
'panasonic\-x400',
'panasonic\-x500',
'panasonic\-x66',
'panasonic\-x77',
't66',
'n21i',
'n22i',
'ts21i',
'wap',					# Generic WAP phone (must be after 'wap*')
'up\.',					# Works for UP.Browser and UP.Link
# PDA/Phonecell browsers
'blackberry',
'cnf2',
'docomo',
'ipcheck',
'iphone',
'portalmmm',
# Others (TV)
'webtv',
# Anonymous Proxy Browsers (can be used as grabbers as well...)
'cjb\.net',
'ossproxy',
# Other kind of browsers
'adobeair',
'apt',
'analogx_proxy',
'gnome\-vfs',
'neon',
'curl',
'csscheck',
'httrack',
'fdm',
'javaws',
'wget',
'chilkat',
'webdownloader\sfor\sx',
'w3m',
'wdg_validator',
'webreaper',
'webzip',
'staroffice',
'gnus',
'nikto',
'microsoft\-webdav\-miniredir',
'microsoft\sdata\saccess\sinternet\spublishing\sprovider\scache\smanager',
'microsoft\sdata\saccess\sinternet\spublishing\sprovider\sdav',
'POE\-Component\-Client\-HTTP',
'mozilla',				# Must be at end because a lot of browsers contains mozilla in string
'libwww',				# Must be at end because some browser have both 'browser id' and 'libwww'
'lwp'
);

# BrowsersHashIDLib
# List of browser's name ('browser id in lower case', 'browser text')
#---------------------------------------------------------------
%BrowsersHashIDLib = (
# Common web browsers text
'msie','MS Internet Explorer',
'netscape','Netscape',
'firefox','Firefox',
'svn', 'Subversion client', 

'chrome','Google Chrome',
'firebird','Firebird (Old Firefox)',
'go!zilla','Go!Zilla',
'icab','iCab',
'konqueror','Konqueror',
'links','Links',
'lynx','Lynx',
'omniweb','OmniWeb',
'opera','Opera',
# Other standard web browsers
'22acidownload','22AciDownload',
'aol\-iweng','AOL-Iweng',
'amaya','Amaya',
'amigavoyager','AmigaVoyager',
'aweb','AWeb',
'bonecho','<a href="http://www.mozilla.org/projects/bonecho/" title="Browser home page [new window]" target="_blank">BonEcho (Firefox 2.0 development)</a>',
'bpftp','BPFTP',
'camino','Camino',
'chimera','Chimera (Old Camino)',
'cyberdog','Cyberdog',
'dillo','Dillo',
'doris','Doris (for Symbian)',
'dreamcast','Dreamcast',
'xbox', 'XBoX',
'downloadagent','DownloadAgent',
'ecatch', 'eCatch',
'emailsiphon','EmailSiphon',
'encompass','Encompass',
'epiphany','Epiphany',
'friendlyspider','FriendlySpider',
'fresco','ANT Fresco',
'galeon','Galeon',
'flashget','FlashGet',
'freshdownload','FreshDownload',
'getright','GetRight',
'leechget','LeechGet',
'netants','NetAnts',
'headdump','HeadDump',
'hotjava','Sun HotJava',
'ibrowse','iBrowse',
'intergo','InterGO',
'k\-meleon','K-Meleon',
'linemodebrowser','W3C Line Mode Browser',
'lotus\-notes','Lotus Notes web client',
'macweb','MacWeb',
'multizilla','MultiZilla',
'ncsa_mosaic','NCSA Mosaic',
'netcaptor','NetCaptor',
'netpositive','NetPositive',
'nutscrape', 'Nutscrape',
'msfrontpageexpress','MS FrontPage Express',
'phoenix','Phoenix',
'shiira','Shiira',
'safari','Safari',
'tzgeturl','TzGetURL',
'viking','Viking',
'webfetcher','WebFetcher',
'webexplorer','IBM-WebExplorer',
'webmirror','WebMirror',
'webvcr','WebVCR',
# Site grabbers
'teleport','TelePort Pro',
'webcapture','Acrobat Webcapture',
'webcopier', 'WebCopier',
# Media only browsers
'real','Real player or compatible (media player)',
'winamp','WinAmp (media player)',				# Works for winampmpeg and winamp3httprdr
'windows\-media\-player','Windows Media Player (media player)',
'audion','Audion (media player)',
'freeamp','FreeAmp (media player)',
'itunes','Apple iTunes (media player)',
'jetaudio','JetAudio (media player)',
'mint_audio','Mint Audio (media player)',
'mpg123','mpg123 (media player)',
'mplayer','The Movie Player (media player)',
'nsplayer','NetShow Player (media player)',
'qts','Quicktime',
'quicktime','QuickTime',
'sonique','Sonique (media player)',
'uplayer','Ultra Player (media player)',
'xaudio','Some XAudio Engine based MPEG player (media player)',
'xine','Xine, a free multimedia player (media player)',
'xmms','XMMS (media player)',
# RSS Readers
'abilon','Abilon (RSS Reader)',
'aggrevator', 'Aggrevator (RSS Reader)',
'aiderss', 'AideRSS (RSS Reader)',
'akregator','<a href="http://akregator.sourceforge.net/" title="Browser home page [new window]" target="_blank">Akregator (RSS Reader)</a>',  
'applesyndication','<a href="http://www.apple.com/macosx/features/safari/" title="Browser home page [new window]" target="_blank">AppleSyndication (RSS Reader)</a>',
'betanews_reader','Betanews Reader (RSS Reader)',
'blogbridge','<a href="http://www.blogbridge.com/" title="Browser home page [new window]" target="_blank">BlogBridge (RSS Reader)</a>',
'cyndicate','Cyndicate (RSS Reader)',
'feeddemon', 'FeedDemon (RSS Reader)',
'feedreader', 'FeedReader (RSS Reader)',
'feedtools','<a href="http://sporkmonger.com/projects/feedtools/" title="Browser home page [new window]" target="_blank">FeedTools (RSS Reader)</a>',
'greatnews','<a href="http://www.curiostudio.com/" title="Browser home page [new window]" target="_blank">GreatNews (RSS Reader)</a>',
'gregarius','<a href="http://devlog.gregarius.net/docs/ua" title="Browser home page [new window]" target="_blank">Gregarius (RSS Reader)</a>',
'hatena_rss','<a href="http://r.hatena.ne.jp/" title="Browser home page [new window]" target="_blank">Hatena (RSS Reader)</a>',
'jetbrains_omea', 'Omea (RSS Reader)',
'liferea','<a href="http://liferea.sourceforge.net/" title="Browser home page [new window]" target="_blank">Liferea (RSS Reader)</a>',
'netnewswire', 'NetNewsWire (RSS Reader)',
'newsfire', 'NewsFire (RSS Reader)',
'newsgator', 'NewsGator (RSS Reader)',
'newzcrawler', 'NewzCrawler (RSS Reader)',
'plagger', 'Plagger (RSS Reader)',
'pluck', 'Pluck (RSS Reader)',
'potu','<a href="http://www.potu.com/" title="Potu Rss-Reader home page [new window]" target="_blank">Potu (RSS Reader)</a>',
'pubsub\-rss\-reader','<a href="http://www.pubsub.com/" title="Browser home page [new window]" target="_blank">PubSub (RSS Reader)</a>',
'pulpfiction', 'PulpFiction (RSS Reader)',
'rssbandit', 'RSS Bandit (RSS Reader)',
'rssreader', 'RssReader (RSS Reader)',
'rssowl', 'RSSOwl (RSS Reader)',
'rss\sxpress','RSS Xpress (RSS Reader)',
'rssxpress','RSSXpress (RSS Reader)',
'sage', 'Sage (RSS Reader)',
'sharpreader', 'SharpReader (RSS Reader)',
'shrook', 'Shrook (RSS Reader)',
'straw', 'Straw (RSS Reader)',
'syndirella', 'Syndirella (RSS Reader)',
'vienna', '<a href="http://www.opencommunity.co.uk/vienna2.php" title="Vienna RSS-Reader [new window]" target="_blank">Vienna (RSS Reader)</a>',
'wizz\srss\snews\sreader','Wizz RSS News Reader (RSS Reader)',
# PDA/Phonecell browsers
'alcatel\-be4','Alcatel BE4 (phone)',
'alcatel\-be5','Alcatel BE5 (phone)',
'alcatel\-bf3','Alcatel OT311 (phone)',
'alcatel\-bf4','Alcatel OT511 (phone)',
'alcatel\-bf5','Alcatel BF5 (phone)',
'alcatel\-bg3','Alcatel BG3 (phone)',
'alcatel\-bh4','Alcatel BH4 (phone)',
'auditautomatic','Audit ByTel (phone)',
'ericssonr520','SonyEricsson R520-R2 (phone)',
'ericssont20','SonyEricsson T20e (phone)',
'ericssont29','SonyEricsson 29s (phone)',
'ericssont39','SonyEricsson T39m (phone)',
'ericssont65','SonyEricsson T65 (phone)',
'ericssont66','SonyEricsson T66 (phone)',
'ericssont68','SonyEricsson T68 (phone)',
'lg\-g7000','LG G7000 (phone)',
'mitsu','Trium Eclipse (phone)',
'mot\-c350m','Motorola C350M (phone)',
'mot\-c4','Motorola Talkabout T2288 (phone)',
'mot\-cb','Motorola Timeport P7389 (phone)',
'mot\-d4','Motorola Timeport P7389e (phone)',
'mot\-d5','motorola-t191 (phone)',
'mot\-d8','Motorola T250 (phone)',
'mot\-e1','Motorola ? (E1) (phone)',
'mot\-f0','Motorola v50 (phone)',
'mot\-f6','Motorola Accompli 008 (phone)',
'mot\-pan4','Motorola T280 (phone)',
'mot\-phx4','Motorola ? (PHX4) (phone)',
'mot\-sap4','Motorola V66 (phone)',
'mot\-t720','Motorola T720 (phone)',
'mot\-ta02','Motorola ? (TA02) (phone)',
'mot\-v66m','Motorola V66M (phone)',
'mot\-v708','Motorola V708 (phone)',
'mot\-8300','Motorola 8300 (phone)',
'mot\-a-86','Motorola A86 (phone)',
'mot\-af','Motorola AF (phone)',
'mot\-c2','Motorola C2 (phone)',
'mot\-c350','Motorola C350 (phone)',
'mot\-c550','Motorola C550 (phone)',
'mot\-c650','Motorola C650 (phone)',
'mot\-cf','Motorola CF (phone)',
'mot\-f5','Motorola F5 (phone)',
'mot\-fe','Motorola FE (phone)',
'mot\-t280','Motorola T280 (phone)',
'mot\-v300','Motorola V300 (phone)',
'mot\-v400','Motorola V400 (phone)',
'mot\-v500','Motorola V500 (phone)',
'mot\-v525','Motorola V525 (phone)',
'mot\-v600','Motorola V600 (phone)',
'mot\-v60m','Motorola V60M (phone)',
'mot\-v80','Motorola V80 (phone)',
'mot\-v810','Motorola V810 (phone)',
'nokia3200','Nokia 3200 (phone)',
'nokia3560','Nokia 3560 (phone)',
'nokia3595','Nokia 3595 (phone)',
'nokia6220','Nokia 6200 (phone)',
'nokia8265','Nokia 8265 (phone)',
'nokia3100','Nokia 3100 (phone)',
'nokia3300','Nokia 3300 (phone)',
'nokia3530','Nokia 3530 (phone)',
'nokia3590','Nokia 3590 (phone)',
'nokia6108','Nokia 6108 (phone)',
'nokia6211','Nokia 6211 (phone)',
'nokia6600','Nokia 6600 (phone)',
'nokia6650','Nokia 6650 (phone)',
'nokia9210','Nokia 9210 (phone)',
'nokian\-gage','Nokia N-Gage (phone)',
'nokia3210','Nokia 3210 (phone)',
'nokia3310','Nokia 3310 (phone)',
'nokia3330','Nokia 3330 (phone)',
'nokia3350','Nokia 3350 (phone)',
'nokia3410','Nokia 3410 (phone)',
'nokia3510','Nokia 3510 (phone)',
'nokia3650','Nokia 3650 (phone)',
'nokia5100','Nokia 5100 (phone)',
'nokia5110','Nokia 5110 (phone)',
'nokia5130','Nokia 5130 (phone)',
'nokia5210','Nokia 5210 (phone)',
'nokia5510','Nokia 5510 (phone)',
'nokia6100','Nokia 6100 (phone)',
'nokia6110','Nokia 6110 (phone)',
'nokia6130','Nokia 6130 (phone)',
'nokia6150','Nokia 6150 (phone)',
'nokia6210','Nokia 6210 (phone)',
'nokia6250','Nokia 6250 (phone)',
'nokia6310/','Nokia 6310 (phone)',
'nokia6310i','Nokia 6310i (phone)',
'nokia6500','Nokia 6500 (phone)',
'nokia6510','Nokia 6510 (phone)',
'nokia6610','Nokia 6610 (phone)',
'nokia6800','Nokia 6800 (phone)',
'nokia7110','Nokia 7110 (phone)',
'nokia7210','Nokia 7210 (phone)',
'nokia7250','Nokia 7250 (phone)',
'nokia7650','Nokia 7650 (phone)',
'nokia8110i','Nokia 8110i (phone)',
'nokia8210','Nokia 8210 (phone)',
'nokia8310','Nokia 8310 (phone)',
'nokia8810','Nokia 8810 (phone)',
'nokia8850','Nokia 8850 (phone)',
'nokia8855','Nokia 8855 (phone)',
'nokia8890','Nokia 8890 (phone)',
'nokia8910','Nokia 8910 (phone)',
'nokia9000','Nokia 9000i (phone)',
'nokia9110','Nokia 9110 (phone)',
'nokia9210i','Nokia 9210i (phone)',
'nokia3660','Nokia 3660 (phone)',
'nokia6230','Nokia 6230 (phone)',
'nokia6340i','Nokia 6340i (phone)',
'nokia6810','Nokia 6810 (phone)',
'nokia6820','Nokia 6820 (phone)',
'nokia7200','Nokia 7200 (phone)',
'nokia7600','Nokia 7600 (phone)',
'nokia7610','Nokia 7610 (phone)',
'nokia6500','Nokia 6500 (phone)',
'nokia5310','Nokia 5310 (phone)',
'nokia6300','Nokia 6300 (phone)',
'nokia6131','Nokia 6131 (phone)',
'nokia5200','Nokia 5200 (phone)',
'nokia7370','Nokia 7370 (phone)',
'nokia5610','Nokia 5610 (phone)',
'nokian70','Nokia N70 (phone)',
'opwv\-sdk','openwave sdk (phone)',
'panasonic\-gad35','Panasonic GD35 (phone)',
'panasonic\-gad67','panasonic GD67 (phone)',
'panasonic\-gad68','panasonic-gd68 (phone)',
'panasonic\-gad6\*','Panasonic GD6xx (phone)',
'panasonic\-gad75','panasonic-gd75 (phone)',
'panasonic\-gad76','panasonic-gd76 (phone)',
'panasonic\-gad87','panasonic-gd87 (phone)',
'panasonic\-gad88','panasonic-gd88 (phone)',
'panasonic\-gad95','panasonic-gd95 (phone)',
'panasonic\-gad96','panasonic-gd96 (phone)',
'panasonic\-g50','Panasonic G50 (phone)',
'panasonic\-g60','Panasonic G60 (phone)',
'panasonic\-x60','Panasonic X60 (phone)',
'panasonic\-x70','Panasonic X70 (phone)',
'philips\-az\@lis238','Philips Azalis-238 (phone)',
'philips\-az\@lis268','Philips Azalis-268 (phone)',
'philips\-az\@lis288','Philips Azalis-288 (phone)',
'philips\-fisio120','Philips Fisio 120 (phone)',
'philips\-fisio121','Philips Fisio 121 (phone)',
'philips\-fisio311','Philips Fisio 311 (phone)',
'philips\-fisio312','Philips Fisio 312 (phone)',
'philips\-fisio316','Philips Fisio 316 (phone)',
'philips\-fisio610','Philips Fisio 610 (phone)',
'philips\-fisio620','Philips Fisio 620 (phone)',
'philips\-fisio_625','Philips Fisio 625 (phone)',
'philips\-fisio_820','Philips Fisio 820 (phone)',
'philips\-fisio_822','Philips Fisio 822 (phone)',
'philips\-fisio_825','Philips Fisio 825 (phone)',
'philips\-v21wap','Philips V21 (phone)',
'philips\-xenium9\@9','Philips Xenium 9A9 (phone)',
'r380','Ericsson R380 (phone)',
'r600','Ericsson R600 (phone)',
'sagem\-3xxx','Sagem 3XXX (phone)',
'sagem\-9xx','Sagem 9XX (phone)',
'sagem\-myx\-2','Sagem MyX-2 (phone)',
'sagem\-myx\-3','Sagem MyX-3d (phone)',
'sagem\-myx\-5\/','Sagem MyX-5 (phone)',
'sagem\-myx\-5d','Sagem MyX-5d (phone)',
'sagem\-myx\-5m','Sagem MyX-5m (phone)',
'sagem\-myx\-6','Sagem MyX-6 (phone)',
'samsung\-sgh\-e700','Samsung E700 (phone)',
'samsung\-sgh\-s500','Samsung S500 (phone)',
'samsung\-sgh\-t500','Samsung T500 (phone)',
'samsung\-sgh\-a300','Samsung A300 (phone)',
'samsung\-sgh\-a400','Samsung A400 (phone)',
'samsung\-sgh\-a800','Samsung A800 (phone)',
'samsung\-sgh\-n100','Samsung N100 (phone)',
'samsung\-sgh\-n400','Samsung N400 (phone)',
'samsung\-sgh\-n500','Samsung N500 (phone)',
'samsung\-sgh\-n600','Samsung N600 (phone)',
'samsung\-sgh\-n620','Samsung N620 (phone)',
'samsung\-sgh\-r200','Samsung R200 (phone)',
'samsung\-sgh\-r200s','Samsung R200s (phone)',
'samsung\-sgh\-r210','Samsung R210 (phone)',
'samsung\-sgh\-s100','Samsung S100 (phone)',
'samsung\-sgh\-t100','Samsung T100 (phone)',
'samsung\-sgh\-t400','Samsung T400 (phone)',
'samsung\-sgh\-v200','Samsung V200 (phone)',
'samsung\_sgh\-x100','Samsung X100 (phone)',
'samsung\-sgh\-e100','Samsung E100 (phone)',
'samsung\-sgh\-e708','Samsung E700 (phone)',
'samsung\-sgh\-e800','Samsung E800 (phone)',
'samsung\-sgh\-x100','Samsung X100 (phone)',
'samsung\-sgh\-x600','Samsung X600 (phone)',
'sec\-sghc100','Samsung SGHC100 (phone)',
'sec\-sghp100','Samsung SGHP100 (phone)',
'sec\-sghp400','Samsung SGHP400 (phone)',
'sec\-sghq200','Samsung SGHQ200 (phone)',
'sec\-sghs200','Samsung SGHS200 (phone)',
'sec\-spha460','Samsung SPHA460 (phone)',
'sec\-sghs100','Samsung SGHS100 (phone)',
'sec\-sghs300','Samsung SGHS300 (phone)',
'sec\-sghv200','Samsung SGHS200 (phone)',
'sec\-sghv205','Samsung SGHS205 (phone)',
'sec\-sghd410','Samsung SGHD410 (phone)',
'sec\-sghe105','Samsung SGHE105 (phone)',
'sec\-sghe410','Samsung SGHE410 (phone)',
'sec\-sghe400','Samsung SGHE400 (phone)',
'sec\-sghe600','Samsung SGHE600 (phone)',
'sec\-sghe710','Samsung SGHE710 (phone)',
'sec\-sghe715','Samsung SGHE715 (phone)',
'sec\-sghs105','Samsung SGHS105 (phone)',
'sec\-sghx105','Samsung SGHX108 (phone)',
'sec\-sghx426','Samsung SGHX426 (phone)',
'sec\-sghx427','Samsung SGHX427 (phone)',
'sec\-sghx430','Samsung SGHS430 (phone)',
'sec\-sghx450','Samsung SGHS450 (phone)',
'sharp\-tq\-gx10','Sharp TQ-GX10 (phone)',
'sharp\-tq\-gx12','Sharp TQ-GX12 (phone)',
'sie\-2128','Siemens 2128 (phone)',
'sie\-6618','Siemens 66180 (phone)',
'sie\-a55','Siemens A55 (phone)',
'sie\-c60','Siemens C60 (phone)',
'sie\-c62','Siemens C62 (phone)',
'sie\-m55','Siemens M55 (phone)',
'sie\-mc60','Siemens MC60 (phone)',
'sie\-sl55','Siemens SL55 (phone)',
'sie\-slin','Siemens SLIN (phone)',
'sie\-a50','Siemens A50 (phone)',
'sie\-c3i','Siemens C35i (phone)',
'sie\-c45','Siemens C45 (phone)',
'sie\-c55','Siemens C55 (phone)',
'sie\-m50','Siemens M50 (phone)',
'sie\-me45','Siemens ME45 (phone)',
'sie\-mt50','Siemens MT50 (phone)',
'sie\-s35','Siemens S35 (phone)',
'sie\-s40','Siemens S40 (phone)',
'sie\-s45','Siemens S45 (phone)',
'sie\-s55','Siemens S55 (phone)',
'sie\-sl45','Siemens S145 (phone)',
'sie\-slik','Siemens ? (SLIK) (phone)',
'sie\-a57','Siemens A57 (phone)',
'sie\-a60','Siemens A60 (phone)',
'sie\-c56','Siemens C56 (phone)',
'sie\-c61','Siemens C61 (phone)',
'sie\-cf62','Siemens CF62 (phone)',
'sie\-m65','Siemens M65 (phone)',
'sie\-s56','Siemens S56 (phone)',
'sie\-s57c','Siemens S57C (phone)',
'sie\-s65','Siemens S65 (phone)',
'sie\-sl5e','Siemens SL5E (phone)',
'sie\-st60','Siemens ST60 (phone)',
'sie\-sx1','Siemens SX1 (phone)',
'sonyericssonp900','SonyEricsson P900 (phone)',
'sonyericssont230','SonyEricsson T230 (phone)',
'sonyericssont306','SonyEricsson T306 (phone)',
'sonyericssont316','SonyEricsson T316 (phone)',
'sonyericssont616','SonyEricsson T616 (phone)',
'sonyericssonz600','SonyEricsson Z600 (phone)',
'sonyericssonp800','SonyEricsson P800 (phone)',
'sonyericssont100','SonyEricsson T100 (phone)',
'sonyericssont200','SonyEricsson T200 (phone)',
'sonyericssont300','SonyEricsson T300 (phone)',
'sonyericssont310','SonyEricsson T310 (phone)',
'sonyericssont600','SonyEricsson T600 (phone)',
'sonyericssont610','SonyEricsson T610 (phone)',
'sonyericssont68/','SonyEricsson T68 (phone)',
'sonyericssont68i','SonyEricsson T68i (phone)',
'sonyericssont620','SonyEricsson T620 (phone)',
'sonyericssont630','SonyEricsson T630 (phone)',
'lg\-c1100','LG C1100 (phone)',
'lg\-c1200','LG C1200 (phone)',
'lg\-c2200','LG C2200 (phone)',
'lg\-g1500','LG G1500 (phone)',
'lg\-g3100','LG G3100 (phone)',
'lg\-g4015','LG G4015 (phone)',
'lg\-g5300','LG G5300 (phone)',
'lg\-g5400','LG G5400 (phone)',
'lg\-g7050','LG G7050 (phone)',
'lg\-g7100','LG G7100 (phone)',
'lg\-l1100','LG L1100 (phone)',
'lg\-l1200','LG L1200 (phone)',
'mot\-85','Motorola 85 (phone)',
'mot\-a\-0a','Motorola A0A (phone)',
'mot\-a\-2b','Motorola A2b (phone)',
'mot\-c357','Motorola C357 (phone)',
'mot\-c380','Motorola C380 (phone)',
'mot\-e398','Motorola E398 (phone)',
'mot\-v180','Motorola V180 (phone)',
'mot\-v220','Motorola V220 (phone)',
'mot\-v3','Motorola V3 (phone)',
'mot\-v980','Motorola V980 (phone)',
'nokia2650','Nokia 2650 (phone)',
'nokia3108','Nokia 3108 (phone)',
'nokia3120','Nokia 3120 (phone)',
'nokia3220','Nokia 3220 (phone)',
'nokia5140','Nokia 5140 (phone)',
'nokia6010','Nokia 6010 (phone)',
'nokia6170','Nokia 6170 (phone)',
'nokia6260','Nokia 6260 (phone)',
'nokia6630','Nokia 6630 (phone)',
'nokia6670','Nokia 6670 (phone)',
'nokia7260','Nokia 7260 (phone)',
'sie\-a65','Siemens A65 (phone)',
'sie\-c65','Siemens C65 (phone)',
'sie\-c6v','Siemens C6V (phone)',
'sie\-cx65','Siemens CX65 (phone)',
'sie\-cx70','Siemens CX70 (phone)',
'sie\-sl65','Siemens SL65 (phone)',
'sonyericssonk500i','SonyEricsson K500i (phone)',
'sonyericssonk700c','SonyEricsson K700c (phone)',
'sonyericssonk700i','SonyEricsson K700i (phone)',
'sonyericssonp910i','SonyEricsson P910i (phone)',
'sonyericssons700i','SonyEricsson S700i (phone)',
'sonyericssont226','SonyEricsson T226 (phone)',
'sonyericssont628','SonyEricsson T628 (phone)',
'sonyericssonz1010','SonyEricsson Z1010 (phone)',
'sonyericssonz200','SonyEricsson Z200 (phone)',
'alcatel\-be3','Alcatel BE3 (phone)',
'alcatel\-oh5','Alcatel OH5 (phone)',
'alcatel\-th3','Alcatel TH3 (phone)',
'alcatel\-th4','Alcatel TH4 (phone)',
'ericssona2628s','Ericsson A2628s (phone)',
'ericssonr320','Ericsson R320 (phone)',
'lg\-c1300','LG C1300 (phone)',
'lg\-c3100','LG C3100 (phone)',
'lg\-f2100','LG F2100 (phone)',
'lg\-g1600','LG G1600 (phone)',
'lg\-g210','LG G210 (phone)',
'lg\-g4010','LG G4010 (phone)',
'lg\-g510','LG G510 (phone)',
'lg\-g5310','LG G5300 (phone)',
'lg\-g5600','LG G5600 (phone)',
'lg\-g650','LG G650 (phone)',
'lg\-g7070','LG G7070 (phone)',
'lg\-l3100','LG L3100 (phone)',
'lg\-t5100','LG T5100 (phone)',
'mot\-2200','Motorola 2200 (phone)',
'mot\-32','Motorola 32 (phone)',
'mot\-74','Motorola 74 (phone)',
'mot\-76','Motorola 76 (phone)',
'mot\-87','Motorola 87 (phone)',
'mot\-8700','Motorola 8700 (phone)',
'mot\-a\-0e','Motorola a0e (phone)',
'mot\-a\-1c','Motorola a1c (phone)',
'mot\-a760','Motorola A760 (phone)',
'mot\-a835','Motorola A835 (phone)',
'mot\-c385','Motorola C385 (phone)',
'mot\-v26x','Motorola V26x (phone)',
'mot\-v290','Motorola V290 (phone)',
'mot\-v505','Motorola V505 (phone)',
'mot\-v547','Motorola V547 (phone)',
'mot\-v551','Motorola V551 (phone)',
'mot\-v620','Motorola V620 (phone)',
'mot\-v690','Motorola V690 (phone)',
'mot\-v878','Motorola V878 (phone)',
'sie\-3618','Siemens 3618 (phone)',
'sie\-a56','Siemens A56 (phone)',
'sie\-c6c','Siemens C6C (phone)',
'sie\-cx6c','Siemens CX6c (phone)',
'sie\-cx6v','Siemens CX6v (phone)',
'sie\-m6c','Siemens M6C (phone)',
'sie\-m6v','Siemens M6V (phone)',
'sie\-s46','Siemens S46 (phone)',
'sie\-sk65','Siemens SK65 (phone)',
'sie\-sl56','Siemens SL56 (phone)',
'sie\-st55','Siemens ST55 (phone)',
'sagem\-mo130','Sagem MO130 (phone)',
'sagem\-myc','Sagem myC (phone)',
'sagem\-myv','Sagem myV (phone)',
'sagem\-myx3','Sagem myX3 (phone)',
'sagem\-myx5','Sagem myX5 (phone)',
'sagem\-myx','Sagem myX (phone)',
'lg\-G610','LG G610 (phone)',
'mot\-v550','Motorola V550 (phone)',
'mot\-a\-1f','Motorola A-1F (phone)',
'mot\-c155','Motorola C155 (phone)',
'mot\-c975','Motorola C975 (phone)',
'mot\-c980','Motorola C980 (phone)',
'mot\-e380','Motorola E380 (phone)',
'mot\-e680','Motorola E680 (phone)',
'mot\-ed','Motorola ED (phone)',
'mot\-t725e','Motorola T725E (phone)',
'mot\-v150','Motorola V150 (phone)',
'mot\-v171','Motorola V171 (phone)',
'mot\-v535','Motorola V535 (phone)',
'mot\-v545','Motorola V545 (phone)',
'mot\-v635','Motorola V635 (phone)',
'mot\-v870','Motorola V870 (phone)',
'nokia2112','Nokia 2112 (phone)',
'nokia3620','Nokia 3620 (phone)',
'nokia6020','Nokia 6020 (phone)',
'nokia6200','Nokia 6200 (phone)',
'nokia6620','Nokia 6620 (phone)',
'nokia6680','Nokia 6680 (phone)',
'nokia7270','Nokia 7270 (phone)',
'nokia7280','Nokia 7280 (phone)',
'nokia9500','Nokia 9500 (phone)',
'panasonic\-a200','Panasonic A200 (phone)',
'panasonic\-g70','Panasonic G70 (phone)',
'panasonic\-x100','Panasonic X100 (phone)',
'panasonic\-x300','Panasonic X300 (phone)',
'panasonic\-x400','Panasonic X400 (phone)',
'panasonic\-x500','Panasonic X500 (phone)',
'panasonic\-x66','Panasonic X66 (phone)',
'panasonic\-x77','Panasonic X77 (phone)',
't66','Ericsson T66 (phone)',
'n21i','I-Mode Nec 21i (phone)',
'n22i','I-Mode Nec 22i (phone)',
'ts21i','I-Mode Toshiba 21i (phone)',
'wap','Unknown WAP browser (PDA/Phone browser)',			# Generic WAP phone (must be after 'wap*')
'up\.','UP.Browser (PDA/Phone browser)',					# Works for UP.Browser and UP.Link
# PDA/Phonecell browsers
'blackberry','BlackBerry (PDA/Phone browser)',
'cnf2','Supervision I-Mode ByTel (phone)',
'docomo','I-Mode phone (PDA/Phone browser)',
'portalmmm','I-Mode phone (PDA/Phone browser)',
'ipcheck','Supervision IP Check (phone)',
'iphone','IPhone (PDA/Phone browser)',
# Others (TV)
'webtv','WebTV browser',
# Anonymous Proxy Browsers (can be used as grabbers as well...)
'cjb\.net','<a href="http://proxy.cjb.net/" title="Browser home page [new window]" target="_blank">CJB.NET Proxy</a>',
'ossproxy','<a href="http://www.marketscore.com/FAQ.Aspx" title="OSSProxy home page [new window]" target="_blank">OSSProxy</a>',
# Other kind of browsers
'adobeair','AdobeAir',
'apt','Debian APT',
'analogx_proxy','AnalogX Proxy',
'gnome\-vfs', 'Gnome FileSystem Abstraction library', 
'neon', 'Neon HTTP and WebDAV client library',
'curl','Curl',
'csscheck','WDG CSS Validator',
'httrack','HTTrack',
'fdm','<a href="http://www.freedownloadmanager.org/" title="Browser home page [new window]" target="_blank">FDM Free Download Manager</a>',
'javaws','Java Web Start',
'wget','Wget',
'chilkat', 'Chilkat',
'webdownloader\sfor\sx','Downloader for X',
'w3m','w3m',
'wdg_validator','WDG HTML Validator',
'webreaper','WebReaper',
'webzip','WebZIP',
'staroffice','StarOffice',
'gnus', 'Gnus Network User Services',
'nikto', 'Nikto Web Scanner',
'microsoft\-webdav\-miniredir', 'Microsoft Data Access Component Internet Publishing Provider',
'microsoft\sdata\saccess\sinternet\spublishing\sprovider\scache\smanager', 'Microsoft Data Access Component Internet Publishing Provider Cache Manager',
'microsoft\sdata\saccess\sinternet\spublishing\sprovider\sdav', 'Microsoft Data Access Component Internet Publishing Provider DAV',
'POE\-Component\-Client\-HTTP','HTTP user-agent for POE (portable networking framework for Perl)',
'mozilla','Mozilla',
'libwww','LibWWW',
'lwp','LibWWW-perl'
);


# BrowsersHashAreGrabber
# Put here an entry for each browser in BrowsersSearchIDOrder that are grabber
# browsers.
#---------------------------------------------------------------------------
%BrowsersHereAreGrabbers = (
'teleport','1',
'webcapture','1',
'webcopier','1',
'curl','1',
'fdm','1',
'httrack','1',
'webreaper','1',
'wget','1',
'webdownloader\sfor\sx','1',
'webzip','1'
);


# BrowsersHashIcon
# Each Browsers Search ID is associated to a string that is the name of icon
# file for this browser.
#---------------------------------------------------------------------------
%BrowsersHashIcon = (           
# Standard web browsers
'msie','msie',
'netscape','netscape',
'firefox','firefox',
'svn','subversion',
'chrome','chrome',
'firebird','phoenix',
'go!zilla','gozilla',
'icab','icab',
'konqueror','konqueror',
'lynx','lynx',
'omniweb','omniweb',
'opera','opera',
# Other standard web browsers
'amaya','amaya',
'amigavoyager','amigavoyager',
'avantbrowser','avant',
'aweb','aweb',
'bonecho','firefox',
'bpftp','bpftp',
'camino','chimera',
'chimera','chimera',
'cyberdog','cyberdog',
'dillo','dillo',
'doris','doris',
'dreamcast','dreamcast',
'xbox', 'winxbox',
'ecatch','ecatch',
'encompass','encompass',
'epiphany','epiphany',
'fresco','fresco',
'galeon','galeon',
'flashget','flashget',
'freshdownload','freshdownload',
'getright','getright',
'leechget','leechget',
'hotjava','hotjava',
'ibrowse','ibrowse',
'k\-meleon','kmeleon',
'lotus\-notes','lotusnotes',
'macweb','macweb',
'multizilla','multizilla',
'msfrontpageexpress','fpexpress',
'ncsa_mosaic','ncsa_mosaic',
'netpositive','netpositive',
'phoenix','phoenix',
'safari','safari',
# Site grabbers
'teleport','teleport',
'webcapture','adobe',
'webcopier','webcopier',
# Media only browsers
'real','real',
'winamp','mediaplayer',				# Works for winampmpeg and winamp3httprdr
'windows\-media\-player','mplayer',
'audion','mediaplayer',
'freeamp','mediaplayer',
'itunes','mediaplayer',
'jetaudio','mediaplayer',
'mint_audio','mediaplayer',
'mpg123','mediaplayer',
'mplayer','mediaplayer',
'nsplayer','netshow',
'qts','mediaplayer',
'sonique','mediaplayer',
'uplayer','mediaplayer',
'xaudio','mediaplayer',
'xine','mediaplayer',
'xmms','mediaplayer',
# RSS Readers
'abilon', 'abilon',
'aggrevator', 'rss',
'aiderss', 'rss',
'akregator', 'rss',
'applesyndication', 'rss',
'betanews_reader','rss',
'blogbridge','rss',
'feeddemon', 'rss',
'feedreader', 'rss',
'feedtools', 'rss',
'greatnews', 'rss',
'gregarius', 'rss',
'hatena_rss', 'rss',
'jetbrains_omea', 'rss',
'liferea', 'rss',
'netnewswire', 'rss',
'newsfire', 'rss',
'newsgator', 'rss',
'newzcrawler', 'rss',
'plagger', 'rss',
'pluck', 'rss',
'potu', 'rss',
'pubsub\-rss\-reader', 'rss',
'pulpfiction', 'rss',
'rssbandit', 'rss',
'rssreader', 'rss',
'rssowl', 'rss',
'rss\sxpress','rss',
'rssxpress','rss',
'sage', 'rss',
'sharpreader', 'rss',
'shrook', 'rss',
'straw', 'rss',
'syndirella', 'rss',
'vienna', 'rss',
'wizz\srss\snews\sreader','wizz',
# PDA/Phonecell browsers
#'alcatel','pdaphone',				# Alcatel
#'lg\-','pdaphone',                  # LG
#'ericsson','pdaphone',				# Ericsson
#'mot\-','pdaphone',					# Motorola
#'nokia','pdaphone',					# Nokia
#'panasonic','pdaphone',				# Panasonic
#'philips','pdaphone',				# Philips
#'sagem','pdaphone',                 # Sagem
#'samsung','pdaphone',               # Samsung
#'sie\-','pdaphone',                 # SIE
#'sec\-','pdaphone',                 # Sony/Ericsson
#'sonyericsson','pdaphone',			# Sony/Ericsson
#'mmef','pdaphone',
#'mspie','pdaphone',
#'wapalizer','pdaphone',
#'wapsilon','pdaphone',
'wap','pdaphone',					# Generic WAP phone (must be after 'wap*')
'up\.','pdaphone',
# PDA/Phonecell browsers
'blackberry','pdaphone',
'docomo','pdaphone',
'iphone','pdaphone',
'portalmmm','pdaphone',
# Others (TV)
'webtv','webtv',
# Anonymous Proxy Browsers (can be used as grabbers as well...)
'cjb\.net','cjbnet',
# Other kind of browsers
'adobeair','adobe',
'apt','apt',
'analogx_proxy','analogx',
'microsoft\-webdav\-miniredir','frontpage',
'microsoft\sdata\saccess\sinternet\spublishing\sprovider\scache\smanager','frontpage',
'microsoft\sdata\saccess\sinternet\spublishing\sprovider\sdav','frontpage',
'gnome\-vfs', 'gnome',
'neon','neon',
'javaws','java',
'webzip','webzip',
'webreaper','webreaper',
'httrack','httrack',
'staroffice','staroffice',
'gnus', 'gnus',
'mozilla','mozilla'
);

# Source for this is http://developer.apple.com/internet/safari/uamatrix.html
%BrowsersSafariBuildToVersionHash = 
(
    '48' => '0.8',
    '51' => '0.8.1',
    '60' => '0.8.2',
    '73' => '0.9',
    '74' => '1.0b2',
    '85' => '1.0',
    '85.5' => '1.0',
    '85.7' => '1.0.2',
    '85.8' => '1.0.3',
    '85.8.1' => '1.0.3',
    '100' => '1.1',
    '100.1' => '1.1.1',
    '125.7' => '1.2.2',
    '125.8' => '1.2.2',
    '125.9' => '1.2.3',
    '125.11' => '1.2.4',
    '125.12' => '1.2.4',
    '312' => '1.3',
    '312.3' => '1.3.1',
    '312.3.1' => '1.3.1',
    '412' => '2.0',
    '412.2' => '2.0',
    '412.2.2' => '2.0',
    '412.5' => '2.0.1',
    '416.12' => '2.0.2'
);


1;


# Browsers examples by engines
#
# -- Mosaic --
# MSIE		4.0  	Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt; KITV4 Wanadoo; KITV5 Wanadoo)
#
# -- Gecko Netscape --
# Netscape	4.05	Mozilla/4.05 [fr]C-SYMPA  (Win95; I)
# Netscape	4.7     Mozilla/4.7 [fr] (Win95; I)
# Netscape	6.0		Mozilla/5.0 (Macintosh; N; PPC; fr-FR; m18) Gecko/20001108 Netscape6/6.0
# Netscape	7.02	Mozilla/5.0 (Platform; Security; OS-or-CPU; Localization; rv:1.0.2) Gecko/20030208 Netscape/7.02 
#
# -- Gecko others --
# Mozilla	1.3		Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.3) Gecko/20030312
# Firefox	0.9		Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.5a) Gecko/20030728 Mozilla Firefox/0.9.1
# Firebird,Phoenix,Galeon,AmiZilla,Dino
# Autre             Mozilla/3.01 (compatible;)
#
# -- Opera --
# Opera		6.03	Mozilla/3.0 (Windows 98; U) Opera 6.03  [en]
# Opera		5.12    Mozilla/3.0 (Windows 98; U) Opera 5.12  [en]
# Opera		3.21    Opera 3.21, Windows:
#
# -- KHTML --
# Safari
# Konqueror
#
