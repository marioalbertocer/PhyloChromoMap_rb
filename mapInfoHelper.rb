"""
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
"""

folder = 'test2/'
path = '/Users/marioceron/Documents/katzlab/duplications/orthomcl-release5/'
out = File.open(path + folder + 'mapInfo_corrected.csv', 'w')
out2 = File.open(path + folder + 'notMappedGenes.csv', 'w')
mapinfo = File.open(path + folder + 'mapInfo.csv', 'r')
mapinfo = mapinfo.readlines()

map = mapinfo

exe = 'y'
run = 0

while exe == 'y' do
	
	# This is an iterative process. The explanation of the use of while loop here will be at 
	# the end ...
	
	run = run + 1
	to_add = ""
	count_changes = 0
	map_corrected = Array.new()
	
	puts "\nRUN # " + run.to_s + ":\n" 
	
#	Reading mapInfo ...
#	mapinfo.each do |line|
	map.each do |line|
		line = line.sub(/\n$/, "") if line =~ /\n$/
#		values = line.split("\t")
		values = line.split(",")
	
		# ---------------------------
		# It is going to print each line in the output exactly as in mapInfo except when there 
		# is more than one sequence mapped in the same interval. When there is in a interval with
		# more than one sequences, it prints only the first sequence for the current interval and saves 
		# the remaining sequences in the global variable "to_add". Then it checks if the knext interval 
		# if empty and redistribute the genes saved in to_add following the logic described in the 
		# cases above
		# ---------------------------

		if values.length >= 24	# if two or more sequences in the current interval ...		
#			first = values[0..12] * "\t"  # takes the first seq
			first = values[0..12] * ","  # takes the first seq
#			rest = values[13..-1] * "\t"  # takes the remaining seqs
			rest = values[13..-1] * ","  # takes the remaining seqs
			out2.write(to_add + "\n") if to_add != ""
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
		
			# ----------------------------
			# If the next interval is empty it checks if there are genes saved in to_add. If so, and 
			# part of the first gene (in to_add) falls in this interval, it adds to_add to the interval(*).
			# In contrast, if the gene falls totally in the last interval, it removes the gene from to_add, 
			# takes the next gene from to_add and repeats the procedure. The records of clade counting and
			# locus for every gene that does not fall in the interval (and therefore removed from to_add) is
			# saved in notMappedGenes.txt
			# ----------------------------
			
			while to_add != "" do
#				remainingGenes = to_add.split("\t")
				remainingGenes = to_add.split(",")
				if values[1].to_i < (remainingGenes[0].split("-")[1]).to_i # if first gene is still inside the range
					count_changes += 1
#					line = line + "\t" + to_add
					line = line + "," + to_add					
					to_add = ""	# After this iteration to_add should be set to ""
				else
					count_changes += 1
#					not_mapped = remainingGenes[0..10] * "\t"
					not_mapped = remainingGenes[0..10] * ","					
					out2.write(not_mapped + "\n")
					
					if remainingGenes[11]
						remainingGenes = remainingGenes[11..-1]
#						to_add = remainingGenes * "\t"
						to_add = remainingGenes * ","
					else
						to_add = "" # After this iteration to_add should be set to ""
					end
				end
			end
			
			puts line
			map_corrected << line

		end
	
		# if the next iteration interval containing either one sequence or more than 2, it
		# would print the line of mapinfo without any modification. 
	
		if (values.length == 13)
			out2.write(to_add + "\n") if to_add != ""
			to_add = ""
			puts line
			map_corrected << line
		end
	end
	
	map = map_corrected
	
	puts "number of changes: " + count_changes.to_s
	if count_changes == 0
		exe = 'n' 
	end
	
	# This is an iterative process. It will redistribute the second gene in each interval that 
	# has more than one gene. Then the whole process is repeted for redistributing the third genes
	# and so on. The variable count_changes tacks the number of changes per iteration, if there
	# are not more changes in an iteration then the loop stops. 
	
end

# ----------------------------
# Writing mapInfo_corrected   |
# ----------------------------

puts "\n\n===== mapInfo_corrected =====\n\n"
map.each do |line|
	puts line
	out.write(line + "\n")
end