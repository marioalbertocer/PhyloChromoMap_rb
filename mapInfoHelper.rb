'''
This script will help to redistribute the genes that fall in the same interval on the map

* case 1: A GENE FALL BETWEEN TWO INTERVALS
intervals.rb organizes the genes with range 2300-2700 and 2800-3300 in the same range 
because their first codon is in the range 2000-3000. Then, mpInfoHelper.rb puts the second 
gene in the interval 3000-4000. 

* case2: TWO GENES FALL IN SAME INTERVAL
intervals.rb organizes the genes with range 2300-2700 and 2700-2900 in the same range 
because their first codon is in the range 2000-3000. In this case mpInfoHelper.rb cannot put
the second gene in the interval 3000-4000 because the last codon does not fall in the same
in this range. As a result the second gene is not mapped but the record of location and 
clade counting will be saved in the document notMappedGenes.txt

* case3: MORE THAN TWO GENES FALL IN SAME INTERVAL, OVERLAPPING GENES
intervals.rb organizes the genes with range 2300-2700, 2800-3300 and 2900-4010 in the same range 
because their first codon is in the range 2000-3000. Then, mpInfoHelper.rb puts the second 
gene in the interval 3000-4000 and the third gene in the interval 3000-4000. This is because
it follows the logic of case 1. 

* case4: TWO GENES FALL IN SAME INTERVAL AND NEXT INTERVAL IS ALREADY OCCUPIED 
intervals.rb organizes the genes with range 2300-2700 and 2800-3300 in the same range 
because their first codon is in the range 2000-3000. Then, mpInfoHelper.rb needs to put the 
second gene in the interval 3000-4000. But, if intervals.rb already put another gene in the
interval 3000-4000, then the second gene would not be mapped. Still, the record of location and 
clade counting will be saved in the document notMappedGenes.txt

'''

folder = 'test2/'
path = '/Users/marioceron/Documents/katzlab/duplications/orthomcl-release5/'
#out = File.open(path + folder + 'mapInfo_corrected.txt', 'w')
mapinfo = File.open(path + folder + 'mapInfo.txt', 'r')
mapinfo = mapinfo.readlines()

map = mapinfo

exe = 'y'
run = 0

while exe == 'y' do
	
	# This is an iterative process. The explanation of the use of while loop here will be at 
	# the end ...
	
	puts "exe: " + exe
	run = run + 1
	to_add = ""
	count_changes = 0
	map_corrected = Array.new()
	
	puts "RUN # " + run.to_s + ":\n" 
	
#	Reading mapInfo ...
#	mapinfo.each do |line|
	map.each do |line|
		line = line.sub(/\n$/, "") if line =~ /\n$/
		values = line.split("\t")
	
		# ---------------------------
		# It is going to print each line in the output exactly as in mapInfo except when there 
		# is more than one sequence mapped in the same interval. When there is in a interval with
		# more than one sequences, it prints only the first sequence for the current interval and saves 
		# the remaining sequences in the global variable "to_add". For the next iteration, if the 
		# interval is empty, it adds the remaining sequences saved in to_add. Before ending the iteration 
		# to_add sould be set to "" again, so that it can be used in a further iterations with
		# interval containing two sequences. 
		# ----------------------------

		if values.length >= 24	# if two or more sequences in the current interval ...		
			first = values[0..12] * "\t"  # takes the first seq
			rest = values[13..23] * "\t"  # takes the second seq
			to_add = "" 
			to_add = rest		# put the remaining sequences in global variable "to_add"
			line = first		# modify the line of mapInfo and print the interval with 
									# only the first sequence.
			puts line
			map_corrected << line
		end
	
		# if the next iteration is in a enpty interval, it would add the sequence saved in 
		# the previous iteration by adding the global variable "to_add" to the line of mapinfo
	
		if values.length == 2
			if to_add != ""
				if values[1].to_i < ((to_add.split("\t")[0]).split("-")[1]).to_i # if the gene is still inside the range
					count_changes += 1
					line = line + "\t" + to_add
					to_add = ""	# After this iteration to_add should be set to ""
				end
			
				puts line
				map_corrected << line

			else
				puts line 
				map_corrected << line
			end
		end
	
		# if the next iteration interval containing either one sequence or more than 2, it
		# would print the line of mapinfo without any modification. 
	
		if (values.length == 13)
			to_add = ""
			puts line
			map_corrected << line
		end
	end
	
	map = map_corrected
	
	puts "count_changes: " + count_changes.to_s
	if count_changes == 0
		exe = 'n' 
		puts "here is the exe: " + exe
	end
	
	# This is an iterative process. It will redistribute the second gene in each interval that 
	# has more than one gene. Then the whole process is repeted for redistributing the third genes
	# and so on.
	
end