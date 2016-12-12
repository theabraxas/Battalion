import sys

inputfile = sys.argv[1]
outputfile = sys.argv[2]

elements = {}
jsonfile = ""
with open(inputfile, "r") as f:
	lines = f.read().split("\n\n") #Splits WPscan data based on empty lines, this is essentially the logical groups
	counter = 0
	for line in lines: 
		if "[+] URL" in line:
			TargetSite = line
		groups = line.split("\n") #Split data based on newlines, essentially elements per group
		elements["var"+str(counter)] = groups
		counter +=1

theme_and_plugin_safe = {} #themes and plugins with no associated vulns
theme_and_plugin_vulns = {} #themes and plugins with known associated vulns
generic_data = {} #Generic data about the scan and target
generic_data["Generic Data"] = []

for group in elements:
	title = ""
	theme_and_plugin_safe_holder = []
	theme_and_plugin_vuln_holder = []
	generic_data_holder = []

	#grouptype checks
	theme_and_plugin_safe_check = False
	theme_and_plugin_vuln_check = False
	generic_data_check = False
	for i in elements[group]:
		if "[!] Title" in i: #This finds themes and plugins with known vulnerabilities
			title = i
			theme_and_plugin_vuln_check = True
		elif "[+] URL" in i or "[i] Wordpress Version" in i or "[+] Finished: " in i or "theme in use" in i or "[+] robots.txt" in i or "plugins found:" in i:
			generic_data_holder.append(i)
			generic_data_check = True
		elif "[+] Name:" in i:
			title = i
			theme_and_plugin_safe_holder.append(i)
			theme_and_plugin_safe_check = True
		elif theme_and_plugin_vuln_check == True:
			theme_and_plugin_vuln_holder.append(i)
		elif theme_and_plugin_safe_check == True:
			theme_and_plugin_safe_holder.append(i)
		elif generic_data_check == True:
			generic_data_holder.append(i)
		else: 
			break

	if len(theme_and_plugin_vuln_holder) > 1:
		theme_and_plugin_vulns[title] = theme_and_plugin_vuln_holder
	if generic_data_check == True:
		generic_data["Generic Data"].append(generic_data_holder)
	if len(theme_and_plugin_safe_holder) > 1:
		theme_and_plugin_safe[title] = theme_and_plugin_safe_holder

#Generic Data Placeholders
ScanDuration = ""
RequestsDone = ""
MemoryUsed = ""
Robots = ""
RobotLocation = ""
WordpressThemeInUse = ""
readme_present = "False"
interesting_headers = "Interesting Header"
interesting_header_json = '"Interesting Headers" : {'
Registration_enabled = "false"
xml_rpc = ""
Upload_dir = ""
Includes_dir = ""
TargetSite = TargetSite.split("[+]")[1].rstrip()
TargetSite = TargetSite.split(": ")[1] 
SafeTheme_SafePlugin = ""
jsonGenerator = '"Safe themes and plugins" : {'



for i in theme_and_plugin_safe: #themes and plugins with no detected vulns _ plus JSON generation
	SafeTheme_SafePlugin = i.split("Name: ")[1]
	jsonGenerator = jsonGenerator + ('"{ThemePlugin}" : {{ ').format(ThemePlugin=SafeTheme_SafePlugin)
	for i in theme_and_plugin_safe[i]:
		if "Latest version" in i:
			jsonGenerator += '"Latest Version" : "%s", ' % i.split(": ")[1].rstrip()
		elif "Location:" in i:
			jsonGenerator += '"Location" : "%s", ' % str(i.split(": ")[1:])[2:-2]
		elif "out of date" in i:
			jsonGenerator += '"Latest version" : "%s", ' % i.split("version is ")[2]
	jsonGenerator = jsonGenerator[:-2] + '}, '
jsonGenerator = jsonGenerator[:-3] + '}'

#############################################

jsonGenerator2 = '"Vulnerable themes and plugins" : {'

if len(theme_and_plugin_vulns) > 1:
	for i in theme_and_plugin_vulns: #Theme and plugin vulnerability Data
		referenceCounter = 1
		AdditionalCounter = 1
		VulnTheme_VulnPlugin = i.split("Title: ")[1]
		jsonGenerator2 = jsonGenerator2 + ('"{ThemePlugin}" : {{ ').format(ThemePlugin=VulnTheme_VulnPlugin)
		jsonGenerator2 += '"Vulnerability Type" : "%s", ' % VulnTheme_VulnPlugin.split(" - ")[1]
		for i in theme_and_plugin_vulns[i]:
			if "Reference" in i:
				url = i.split("Reference: ")[1]
				jsonGenerator2 += '"Reference%s" : "%s", ' % (str(referenceCounter), str(i.split(": ")[1:])[2:-2])
				referenceCounter += 1
			elif "Fixed in:" in i:
				fixed_version = i.split("in: ")[1]
				jsonGenerator2 += '"Fixed in" : "%s", ' % i.split(": ")[1]
			else:
				jsonGenerator2 += '"Additional Data%s" : "%s", ' % (str(AdditionalCounter), i.split(": ")[1])
				AdditionalCounter += 1
		jsonGenerator2 = jsonGenerator2[:-2] + '}, '
else:
	jsonGenerator2 += 'none : "none"   '
jsonGenerator2 = jsonGenerator2[:-2] + '}'

#convert mixed dictionary to single dictionary
generic_data_final ={}
templist = []
for i in generic_data:
	for i in generic_data[i]:
		for j in i:
			templist.append(j)
generic_data_final["Generic Scan Data"] = templist

for j in generic_data_final: #Generic Data Output
	header_counter = 1
	for i in generic_data_final[j]:
		if "Elapsed time" in i:
			ScanDuration = i.split("e: ")[1]
		elif "Requests Done" in i:
			RequestsDone = i.split(": ")[1]
		elif "Memory used" in i:
			MemoryUsed = i.split("used: ")[1]
		elif "robots.txt" in i:
			Robots = "True"
			RobotLocation = i.split(": ")[1]
			RobotLocation = RobotLocation[:-1]
		elif "file exists exposing" in i:
			readme_present = i.split("'")[1]
		elif "theme in use" in i:
			WordpressThemeInUse = i.split(": ")[1]
		elif "Interesting header" in i:
			headerdata = i.split(": ")[1:]
			header = ""
			for i in headerdata:
				header += str(i) + " "
			interesting_header_json += '"Interesting Header%s" : "%s", ' % (header_counter, header.replace('"',"'"))
			header_counter+=1
		elif "Registration is enabled" in i:
			Registration_enabled = i.split(": ")[1]
		elif "XML-RPC" in i:
			xml_rpc = i.split(": ")[1]
		elif "Upload directory" in i:
			Upload_dir = i.split(": ")[1]
		elif "Includes directory" in i:
			Includes_dir = i.split(": ")[1]


interesting_header_json= interesting_header_json[:-2] + "}"

if interesting_header_json == '"Interesting Headers" :}':
	interesting_header_json = '"Interesting Headers" : {"none" : "none"}'


jsonfile = ('{{"WPScan_Site" : "{URL}", "Generic_Scan_Data" : \
	{{ "ScanDuration" : "{ScanDuration}", "Requests Done" : "{RequestsDone}", "Memory Used" : "{MemoryUsed}", "robots.txt present?" : "{Robots}", \
	"Robots.txt Location" : "{RobotLocation}", "Readme File exposing version?" : "{Readme}", "Registration Enabled?" : "{Reg}", "XML-RPC?" : "{XML}", \
	"Exposed Uploads Directory?" : "{Upload}", "Exposed Includes Directory" : "{Include}", {headerJson}, "Theme In Use" : "{WordpressThemeInUse}"}}, {SafeThemePluginJSON}}}, {VulnThemeJson}}}'\
	).format(URL=TargetSite, ScanDuration=ScanDuration,RequestsDone=RequestsDone,MemoryUsed=MemoryUsed,Robots=Robots,RobotLocation=RobotLocation, \
	WordpressThemeInUse=WordpressThemeInUse, SafeThemePluginJSON=jsonGenerator, VulnThemeJson=jsonGenerator2, Readme=readme_present, \
	headerJson=interesting_header_json, Reg=Registration_enabled, XML= xml_rpc, Upload=Upload_dir, Include=Includes_dir)

with open(outputfile, 'w') as f:
    f.write(jsonfile)
