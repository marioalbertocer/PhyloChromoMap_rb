# This script takes the results of the blast reports (no xml or html) and builds a report
# including chr (which is the name of the blast report), sequnece id, sps seq that blasts 
# from the orthomcl database, the OG in which that seq was classified, description of que-
# ry sequence, score of the blast result and eval of the blast result.  

path = '/Users/marioceron/Documents/katzlab/duplications/orthomcl-release5/Dictyostelium_discoideum/BlastReports/'

out = File.open(path + 'summary.txt', 'w')

reportsBlast = Dir.open(path)

reportsBlast.each do |reportChr|
	if reportChr =~ /out/
		report = open(path + reportChr, 'r')
		report = report.readlines()
		
		index = 0
		queries_index = Hash.new('no-query')
		
		report.each do |line|
			index = index + 1
			if line =~ /^Query=/
				query = line.sub(/Query= /, "")
				query = query.sub(/ \|.*\n$/, "")
				query = line.sub(/^.*_cds_/, "")
				query = query.sub(/_[0-9]+\s\[gene.*\n$/, "")
				queries_index[query] = index - 1
			end
		end
		
		queries = queries_index.keys
		index_b = 0
		
		queries.each do |query|
			index_b = index_b + 1
			record_start = queries_index[query]
			
			if index_b < (queries_index[queries[index_b]]).to_i
				record_end = queries_index[queries[index_b]]
			else
				record_end = report.length
			end

			record = report[record_start..record_end]
			
			
#			puts record_start
#			puts record_end
			record.each do |line|
				if line =~ /^  [a-z]{4}/
					line = line.sub(/\n$/, "")
					line = line.gsub(/(^\s+)|(\s+$)/, "")
					line = line.gsub(/\s\|\s/, "\|")
					line = line.gsub(/\|\s+/, "\|no description\|")
					line = line.gsub(/\s{2,}/, "\|")
					values = line.gsub(/\s{2,}|\|/,"\t")
					values = values.split("\t")
#					puts values
					
					sps = values[0]
					access = values[1]
					og = values[2]
					description = values[3]
					score = values[4].to_i
					e_val = values[5].to_f
					
					if e_val < 1e-15
						print reportChr + "\t" + query + "\t" + sps + "\t" + access + "\t" + og + "\t"  
						out.write(reportChr + "\t" + query + "\t" + sps + "\t" + access + "\t" + og + "\t")
						print description + "\t" + score.to_s + "\t" + e_val.to_s + "\n"
						out.write(description + "\t" + score.to_s + "\t" + e_val.to_s + "\n")
					end
				end
			end
		end
	end
end
					
			
			
	