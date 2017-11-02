# This script creates the intervals each X nucleotides (X is defined 
# for the user in the parameters file) for the chromosome maps. 
# Then it places the OGs and loci in their interval. Beware that the output
# can have more than one OG/seq per interval. So, it's necesary to inspect 
# those few cases by with the script 'mapInfoHelper'.

# Input: 
# - criteriaANDcounts_out.txt from 'treesCriteria_counts'
# - m_interval (number of nucleotides that separates each interval)

folder = 'test2/'
path = '/Users/marioceron/Documents/katzlab/duplications/orthomcl-release5/'
out = File.open(path + folder + 'mapInfo.csv', 'w')
toMap = File.open(path + folder + 'criteriaANDcounts_out.csv', 'r')
toMap = toMap.readlines()

chrDir = Dir.open(path + folder + 'genome/')

# for each chromosome... 
chrDir.each do |chrFile|

	# Here we create the intervals from the genome sequences
	# it takes the sequences, calculate lenght and do intervals each
	# 1000 kb up to the length of the chromosome.
	
	if chrFile =~ /.fasta/
		intervals = Array.new()
		chr = chrFile.split(".")[0]
		chrSeq = File.open(path + folder + 'genome/' + chr + ".fasta", 'r')
		chrSeq = chrSeq.readlines()
		chrSeq.delete_if{|x| x =~ />/} # for deleting lines containing tags
		chrSeq = chrSeq.join
		chrSeq = chrSeq.gsub(/\n/, "")
		chr = chr.split(".")[0]
		chrLen = chrSeq.length
		
		m = 1000 # length of the intervals
		position = 1
		intervals << position
		
		while (position <= chrLen)
			position = position + m
			intervals << position
		end		
		
		# At this point the intervals are already done and saved in a array. Now we are going 
		# to read the coding sequences. In future lines we will use them for grabbing the loci from the tags. 
		cdsFile = File.open(path + folder + 'seqs/' + chr + '.txt', 'r')
		cdsFile = cdsFile.readlines()
		
		# Now we need the data that we are going to map in the intervals. So, we take the info from 'criteriaANDcounts_out'
		toMap_loci = Array.new()
		toMap.each do |line|
			line = line.sub(/\n$/, "")
			if line.include? chr		# As we are working per chromosome (see first loop above). Then we need to filter the lines 
										# that containg that chromosome
				if line !~ /no_group/				# We just need OGs, no 'no_groups'
#					values = line.split("\t")
					values = line.split(",")
					seq = values[1]
					og = values[2]
					criterion = values[5]
					counts = values[6..13]
#					counts = counts * "\t"
					counts = counts * ","
				
					if criterion =~ /yes/	# only consider OGs that meet our criterion
						cdsFile.each do |line2|		
							if line2.include? seq
								
								# Here we take the locus of every sequence for placing it on the intervals					
								loci = line2.split(" ")[-1]
								loci = loci.gsub(/^.*=/, "")
								loci = loci.gsub(/[A-z]/, "")
								loci = loci.gsub(/\(|\)|\[|\]/, "")
								loci = loci.gsub(/\.\./, ",")
								loci = loci.split(",")
								
								# data from microsporidia database
#								loci = line2.split("location=")[1]
#								loci = loci.sub(/^.*:/, "")
#								loci = loci.sub(/\(.*$/, "")
#								loci = loci.split("-")

								# Now we have all loci of the seqs rgat 
								loci_sorted = Array.new()
								loci.each do |locus|
									locus_sorted = locus.to_i
									loci_sorted << locus_sorted
								loci_sorted = loci_sorted.sort
 	 							end
 	 							 	 							
#								toMap_loci << "locus:" + loci_sorted[0].to_s + "-" + loci_sorted[-1].to_s + "\t" + "seqID:" + seq + "\t" + "OG:" + og + "\t" + "counts:" + counts
								toMap_loci << "locus:" + loci_sorted[0].to_s + "-" + loci_sorted[-1].to_s + "," + "seqID:" + seq + "," + "OG:" + og + "," + "counts:" + counts
							end
						end
					end
				end	
			end
		end
		
		intervals.each do |interval|
			neighbors = Array.new()
			toMap_loci.each do |toMap_locus|
#				locus = toMap_locus.split("\t")[0]
				locus = toMap_locus.split(",")[0]
				locus = locus.sub(/locus:/, "")
				locus = locus.split("-")[0]
				if locus.to_i >= interval
					if locus.to_i < (interval + 1000)
						neighbors << toMap_locus
					end
				end
			end	
		
			if neighbors == []
				puts chr + "\t" + interval.to_s
#				out.write(chr + "\t" + interval.to_s + "\n")
				out.write(chr + "," + interval.to_s + "\n")			
			else
#				neighbors = neighbors * "\t"
				neighbors = neighbors * ","
				puts chr + "\t" + interval.to_s + "\t" + neighbors
#				out.write(chr + "\t" + interval.to_s + "\t" + neighbors + "\n")
				out.write(chr + "," + interval.to_s + "," + neighbors + "\n")
			end
		end						
	end	
end		