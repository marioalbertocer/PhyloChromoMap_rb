# The input matrix should contain all intervals with the counts
# The output matrix countain 1 or 0 for every hypothesis

# Example of first 2 lines of input matrix

#chr01	1	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
#chr01	1001	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00

path = '/Users/marioceron/Documents/plasmodium/map/'
inputMatrix = File.open(path + 'InputMatrix4hypotheses.txt', 'r')
outputMatrix = File.open(path + 'outputMatrix4hypotheses.txt', 'w')
inputMatrix = inputMatrix.readlines()

# This is the default order of the counts, you can change it according to your data
$majorClades = ["Sr","Pl","Op","EE","Am","Ex","Ba","Za"]

# Here we are taking the counts and specifing to which major clade they belong
def assignCounts(counts)
	countsXmajor = Hash.new
	index = -1
	
	$majorClades.each do |majorClade|
		index = index + 1
		countsXmajor[majorClade] = counts[index].to_f
	end
	return countsXmajor
end

# Hypothesis 1: Gene originated in LUCA

def hypothesis1(countsXmajor) 
	criteria = 0
	euks = 0
	euks += 1 if countsXmajor['Sr'] >= 0.25
	euks += 1 if countsXmajor['Pl'] >= 0.25
	euks += 1 if countsXmajor['Op'] >= 0.25
	euks += 1 if countsXmajor['EE'] >= 0.25
	euks += 1 if countsXmajor['Am'] >= 0.25
	euks += 1 if countsXmajor['Ex'] >= 0.25		
	criteria += 1 if countsXmajor['Ba'] >= 0.25 
	criteria += 1 if countsXmajor['Za'] >= 0.25 
	criteria += 1 if euks >= 5
	if criteria == 3
		return 1
	else
		return 0 
	end
end

# Hypothesis 2: Gene originated common ancestor of Archaea and Euks

def hypothesis2(countsXmajor) 
	criteria = 0
	euks = 0
	euks += 1 if countsXmajor['Sr'] >= 0.25
	euks += 1 if countsXmajor['Pl'] >= 0.25
	euks += 1 if countsXmajor['Op'] >= 0.25
	euks += 1 if countsXmajor['EE'] >= 0.25
	euks += 1 if countsXmajor['Am'] >= 0.25
	euks += 1 if countsXmajor['Ex'] >= 0.25		
	criteria += 1 if countsXmajor['Ba'] < 0.25 
	criteria += 1 if countsXmajor['Za'] >= 0.25 
	criteria += 1 if euks >= 5
	if criteria == 3
		return 1
	else
		return 0 
	end
end

# Hypothesis 3: EGT from mitochondria

def hypothesis3(countsXmajor) 
	criteria = 0
	euks = 0
	euks += 1 if countsXmajor['Sr'] >= 0.25
	euks += 1 if countsXmajor['Pl'] >= 0.25
	euks += 1 if countsXmajor['Op'] >= 0.25
	euks += 1 if countsXmajor['EE'] >= 0.25
	euks += 1 if countsXmajor['Am'] >= 0.25
	euks += 1 if countsXmajor['Ex'] >= 0.25		
	criteria += 1 if countsXmajor['Ba'] >= 0.25 
	criteria += 1 if countsXmajor['Za'] < 0.25 
	criteria += 1 if euks >= 5
	if criteria == 3
		return 1
	else
		return 0 
	end
end

# Hypothesis 4: EGT from plastid (relaxed)

def hypothesis4(countsXmajor) 
	criteria = 0
	photoeuks = 0
	nonPhotoeuks = 0
	photoeuks += 1 if countsXmajor['Sr'] >= 0.25
	photoeuks += 1 if countsXmajor['Pl'] >= 0.25
	photoeuks += 1 if countsXmajor['EE'] >= 0.25
	nonPhotoeuks += 1 if countsXmajor['Op'] >= 0.25
	nonPhotoeuks += 1 if countsXmajor['Am'] >= 0.25
	nonPhotoeuks += 1 if countsXmajor['Ex'] >= 0.25		
	criteria += 1 if countsXmajor['Ba'] >= 0
	criteria += 1 if countsXmajor['Za'] < 0.25
	criteria += 1 if photoeuks >= 2
	criteria += 1 if nonPhotoeuks == 0
	if criteria == 4
		return 1
	else
		return 0 
	end
end

# Hypothesis 5: EGT from plastid (strict)

def hypothesis5(countsXmajor) 
	criteria = 0
	photoeuks = 0
	nonPhotoeuks = 0
	photoeuks += 1 if countsXmajor['Sr'] >= 0.25
	photoeuks += 1 if countsXmajor['Pl'] >= 0.25
	photoeuks += 1 if countsXmajor['EE'] >= 0.25
	nonPhotoeuks += 1 if countsXmajor['Op'] >= 0.25
	nonPhotoeuks += 1 if countsXmajor['Am'] >= 0.25
	nonPhotoeuks += 1 if countsXmajor['Ex'] >= 0.25		
	criteria += 1 if countsXmajor['Ba'] >= 0
	criteria += 1 if countsXmajor['Za'] < 0.25
	criteria += 1 if photoeuks == 3
	criteria += 1 if nonPhotoeuks == 0
	if criteria == 4
		return 1
	else
		return 0 
	end
end

# Hypothesis 6: Gene from common ancestor of eukaryotes

def hypothesis6(countsXmajor) 
	criteria = 0
	euks = 0
	euks += 1 if countsXmajor['Sr'] >= 0.25
	euks += 1 if countsXmajor['Pl'] >= 0.25
	euks += 1 if countsXmajor['Op'] >= 0.25
	euks += 1 if countsXmajor['EE'] >= 0.25
	euks += 1 if countsXmajor['Am'] >= 0.25
	euks += 1 if countsXmajor['Ex'] >= 0.25	
	criteria += 1 if countsXmajor['Ba'] < 0.25
	criteria += 1 if countsXmajor['Za'] < 0.25
	criteria += 1 if euks >= 5
	if criteria == 3
		return 1
	else
		return 0 
	end
end

# Test each hypothesis

inputMatrix.each do |line|
	
	hypotesesResults = Array.new
	line = line.sub(/\n$/, "")
	values = line.split("\t")
	chr = values[0]
	position = values[1].to_i
	counts = values[2..-1]
	countsXmajor = assignCounts(counts)
	hypotesesResults = Array.new
	
	hypotesesResults.push((hypothesis1(countsXmajor)).to_s)
	hypotesesResults.push((hypothesis2(countsXmajor)).to_s)
	hypotesesResults.push((hypothesis3(countsXmajor)).to_s)	
	hypotesesResults.push((hypothesis4(countsXmajor)).to_s)
	hypotesesResults.push((hypothesis5(countsXmajor)).to_s)
	hypotesesResults.push((hypothesis6(countsXmajor)).to_s)
	
	puts countsXmajor
	print hypotesesResults
	puts "\n"
	
	outputMatrix.write(chr + "\t" + position.to_s + "\t" + hypotesesResults.join("\t") + "\n")
end