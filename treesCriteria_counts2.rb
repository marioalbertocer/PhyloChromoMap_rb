# 	# This script is for counting presence/absence of minor clades in trees
# 	# It also says if a tree contains more than 10 leaves (criterion)
# 	# It needs the report from screipt bestOGsXseq

module TreesCriteria_counts2

	def TreesCriteria_counts2.count(path2files, treesFolder, majorClade, mappingFile)			
		listOGs = File.open(path2files + "/" + mappingFile, 'r').readlines()
		out = File.open(path2files + "/" + 'criteriaANDcounts_out.csv', 'w')
		counts = Array.new

		listOGs.each do |line|
			line = line.sub(/\n/, "")
			tree_code = line.split(",")[3]
			
			if tree_code != "no_tree"
				minCs = Array.new()
				op = am = pl = ex = sr = ee = ba = za = 0
				criterion = 'no'

				# for each OG read the folder of the trees and read the tree for the OG
				trees = Dir.open(path2files + "/" + treesFolder)
				trees.each do |i|
					if i.include? tree_code
						tree = File.open(path2files + "/" + treesFolder + "/" + i, 'r')
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

				if majorClade == "op"
					new_line = "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, tree_code, criterion, op, am, ex, ee, pl, sr, za, ba]
				elsif majorClade == "am"
					new_line = "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, tree_code, criterion, am, op, ex, ee, pl, sr, za, ba]
				elsif majorClade == "ex"
					new_line = "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, tree_code, criterion, ex, ee, pl, sr, am, op, za, ba] 
				elsif majorClade == "ee"
					new_line = "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, tree_code, criterion, ee, pl, sr, ex, am, op, za, ba] 		
				elsif majorClade == "pl"
					new_line = "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, tree_code, criterion, pl, ee, sr, ex, am, op, za, ba] 
				elsif majorClade == "sr"
					new_line = "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % [line, tree_code, criterion, sr, pl, ee, ex, am, op, za, ba]
				end
			
				puts new_line
				out.write(new_line + "\n")
				counts << new_line 
			
			else
				puts line
				out.write("%s\n" % line)
			end
		end	
		
		return "total genes: " + (listOGs.length).to_s + "\n" + "total trees: " + (counts.length).to_s	
		
	end
end 