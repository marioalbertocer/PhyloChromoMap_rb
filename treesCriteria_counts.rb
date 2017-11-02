# This script is for counting presence/absence of minor clades in trees
# It also says if a tree contains more than 10 leaves (criterion)
# It needs the report from screipt bestOGsXseq

path = '/Users/marioceron/Documents/katzlab/duplications/orthomcl-release5/'
folder = 'test2/'
major_clade = "op"  # options = "op","am","pl","ex","sr","ee","ba","za"

# Reading report of bestOGsXseq...
listOGs = File.open(path + folder + 'bestOGsXseq_out.csv', 'r')
out = File.open(path + folder + 'criteriaANDcounts_out.csv', 'w')

listOGs = listOGs.readlines()

listOGs.each do |line|
	line = line.sub(/\n/, "")

	#some of the lines in the report says that there is not an OG, so it avoids those ones
	if line =~ /OG5_/
		og = line.split(",")[2]
		
		minCs = Array.new()

		op = am = pl = ex = sr = ee = ba = za = 0
		criterion = 'no'
		
		# for each OG read the folder of the trees and read the tree for the OG		
		treesDir = Dir.open(path + "/" + folder + 'Pipelinev2_2_archive/')
		treesDir.each do |i|
			if i.include? og
				tree = File.open(path + "/" + folder + 'Pipelinev2_2_archive/' + i, 'r')
				tree = tree.readline()
				
 				# As the trees are in neweck format, we can make a list of leaves by 
 				# splitting the tree by the comas.
 				tree = tree.split(',')

 				# if there are more than 10 leaves in the tree, it meets the criterion
				if tree.length > 10
					criterion = 'yes'

 					# Here we are going to clean the leaves, so that we can extract
 					# the major clade and minor clade (e.g., Sr_di).
 					# We collect all cleaned leaves in a list.
 					tree.each do |leaf|
  						leaf = leaf.gsub(/\(/, "")
 						leaf = leaf.gsub(/\)/, "")
 						leaf = leaf.split("_")
 						minCs << leaf[0] + "_" + leaf[1]		
 					end
				end	
				
 				# Now that we have all the leaves (as Sr_di) in a list, we need to 
 				# remove duplicates:
				minCs.uniq!
				
 				# Finally, we count the number of minor clades per major clade there are 
 				# in the tree. 
 				minCs.each do |minC|

					pl = pl + 1	if (minC =~ /Pl_/)
					ee = ee + 1 if (minC =~ /EE_/)
					sr = sr + 1	if (minC =~ /Sr_/)
					ex = ex + 1	if (minC =~ /Ex_/)
					am = am + 1 if (minC =~ /Am_/)															
 					op = op + 1 if (minC =~ /Op_/)
					za = za + 1 if (minC =~ /Za_/)
					ba = ba + 1 if (minC =~ /Ba_/)					

				end
			end 
		end
			
 		# The report is corrected with criterion and counts and printed in the terminal

		if major_clade == "op"
		 	puts "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, og, criterion, op, am, ex, ee, pl, sr, za, ba]
 			out.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % [line, og, criterion, op, am, ex, ee, pl, sr, za, ba]) 
		elsif major_clade == "am"
		 	puts "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, og, criterion, am, op, ex, ee, pl, sr, za, ba]
 			out.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % [line, og, criterion, am, op, ex, ee, pl, sr, za, ba]) 
		elsif major_clade == "ex"
		 	puts "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, og, criterion, ex, ee, pl, sr, am, op, za, ba]
 			out.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % [line, og, criterion, ex, ee, pl, sr, am, op, za, ba]) 
		elsif major_clade == "ee"
			puts "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" % [line, og, criterion, ee, pl, sr, ex, am, op, za, ba]
 			out.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % [line, og, criterion, ee, pl, sr, ex, am, op, za, ba]) 		
		elsif major_clade == "pl"
			puts "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, og, criterion, pl, ee, sr, ex, am, op, za, ba]
 			out.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % [line, og, criterion, pl, ee, sr, ex, am, op, za, ba]) 
		elsif major_clade == "sr"
			puts "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, og, criterion, sr, pl, ee, ex, am, op, za, ba]
 			out.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % [line, og, criterion, sr, pl, ee, ex, am, op, za, ba])
		end
		
	else
 		puts line
 		out.write("%s\n" % line)
	end
end
