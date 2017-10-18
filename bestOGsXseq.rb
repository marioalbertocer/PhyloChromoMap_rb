# This script takes the report from parseBLASTut.rb to pick the OGs with the 
# best evalues per sequence. 

summary = open("/Users/marioceron/Documents/katzlab/duplications/orthomcl-release5/test2/summary.txt", 'r') # path to the report from parseBLASTut.rb
out = open("/Users/marioceron/Documents/katzlab/duplications/orthomcl-release5/test2/bestOGsXseq_out.txt", 'w') # path to the report from parseBLASTut.rb
summary = summary.readlines()

list = Array.new()

# here we build a list like "chromosome	sequence"
summary.each do |line|
	line = line.split("\t")
	list << line[0] + "\t" + line[1]
end	

list.uniq!	# Creating categories. The same "chromosome	sequence" can be many times in the 
			# report from parseBLASTut.rb because a sequence can blast more than one OG 
			# and more than one sps. 
 
list.each do |line|
	line = line.split("\t")
	chr = line[0]
	seq = line[1]
	
	pickedEval = 1
	pickedOG = ""
	og = ""
	
	summary.each do |line2| # for each category (chr seq) read the report again
		if line2.include? chr
			if line2.include? seq
				line2 = line2.split("\t")
				e_val = line2[-1].to_f # from each blast result per category collect eval 
				og = line2[4] # ... and og
				
				# in the next step we compare the eval of the results per category (except
				# the ones that has no_group instead of a regular OG. Then, we pick the 
				# lowest. 
				
				if og != 'no_group'
					if (e_val < pickedEval)
						pickedEval = e_val
						pickedOG = og
					end	
				end
			end		
		end
	end

	if pickedEval == 1
		pickedEval = 'NA'
	end
	
	if pickedOG == ""
		pickedOG = og
	end
	
	puts chr + "\t" + seq + "\t" + pickedOG.to_s + "\t" + pickedEval.to_s
	out.write(chr + "\t" + seq + "\t" + pickedOG.to_s + "\t" + pickedEval.to_s + "\n")
end