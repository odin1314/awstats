# AWSTATS ROBOTS DATABASE
#-------------------------------------------------------
# If you want to add robots to extend AWStats database detection capabilities,
# you must add an entry in RobotsSearchIDOrder_listx and RobotsHashIDLib.
#-------------------------------------------------------
# $Revision: 1.42 $ - $Author: eldy $ - $Date: 2006-01-22 12:55:18 $

# 2005-08-19 Sean Carlos http://www.antezeta.com/awstats.html
#              added dipsie (not tested with real data).
#              added DomainsDB.net http://domainsdb.net/
#              added ia_archiver-web.archive.org (was inadvertently grouped with Alexa traffic)
#              added Nutch (used by looksmart (furl?))
#              added rssImagesBot
#              added Sqworm
#              added t\-h\-u\-n\-d\-e\-r\-s\-t\-o\-n\-e
#              added w3c css-validator
#              added documentation link to bot home pages for above and selected major bots.
#                    In the case of international bots, choose .com page.
#                    Included tool tip (html "title").
#                    To do: parameterize to match both AWStats language and tooltips settings.
#                    To do: add html links for all bots based on current documentation in source
#                           files referenced below.
#              changed '\wbot[\/\-]', to '\wbot[\/\-]' (removed comma)
#              made minor grammar corrections to notes below
# 2005-08-24	added YahooSeeker-Testing
#              	added w3c-checklink
#              	updated url for ask.com
# 2005-08-24   	added Girafabot http://www.girafa.com/
# 2005-08-30   	added PluckFeedCrawler http://www.pluck.com/
#		added Gaisbot/3.0 (robot05@gais.cs.ccu.edu.tw; )
#		dded geniebot (wgao@genieknows.com)
#		added BecomeBot link http://www.become.com/site_owners.html
#		added topicblogs http://www.topicblogs.com/
#		added Powermarks; seen used by referrer spam
#		added YahooSeeker
#		added NG/2. http://www.exabot.com/
# 2005-09-15	added link for Walhello appie
#		added bender focused_crawler
#		updated YahooSeeker description (blog crawler)
# 2005-09-16	added link for http://linkchecker.sourceforge.net
# 		added ConveraCrawler/0.9d ( http://www.authoritativeweb.com/crawl)
#		added Blogslive  info@blogslive.com intelliseek.com 
#		added BlogPulse (ISSpider-3.0) intelliseek.com
# 2005-09-26	added Feedfetcher-Google (http://www.google.com/feedfetcher.html)
#		added EverbeeCrawler	
#		added Yahoo-Blogs http://help.yahoo.com/help/us/ysearch/crawling/crawling-02.html
#		added link for Bloglines http://www.bloglines.com
# 2005-10-19	fixed Feedfetcher-Google (http://www.google.com/feedfetcher.html)
# 		added Blogshares Spiders (Synchronized V1.5.1)
#		added yacy
# 2005-11-21	added Argus www.simpy.com
#		added BlogsSay :: RSS Search Crawler (http://www.blogssay.com/)
#		added MJ12bot http://majestic12.co.uk/bot.php
#		added OpenTaggerBot (http://www.opentagger.com/opentaggerbot.htm)
#		added OutfoxBot/0.3 (For internet experiments; outfox.agent@gmail.com)
#		added RufusBot Rufus Web Miner http://64.124.122.252.webaroo.com/feedback.html
#		added Seekbot (http://www.seekbot.net/bot.html)
#		added Yahoo-MMCrawler/3.x (mms-mmcrawler-support@yahoo-inc.com)
#               added link for BaiDuSpider
#		added link for Blogshares Spider
#		added link for StackRambler http://www.rambler.ru/doc/faq.shtml
#		added link for WISENutbot
#		added link for ZyBorg/1.0 (wn-14.zyborg@looksmart.net; http://www.WISEnutbot.com.  Moved location to above wisenut to avoid classification as wisenut
# 2005-12-15
#		added FAST Enteprise Crawler/6 (www dot fastsearch dot com). Note spelling Enteprise not Enterprise.
#		added findlinks http://wortschatz.uni-leipzig.de/findlinks/
#		added IBM Almaden Research Center WebFountain™ http://www.almaden.ibm.com/cs/crawler [hc3]
#		added INFOMINE/8.0 VLCrawler (http://infomine.ucr.edu/useragents)
#		added lmspider (lmspider@scansoft.com) http://www.nuance.com/
#		added noxtrumbot http://www.noxtrum.com/
#		added SandCrawler (Microsoft)
#		added SBIder http://www.sitesell.com/sbider.html
#		added SeznamBot http://fulltext.seznam.cz/
#		added sohu-search http://corp.sohu.com/ (looked for //robots.txt not /robots.txt)
#		added the ruffle SemanticWeb crawler v0.5 - http://www.unreach.net
#		added WebVulnCrawl/1.0 libwww-perl/5.803 (looked for //robots.txt not /robots.txt)
#		added Yahoo! Japan keyoshid http://www.yahoo.co.jp/
#		added Y!J http://help.yahoo.co.jp/help/jp/search/indexing/indexing-15.html
#		added link for GigaBot
#		added link for MagpieRSS
#		added link for MSIECrawler


#package AWSROB;


# Robots list was found at http://www.robotstxt.org/wc/active/all.txt
# Other robots can be found at http://www.jafsoft.com/searchengines/webbots.html 
# Rem: To avoid bad detection, some robot's ids were removed from this list:
#      - Robots with ID of 3 letters only
#      - Robots called 'webs' and 'tcl'
# Rem: Some robots mostly used for downloading have also been removed, i.e. wget
# Rem: directhit changed into direct_hit (its real id)
# Rem: calif changed into calif[^r] to avoid confusion between Tiscalifreenet browser
# Rem: fish changed into [^a]fish to avoid confusion between Madsafish browser
# Rem: roadrunner changed into road_runner
# Rem: lycos changed to lycos_ to avoid confusion with lycos-online browser
# Rem: voyager changed into ^voyager\/ to avoid to exclude voyager and amigavoyager browser

# RobotsSearchIDOrder
# It contains all matching criteria to search for in log fields. This list is
# used to know in which order to search Robot IDs.
# Most frequent ones are in list1, used when LevelForRobotsDetection is 1 or more
# Minor robots are in list2, used when LevelForRobotsDetection is 2 or more
# Note: Robots IDs are in lower case, ' ' and '+' are changed into '_' and are quoted.
#-------------------------------------------------------
@RobotsSearchIDOrder_list1 = (
# Common robots (In robot file)
'appie',
'architext',
'jeeves',
'bjaaland',
'ferret',
'googlebot',
'gulliver',
'harvest',
'htdig',
'linkwalker',
'lycos_',
'moget',
'muscatferret',
'myweb',
'nomad',
'scooter',
'slurp',
'^voyager\/',
'weblayers',
# Common robots (Not in robot file)
'antibot',
'bruinbot',
'digout4u',
'echo',
'fast\-webcrawler',
'ia_archiver\-web\.archive\.org', # Must be before ia_archiver to avoid confusion with alexa
'ia_archiver',
'jennybot',
'mercator',
'netcraft',
'msnbot',
'petersnews',
'unlost_web_crawler',
'voila',
'webbase',
'webcollage',
'cfetch',
'zyborg',	# Must be before wisenut 
'wisenutbot'
);
@RobotsSearchIDOrder_list2 = (
# Less common robots (In robot file)
'[^a]fish',
'abcdatos',
'acme\.spider',
'ahoythehomepagefinder',
'alkaline',
'anthill',
'arachnophilia',
'arale',
'araneo',
'aretha',
'ariadne',
'powermarks',
'arks',
'aspider',
'atn\.txt',
'atomz',
'auresys',
'backrub',
'bbot',
'bigbrother',
'blackwidow',
'blindekuh',
'bloodhound',
'borg\-bot',
'brightnet',
'bspider',
'cactvschemistryspider',
'calif[^r]',
'cassandra',
'cgireader',
'checkbot',
'christcrawler',
'churl',
'cienciaficcion',
'collective',
'combine',
'conceptbot',
'coolbot',
'core',
'cosmos',
'cruiser',
'cusco',
'cyberspyder',
'desertrealm',
'deweb',
'dienstspider',
'digger',
'diibot',
'direct_hit',
'dnabot',
'download_express',
'dragonbot',
'dwcp',
'e\-collector',
'ebiness',
'elfinbot',
'emacs',
'emcspider',
'esther',
'evliyacelebi',
'fastcrawler',
'fdse',
'felix',
'fetchrover',
'fido',
'finnish',
'fireball',
'fouineur',
'francoroute',
'freecrawl',
'funnelweb',
'gama',
'gazz',
'gcreep',
'getbot',
'geturl',
'golem',
'grapnel',
'griffon',
'gromit',
'gulperbot',
'hambot',
'havindex',
'hometown',
'htmlgobble',
'hyperdecontextualizer',
'iajabot',
'iconoclast',
'ilse',
'imagelock',
'incywincy',
'informant',
'infoseek',
'infoseeksidewinder',
'infospider',
'inspectorwww',
'intelliagent',
'irobot',
'iron33',
'israelisearch',
'javabee',
'jbot',
'jcrawler',
'jobo',
'jobot',
'joebot',
'jubii',
'jumpstation',
'kapsi',
'katipo',
'kilroy',
'ko_yappo_robot',
'labelgrabber\.txt',
'larbin',
'legs',
'linkidator',
'linkscan',
'lockon',
'logo_gif',
'macworm',
'magpie',
'marvin',
'mattie',
'mediafox',
'merzscope',
'meshexplorer',
'mindcrawler',
'mnogosearch',
'momspider',
'monster',
'motor',
'muncher',
'mwdsearch',
'ndspider',
'nederland\.zoek',
'netcarta',
'netmechanic',
'netscoop',
'newscan\-online',
'nhse',
'northstar',
'nzexplorer',
'objectssearch',
'occam',
'octopus',
'openfind',
'orb_search',
'packrat',
'pageboy',
'parasite',
'patric',
'pegasus',
'perignator',
'perlcrawler',
'phantom',
'phpdig',
'piltdownman',
'pimptrain',
'pioneer',
'pitkow',
'pjspider',
'plumtreewebaccessor',
'poppi',
'portalb',
'psbot',
'python',
'raven',
'rbse',
'resumerobot',
'rhcs',
'road_runner',
'robbie',
'robi',
'robocrawl',
'robofox',
'robozilla',
'roverbot',
'rules',
'safetynetrobot',
'search\-info',
'search_au',
'searchprocess',
'senrigan',
'sgscout',
'shaggy',
'shaihulud',
'sift',
'simbot',
'site\-valet',
'sitetech',
'skymob',
'slcrawler',
'smartspider',
'snooper',
'solbot',
'speedy',
'spider_monkey',
'spiderbot',
'spiderline',
'spiderman',
'spiderview',
'spry',
'sqworm',
'ssearcher',
'suke',
'suntek',
'sven',
'tach_bw',
'tarantula',
'tarspider',
'techbot',
'templeton',
'titan',
'titin',
'tkwww',
'tlspider',
'ucsd',
'udmsearch',
'urlck',
'valkyrie',
'verticrawl',
'victoria',
'visionsearch',
'voidbot',
'vwbot',
'w3index',
'w3m2',
'wallpaper',
'wanderer',
'wapspider',
'webbandit',
'webcatcher',
'webcopy',
'webfetcher',
'webfoot',
'webinator',
'weblinker',
'webmirror',
'webmoose',
'webquest',
'webreader',
'webreaper',
'websnarf',
'webspider',
'webvac',
'webwalk',
'webwalker',
'webwatch',
'whatuseek',
'whowhere',
'wired\-digital',
'wmir',
'wolp',
'wombat',
'worm',
'wwwc',
'wz101',
'xget',
# Other robots reported by users
'almaden',
'aport',
'argus', 		# Must be before nutch
'asterias',
'awbot',
'baiduspider',
'becomebot',
'bender',
'bloglines',
'blogpulse',
'blogshares',
'blogslive',
'blogssay',
'bobby',
'boris',
'bumblebee',
'converacrawler',
'cscrawler',
'daviesbot',
'daypopbot',
'dipsie\.bot',
'domainsdb\.net',
'exactseek',
'everbeecrawler',
'ezresult',
'enteprise',
'feedburner',
'feedfetcher\-google',
'feedster',
'findlinks',
'gaisbot',
'geniebot',
'gigabot',
'girafabot',
'gnodspider',
'grub',
'henrythemiragorobot',
'holmes',
'infomine',
'internetseer',
'justview',
'keyoshid', # Must come before Y!J
'kinjabot',
'kinja\-imagebot',
'linkbot',
'metager\-linkchecker',	# Must be before linkchecker
'linkchecker',
'livejournal\.com',
'lmspider',
'magpierss',
'mediapartners\-google',
'microsoft_url_control',
'mj12bot',
'msiecrawler',
'nagios',
'newsgatoronline',
'noxtrumbot',
'nutch',
'opentaggerbot',
'outfoxbot',
'perman',
'pluckfeedcrawler',
'pompos',
'popdexter',
'rambler',
'redalert',
'rojo',
'rssimagesbot',
'ruffle',
'rufusbot',
'sandcrawler',
'sbider',
'seekbot',
'seznambot',
'shoutcast',
'slysearch',
'sohu-search',
'surveybot',
'syndic8',
'technoratibot',
't\-h\-u\-n\-d\-e\-r\-s\-t\-o\-n\-e',
'topicblogs',
'turnitinbot',
'turtlescanner',		# Must be before turtle
'turtle',
'ultraseek',
'w3c\-checklink',
'w3c_css_validator_jfouffa',
'w3c_validator',
'webclipping\.com',
'webcompass',
'webvulncrawl',
'wonderer',
'y!j', # Must come after keyoshid Y!J
'yacy',
'yahoo\-blogs',
'yahoo\-verticalcrawler',
'yahoofeedseeker',
'yahooseeker\-testing',
'yahooseeker',
'yahoo\-mmcrawler',
'yandex',
'zealbot',
'ng\/1\.', # put at end to avoid false positive
'ng\/2\.' # put at end to avoid false positive
);
@RobotsSearchIDOrder_listgen = (
# Generic robot
'robot',
'crawl',
'spider',
'\wbot[\/\-]'
);



# RobotsHashIDLib
# List of robots names ('robot id','robot clear text')
#-------------------------------------------------------
%RobotsHashIDLib   = (
# Common robots (In robot file)
'appie','<a href="http://www.walhello.com/" title="Bot home page [new window]" target="_blank">Walhello appie</a>',
'architext','ArchitextSpider',
'jeeves','<a href="http://sp.ask.com/docs/about/tech_crawling.html" title="Bot home page [new window]" target="_blank">AskJeeves</a>',
'bjaaland','Bjaaland',
'ferret','Wild Ferret Web Hopper #1, #2, #3',
'googlebot','<a href="http://www.google.com/bot.html" title="Bot home page [new window]" target="_blank">Googlebot</a>',
'gulliver','Northern Light Gulliver',
'harvest','Harvest',
'htdig','ht://Dig',
'linkwalker','LinkWalker',
'lycos_','Lycos',
'moget','moget',
'muscatferret','Muscat Ferret',
'myweb','Internet Shinchakubin',
'nomad','Nomad',
'scooter','Scooter',
'slurp','<a href="http://help.yahoo.com/help/us/ysearch/slurp/" title="Bot home page [new window]" target="_blank">Yahoo Slurp</a>',
'^voyager\/','Voyager',
'weblayers','weblayers',
# Common robots (Not in robot file)
'antibot','Antibot',
'bruinbot','<a href="http://web.archive.org/" title="BruinBot home page [new window]" target="_blank">The web archive</a>',
'digout4u','Digout4u',
'echo','EchO!',
'fast\-webcrawler','Fast-Webcrawler',
'ia_archiver\-web\.archive\.org','<a href="http://web.archive.org/" title="Bot home page [new window]" target="_blank">The web archive (IA Archiver)</a>',
'ia_archiver','<a href="http://www.alexa.com/" title="Bot home page [new window]" target="_blank">Alexa (IA Archiver)</a>',
'jennybot','JennyBot',
'mercator','Mercator',
'msnbot','<a href="http://search.msn.com/msnbot.htm" title="Bot home page [new window]" target="_blank">MSNBot</a>',
'netcraft','<a href="http://www.netcraft.com/survey/" title="Bot home page [new window]" target="_blank">Netcraft</a>',
'petersnews','Petersnews',
'unlost_web_crawler','Unlost Web Crawler',
'voila','Voila',
'webbase', 'WebBase',
'zyborg','<a href="http://www.WISEnutbot.com/" title="wn-14.zyborg@looksmart.net Bot home page [new window]" target="_blank">ZyBorg</a>',
'wisenutbot','<a href="http://www.WISEnutbot.com/" title="Bot home page [new window]" target="_blank">WISENutbot</a>',
'webcollage','<a href="http://www.jwz.org/webcollage/" title="WebCollage home page [new window]" target="_blank">WebCollage</a>',
'cfetch','<a href="http://www.kosmix.com/crawler.html" title="kosmix home page [new window]" target="_blank">cfetch</a>',
# Less common robots (In robot file)
'[^a]fish','Fish search',
'abcdatos','ABCdatos BotLink',
'acme\.spider','Acme.Spider',
'ahoythehomepagefinder','Ahoy! The Homepage Finder',
'alkaline','Alkaline',
'anthill','Anthill',
'arachnophilia','Arachnophilia',
'arale','Arale',
'araneo','Araneo',
'aretha','Aretha',
'ariadne','ARIADNE',
'powermarks','<a href="http://www.kaylon.com/power.html" title="Bot home page [new window]" target="_blank">Powermarks</a>', # must come before Arks; seen used by referrer spam
'arks','arks',
'aspider','ASpider (Associative Spider)',
'atn\.txt','ATN Worldwide',
'atomz','Atomz.com Search Robot',
'auresys','AURESYS',
'backrub','BackRub',
'bbot','BBot',
'bigbrother','Big Brother',
'blackwidow','BlackWidow',
'blindekuh','Die Blinde Kuh',
'bloodhound','Bloodhound',
'borg\-bot','Borg-Bot',
'brightnet','bright.net caching robot',
'bspider','BSpider',
'cactvschemistryspider','CACTVS Chemistry Spider',
'calif[^r]','Calif',
'cassandra','Cassandra',
'cgireader','Digimarc Marcspider/CGI',
'checkbot','Checkbot',
'christcrawler','ChristCrawler.com',
'churl','churl',
'cienciaficcion','cIeNcIaFiCcIoN.nEt',
'collective','Collective',
'combine','Combine System',
'conceptbot','Conceptbot',
'coolbot','CoolBot',
'core','Web Core / Roots',
'cosmos','XYLEME Robot',
'cruiser','Internet Cruiser Robot',
'cusco','Cusco',
'cyberspyder','CyberSpyder Link Test',
'desertrealm','Desert Realm Spider',
'deweb','DeWeb(c) Katalog/Index',
'dienstspider','DienstSpider',
'digger','Digger',
'diibot','Digital Integrity Robot',
'direct_hit','Direct Hit Grabber',
'dnabot','DNAbot',
'download_express','DownLoad Express',
'dragonbot','DragonBot',
'dwcp','DWCP (Dridus\' Web Cataloging Project)',
'e\-collector','e-collector',
'ebiness','EbiNess',
'elfinbot','ELFINBOT',
'emacs','Emacs-w3 Search Engine',
'emcspider','ananzi',
'esther','Esther',
'evliyacelebi','Evliya Celebi',
'fastcrawler','FastCrawler',
'fdse','Fluid Dynamics Search Engine robot',
'felix','Felix IDE',
'fetchrover','FetchRover',
'fido','fido',
'finnish','H���ki',
'fireball','KIT-Fireball',
'fouineur','Fouineur',
'francoroute','Robot Francoroute',
'freecrawl','Freecrawl',
'funnelweb','FunnelWeb',
'gama','gammaSpider, FocusedCrawler',
'gazz','gazz',
'gcreep','GCreep',
'getbot','GetBot',
'geturl','GetURL',
'golem','Golem',
'grapnel','Grapnel/0.01 Experiment',
'griffon','Griffon',
'gromit','Gromit',
'gulperbot','Gulper Bot',
'hambot','HamBot',
'havindex','havIndex',
'hometown','Hometown Spider Pro',
'htmlgobble','HTMLgobble',
'hyperdecontextualizer','Hyper-Decontextualizer',
'iajabot','iajaBot',
'iconoclast','Popular Iconoclast',
'ilse','Ingrid',
'imagelock','Imagelock',
'incywincy','IncyWincy',
'informant','Informant',
'infoseek','InfoSeek Robot 1.0',
'infoseeksidewinder','Infoseek Sidewinder',
'infospider','InfoSpiders',
'inspectorwww','Inspector Web',
'intelliagent','IntelliAgent',
'irobot','I, Robot',
'iron33','Iron33',
'israelisearch','Israeli-search',
'javabee','JavaBee',
'jbot','JBot Java Web Robot',
'jcrawler','JCrawler',
'jobo','JoBo Java Web Robot',
'jobot','Jobot',
'joebot','JoeBot',
'jubii','The Jubii Indexing Robot',
'jumpstation','JumpStation',
'kapsi','image.kapsi.net',
'katipo','Katipo',
'kilroy','Kilroy',
'ko_yappo_robot','KO_Yappo_Robot',
'labelgrabber\.txt','LabelGrabber',
'larbin','<a href="http://para.inria.fr/~ailleret/larbin/index-eng.html" title="Bot home page [new window]" target="_blank">larbin</a>',
'legs','legs',
'linkidator','Link Validator',
'linkscan','LinkScan',
'lockon','Lockon',
'logo_gif','logo.gif Crawler',
'macworm','Mac WWWWorm',
'lmspider','<a href="http://www.nuance.com/" title="Bot home page lmspider@scansoft.com [new window]" target="_blank">lmspider</a>',
'magpie','<a href="http://magpierss.sf.net/" title="Bot home page [new window]" target="_blank">MagpieRSS</a>',
'marvin','marvin/infoseek',
'mattie','Mattie',
'mediafox','MediaFox',
'merzscope','MerzScope',
'meshexplorer','NEC-MeshExplorer',
'mindcrawler','MindCrawler',
'mnogosearch','mnoGoSearch search engine software',
'momspider','MOMspider',
'monster','Monster',
'motor','Motor',
'muncher','Muncher',
'mwdsearch','Mwd.Search',
'ndspider','NDSpider',
'nederland\.zoek','Nederland.zoek',
'netcarta','NetCarta WebMap Engine',
'netmechanic','<a href="http://www.netmechanic.com/" title="Bot home page [new window]" target="_blank">NetMechanic</a>',
'netscoop','NetScoop',
'newscan\-online','newscan-online',
'nhse','NHSE Web Forager',
'northstar','The NorthStar Robot',
'nzexplorer','nzexplorer',
'objectssearch','ObjectsSearch',
'occam','Occam',
'octopus','HKU WWW Octopus',
'openfind','Openfind data gatherer',
'orb_search','Orb Search',
'packrat','Pack Rat',
'pageboy','PageBoy',
'parasite','ParaSite',
'patric','Patric',
'pegasus','pegasus',
'perignator','The Peregrinator',
'perlcrawler','PerlCrawler 1.0',
'phantom','Phantom',
'phpdig','PhpDig',
'piltdownman','PiltdownMan',
'pimptrain','Pimptrain.com\'s robot',
'pioneer','Pioneer',
'pitkow','html_analyzer',
'pjspider','Portal Juice Spider',
'plumtreewebaccessor','PlumtreeWebAccessor',
'poppi','Poppi',
'portalb','PortalB Spider',
'psbot','<a href="http://www.picsearch.com/bot.html" title="Bot home page. [new window]" target="_blank">psbot</a>',
'python','<a href="http://www.lib.uchicago.edu/keith/courses/python/class/7/" title="Bot home page. Used by many. [new window]" target="_blank">Python-urllib</a>',
'raven','Raven Search',
'rbse','RBSE Spider',
'resumerobot','Resume Robot',
'rhcs','RoadHouse Crawling System',
'road_runner','Road Runner: The ImageScape Robot',
'robbie','Robbie the Robot',
'robi','ComputingSite Robi/1.0',
'robocrawl','RoboCrawl Spider',
'robofox','RoboFox',
'robozilla','Robozilla',
'roverbot','Roverbot',
'rules','RuLeS',
'safetynetrobot','SafetyNet Robot',
'search\-info','Sleek',
'search_au','Search.Aus-AU.COM',
'searchprocess','SearchProcess',
'senrigan','Senrigan',
'sgscout','SG-Scout',
'shaggy','ShagSeeker',
'shaihulud','Shai\'Hulud',
'sift','Sift',
'simbot','Simmany Robot Ver1.0',
'site\-valet','Site Valet',
'sitetech','SiteTech-Rover',
'skymob','Skymob.com',
'slcrawler','SLCrawler',
'smartspider','Smart Spider',
'snooper','Snooper',
'solbot','Solbot',
'speedy','Speedy Spider',
'spider_monkey','spider_monkey',
'spiderbot','SpiderBot',
'spiderline','Spiderline Crawler',
'spiderman','SpiderMan',
'spiderview','SpiderView(tm)',
'spry','Spry Wizard Robot',
'ssearcher','Site Searcher',
'sqworm','<a href="http://www.websense.com/" title="Bot home page (source: http://www.pgts.com.au/) [new window]" target="_blank">Sqworm</a>',
'suke','Suke',
'suntek','suntek search engine',
'sven','Sven',
'tach_bw','TACH Black Widow',
'tarantula','Tarantula',
'tarspider','tarspider',
'techbot','TechBOT',
'templeton','Templeton',
'titan','TITAN',
'titin','TitIn',
'tkwww','The TkWWW Robot',
'tlspider','TLSpider',
'ucsd','UCSD Crawl',
'udmsearch','UdmSearch',
'urlck','URL Check',
'valkyrie','Valkyrie',
'verticrawl','Verticrawl',
'victoria','Victoria',
'visionsearch','vision-search',
'voidbot','void-bot',
'vwbot','VWbot',
'w3index','The NWI Robot',
'w3m2','W3M2',
'wallpaper','WallPaper (alias crawlpaper)',
'wanderer','the World Wide Web Wanderer',
'wapspider','w@pSpider by wap4.com',
'webbandit','WebBandit Web Spider',
'webcatcher','WebCatcher',
'webcopy','WebCopy',
'webfetcher','webfetcher',
'webfoot','The Webfoot Robot',
'webinator','Webinator',
'weblinker','WebLinker',
'webmirror','WebMirror',
'webmoose','The Web Moose',
'webquest','WebQuest',
'webreader','Digimarc MarcSpider',
'webreaper','WebReaper',
'websnarf','Websnarf',
'webspider','WebSpider',
'webvac','WebVac',
'webwalk','webwalk',
'webwalker','WebWalker',
'webwatch','WebWatch',
'whatuseek','whatUseek Winona',
'whowhere','WhoWhere Robot',
'wired\-digital','Wired Digital',
'wmir','w3mir',
'wolp','WebStolperer',
'wombat','The Web Wombat',
'worm','The World Wide Web Worm',
'wwwc','WWWC Ver 0.2.5',
'wz101','WebZinger',
'xget','XGET',
# Other robots reported by users
'almaden','<a href="http://www.almaden.ibm.com/cs/crawler" title="IBM Almaden Research Center WebFountain&trade; Bot home page [new window]" target="_blank">IBM Almaden</a> Research Center WebFountain&trade;',
'aport', 'Aport',
'argus','<a href="http://www.simpy.com/bot.html" title="feedback@simpy.com Bot home page [new window]" target="_blank">Argus</a>',
'asterias', 'Asterias',
'awbot', 'AWBot',
'baiduspider','<a href="http://www.baidu.com/search/spider.html" title="Bot home page [new window]" target="_blank">BaiDuSpider</a>',
'becomebot', '<a href="http://www.become.com/site_owners.html" title="Bot home page [new window]" target="_blank">BecomeBot</a>',
'bender','<a href="http://bender.ucr.edu/" title="Bot home page [new window]" target="_blank">bender</a> <a href="http://ivia.ucr.edu/manuals/NiFC/current/index.shtml" title="Bot home page [new window]" target="_blank">focused_crawler</a>',
'bloglines','<a href="http://www.bloglines.com/" title="Bot home page [new window]" target="_blank">Bloglines</a>',
'blogpulse','<a href="http://www.intelliseek.com/" title="Bot home page [new window]" target="_blank">BlogPulse ISSpider intelliseek.com</a>',
'blogshares','<a href="http://blogshares.com/help.php?node=7" title="Bot home page [new window]" target="_blank">Blogshares Spiders</a>',
'blogslive','<a href="http://www.blogslive.com/" title="info@blogslive.com Bot home page [new window]" target="_blank">Blogslive</a>',
'blogssay','<a href="http://www.blogssay.com/" title="Bot home page [new window]" target="_blank">BlogsSay :: RSS Search Crawler</a>',
'bobby', 'Bobby', 
'boris', 'Boris',
'bumblebee', 'Bumblebee (relevare.com)',
'converacrawler','<a href="http://www.authoritativeweb.com/crawl" title="Bot home page [new window]" target="_blank">ConveraCrawler</a>',
'cscrawler','CsCrawler',
'daviesbot', 'DaviesBot',
'daypopbot', 'DayPop',
'dipsie\.bot','<a href="http://www.dipsie.com/bot/" title="Bot home page [new window]" target="_blank">Dipsie</a>',
'domainsdb\.net','<a href="http://domainsdb.net/" title="Bot home page [new window]" target="_blank">DomainsDB.net</a>',
'exactseek','ExactSeek Crawler',
'everbeecrawler','EverbeeCrawler',
'ezresult', 'Ezresult',
'enteprise','<a href="http://www.fastsearch.com/" title="Bot home page [new window]" target="_blank">Fast Enteprise Crawler</a>',
'feedburner', 'Feedburner',
'feedfetcher\-google','<a href="http://www.google.com/feedfetcher.html" title="Bot home page [new window]" target="_blank">Feedfetcher-Google</a>',
'feedster', '<a href="http://www.feedster.com/" title="Bot home page [new window]" target="_blank">Feedster</a>',
'geniebot','<a href="http://www.genieknows.com/" title="Bot home page [new window]" target="_blank">geniebot</a>',
'findlinks','<a href="http://wortschatz.uni-leipzig.de/findlinks/" title="Bot home page [new window]" target="_blank">findlinks</a>',
'gaisbot','<a href="http://gais.cs.ccu.edu.tw/robot.php" title="Bot home page [new window]" target="_blank">Gaisbot</a>',
'gigabot','<a href="http://www.gigablast.com/spider.html" title="Bot home page [new window]" target="_blank">GigaBot</a>',
'girafabot','<a href="http://www.girafa.com/" title="Bot home page [new window]" target="_blank">Girafabot</a>',
'gnodspider','GNOD Spider',
'grub','Grub.org',
'henrythemiragorobot', 'Mirago',
'holmes', 'Holmes',
'infomine','<a href="http://infomine.ucr.edu/useragents" title="Bot home page [new window]" target="_blank">INFOMINE VLCrawler</a>',
'internetseer', 'InternetSeer',
'justview', 'JustView',
'keyoshid','<a href="http://www.yahoo.co.jp/" title="Bot home page [new window]" target="_blank">Yahoo! Japan keyoshid robot study</a>','kinjabot', 'Kinjabot',
'kinja\-imagebot', 'Kinja Imagebot',
'linkbot','LinkBot',
'linkchecker','<a href="http://linkchecker.sourceforge.net" title="Bot home page [new window]" target="_blank">LinkChecker</a>',
'livejournal\.com', 'LiveJournal.com',
'magpierss', 'MagpieRSS',
'mediapartners\-google','<a href="https://adwords.google.com/" title="Bot home page [new window]" target="_blank">Google AdSense</a>',
'metager\-linkchecker','MetaGer LinkChecker',
'microsoft_url_control','Microsoft URL Control',
'nagios','Nagios',
'newsgatoronline', 'NewsGator Online',
'noxtrumbot','<a href="http://www.noxtrum.com/" title="Bot home page [new window]" target="_blank">noxtrumbot</a>',
'nutch','<a href="http://lucene.apache.org/nutch/" title="Bot home page. Used by many, including Looksmart. [new window]" target="_blank">Nutch</a>',
'mj12bot','<a href="http://majestic12.co.uk/bot.php" title="Bot home page. [new window]" target="_blank">MJ12bot</a>',
'msiecrawler','<a href="http://msdn.microsoft.com/workshop/delivery/offline/linkrel.asp" title="Bot home page. [new window]" target="_blank">MSIECrawler</a>',
'opentaggerbot','<a href="http://www.opentagger.com/opentaggerbot.htm" title="Bot home page [new window]">OpenTaggerBot</a>',
'outfoxbot','<a href="mailto:outfox.agent@gmail.com?subject=Outfox Bot Information" title="Bot e-mail.">OutfoxBot</a>',
'perman', 'Perman surfer',
'pluckfeedcrawler','<a href="http://www.pluck.com/" title="Bot home page. [new window]" target="_blank">PluckFeedCrawler</a>',
'pompos','Pompos',
'popdexter','Popdexter',
'rambler','<a href="http://www.rambler.ru/doc/faq.shtml" title="Bot home page [new window]">StackRambler</a>',
'redalert','Red Alert',
'rojo','<a href="http://rojo.com/" title="Bot home page [new window]" target="_blank">RoJo</a> aggregator',
'rssimagesbot','<a href="http://herbert.groot.jebbink.nl/?app=rssImages" title="Bot home page [new window]" target="_blank">rssImagesBot</a>',
'ruffle','<a href="http://www.unreach.net/" title="Bot home page [new window]" target="_blank">ruffle SemanticWeb crawler</a>',
'rufusbot','<a href="http://64.124.122.252.webaroo.com/feedback.html" title="Bot home page [new window]" target="_blank">RufusBot Rufus Web Miner</a>',
'sandcrawler','<a href="http://www.microsoft.com/" title="Bot home page [new window]" target="_blank">SandCrawler (Microsoft)</a>',
'sbider','<a href="http://www.sitesell.com/sbider.html" title="Bot home page [new window]" target="_blank">SBIder</a>',
'seekbot','<a href="http://www.seekbot.net/bot.html" title="Bot home page [new window]">Seekbot</a>',
'seznambot','<a href="http://fulltext.seznam.cz/" title="Bot home page [new window]" target="_blank">SeznamBot</a>',
'shoutcast','Shoutcast Directory Service',
'slysearch','SlySearch',
'sohu-search','<a href="http://corp.sohu.com/" title="Bot home page [new window]" target="_blank">sohu-search</a>',
'surveybot','SurveyBot',
'syndic8','Syndic8',
'technoratibot', 'Technoratibot',
't\-h\-u\-n\-d\-e\-r\-s\-t\-o\-n\-e','<a href="http://www.thunderstone.com/" title="Bot home page. Used by many. [new window]" target="_blank">T-H-U-N-D-E-R-S-T-O-N-E</a>',
'topicblogs', '<a href="http://www.topicblogs.com/" title="Bot home page [new window]" target="_blank">topicblogs</a>',
'turnitinbot','Turn It In',
'turtle', 'Turtle',
'turtlescanner', 'Turtle',
'ultraseek', 'Ultraseek',
'w3c\-checklink','<a href="http://validator.w3.org/checklink/" title="Bot home page [new window]" target="_blank">W3C Link Checker</a>',
'w3c_css_validator_jfouffa', '<a href="http://jigsaw.w3.org/css-validator/" title="Bot home page [new window]" target="_blank">W3C jigsaw CSS Validator</a>',
'w3c_validator', '<a href="http://validator.w3.org/" title="Bot home page [new window]" target="_blank">W3C Validator</a>',
'webclipping\.com', 'WebClipping.com',
'webcompass', 'webcompass',
'webvulncrawl', 'WebVulnCrawl',
'wonderer', 'Web Wombat Redback Spider',
'y!j', '<a href="http://help.yahoo.co.jp/help/jp/search/indexing/indexing-15.html" title="Bot home page [new window]" target="_blank">Y!J Yahoo Japan</a>',
'yacy','<a href="http://www.yacy.net/yacy" title="Bot home page [new window]" target="_blank">yacy</a>',
'yahoo\-blogs','<a href="http://help.yahoo.com/help/us/ysearch/crawling/crawling-02.html" title="Bot home page [new window]" target="_blank">Yahoo-Blogs</a>',
'yahoo\-verticalcrawler', 'Yahoo Vertical Crawler',
'yahoofeedseeker', '<a href="http://publisher.yahoo.com/rssguide" title="Bot home page [new window]" target="_blank">Yahoo Feed Seeker</a>',
'yahooseeker\-testing', '<a href="http://search.yahoo.com/" title="Bot home page [new window]" target="_blank">YahooSeeker-Testing</a>',
'yahooseeker', '<a href="http://help.yahoo.com/help/us/ysearch/crawling/crawling-02.html" title="Bot home page [new window]" target="_blank">YahooSeeker Yahoo! Blog crawler</a>',
'yahoo\-mmcrawler', '<a href="mailto:mms-mmcrawler-support@yahoo-inc.com?subject=Yahoo-MMCrawler Information" title="E-mail Bot">Yahoo-MMCrawler</a>',
'yandex', 'Yandex bot',
'zealbot','ZealBot',
'ng\/1\.','<a href="http://www.exabot.com/" title="Bot home page [new window]" target="_blank">NG 1.x (Exalead)</a>', # put at end to avoid false positive
'ng\/2\.','<a href="http://www.exabot.com/" title="Bot home page [new window]" target="_blank">NG 2.x (Exalead)</a>', # put at end to avoid false positive
# Generic root ID
'robot', 'Unknown robot (identified by \'robot\')',
'crawl', 'Unknown robot (identified by \'crawl\')',
'spider', 'Unknown robot (identified by \'spider\')',
'\wbot[\/\-]', 'Unknown robot (identified by \'bot/\' or \'bot-\')',
# Unknown robots identified by hit on robots.txt
'unknown', 'Unknown robot (identified by hit on \'robots.txt\')'
);


# RobotsAffiliateLib
# This list try to tell by which Search Engine a robot is used
#-------------------------------------------------------------
%RobotsAffiliateLib = (
'fast\-webcrawler'=>'AllTheWeb',
'googlebot'=>'Google',
'msnbot'=>'MSN',
'nutch'=>'Looksmart',
'scooter'=>'AltaVista',
'wisenutbot'=>'Looksmart',
'yahoo\-verticalcrawler'=>'Yahoo',
'zyborg'=>'Looksmart',
'cfetch'=>'Kosmix',
'^voyager\/'=>'Kosmix'
);

1;
