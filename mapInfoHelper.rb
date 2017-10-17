# This script helps to correct the file 'mapInfo' produced by the script 'intervals'
# The problems in mapInfo is that some intervals have more than one sequence/og associated.
# This scripts takes the intervals that contain exactly two sequences/ogs, splits the 
# sequences/ogs and put the second sequence/og in the next interval. Beware that this is 
# just a method that I propose to solve the problem. If the first codons of two sequences 
# are in the same interval, it is very likelly that they also occupy the next interval. 
# This iscript resolve most of the problematic cases. However, some cases would need manual
# inspection.

# In which cases this script is not useful (rare cases): 
# - When the next interval already contains a sequence/og.
# - When instead of 2 sequences per interval you have more than 2

folder = 'Dictyostelium_discoideum/'
path = '/Users/marioceron/Documents/katzlab/duplications/orthomcl-release5/'
out = File.open(path + folder + 'mapInfo_corrected.txt', 'w')
mapinfo = File.open(path + folder + 'mapInfo.txt', 'r')
mapinfo = mapinfo.readlines()

map = Array.new()

i = 0
to_add = ""

# Reading mapInfo ...
mapinfo.each do |line|
	line = line.sub(/\n$/, "")
	i = i + 1
	values = line.split("\t")
	
	# ---------------------------
	# It is going to print each line in the output exactly as in mapInfo except when there 
	# are 2 sequences mapped in the same interval. When it is in a interval with 2
	# sequences, it prints only the first sequence for the current interval and saves 
	# the second sequence in the global variable "to_add". For the next iteration, if the 
	# interval is empty, it adds the sequence saved in to_add. Before ending the iteration 
	# to_add sould be set to "" again, so that it can be used in a further iterations with
	# interval containing two sequences. 
	# ----------------------------

	if values.length == 24	# if two sequences in the current interval ...		
		first = values[0..12] * "\t"  # takes the first seq
		second = values[13..23] * "\t"  # takes the second seq
		to_add = "" 
		nextline = mapinfo[i].split("\t")	# explore ahead the line of mapinfo that would
											# be used in the next iteration.
		
		if nextline.length == 2 # if the next line is epnty ...
			to_add = second		# put the second sequence in global variable "to_add
			line = first		# modify the line of mapInfo and print the interval with 
								# only the first sequence.
			puts line
			out.write(line + "\n")
		else						# But is the next iteration is in a interval that already 
   			puts line				# has a sequence, then don't split anything and print
			out.write(line + "\n")	# exactly as in mapinfo.
		end 
	end
	
	# if the next iteration is in a enpty interval, it would add the sequence saved in 
	# the previous iteration by adding the global variable "to_add" to the line of mapinfo
	
	if values.length == 2
		if to_add != ""	
			line = line + "\t" + to_add
			to_add = ""	# After this iteration to_add should be set to ""
			puts line
			out.write(line + "\n")
		else
			puts line 
			out.write(line + "\n")
		end
	end
	
	# if the next iteration interval containing either one sequence or more than 2, it
	# would print the line of mapinfo without any modification. 
	
	if (values.length == 13 || values.length > 24)
		puts line
		out.write(line + "\n")
	end
end
