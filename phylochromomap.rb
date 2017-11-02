require "./treesCriteria_counts2"

def get_parameters
	path2files = ''
	treesFolder = ''
	chromoSizeFile = ''
	mappingFile = ''
	majorClade = ''
	minsOP = ''
	minsAM = ''
	minsEX = ''
	minsPL = ''
	minsEE = ''
	minsSR = ''
	minsBA = ''
	minsZA = ''
	criterion = ''
	m_interval = ''

	parametersFile = File.open('parametersFile.txt', 'r').readlines()
	
	parametersFile.each do |parameter|
		if parameter =~ /\*/
			if parameter =~ /path to files/
				path2files = parameter.split(":")[1].strip
			elsif parameter =~ /trees folder/
				treesFolder = parameter.split(":")[1].strip
			elsif parameter =~ /chromosome size file/
				chromoSizeFile = parameter.split(":")[1].strip
			elsif parameter =~ /mapping file/
				mappingFile = parameter.split(":")[1].strip
			elsif parameter =~ /major clade/
				majorClade = parameter.split(":")[1].strip
			elsif parameter =~ /minor clades OP/
				minsOP = parameter.split(":")[1].strip
			elsif parameter =~ /minor clades AM/
				minsAM = parameter.split(":")[1].strip
			elsif parameter =~ /minor clades EX/
				minsEX = parameter.split(":")[1].strip
			elsif parameter =~ /minor clades PL/
				minsPL = parameter.split(":")[1].strip
			elsif parameter =~ /minor clades EE/
				minsEE = parameter.split(":")[1].strip
			elsif parameter =~ /minor clades SR/
				minsSR = parameter.split(":")[1].strip
			elsif parameter =~ /minor clades BA/
				minsBA = parameter.split(":")[1].strip
			elsif parameter =~ /minor clades ZA/
				minsZA = parameter.split(":")[1].strip
			elsif parameter =~ /criterion/
				criterion = parameter.split(":")[1].strip
			elsif parameter =~ /m_interval/
				m_interval = parameter.split(":")[1].strip
			end
		end
	end
	
	minorsXmajor = [minsOP, minsAM, minsEX, minsPL, minsEE, minsSR, minsBA, minsZA]
	
	return path2files , treesFolder , chromoSizeFile , mappingFile , majorClade , minorsXmajor, criterion, m_interval
	
end

def main		
	
	path2files , treesFolder , chromoSizeFile , mappingFile , majorClade , minorsXmajor, criterion, m_interval = get_parameters

	result_counts = TreesCriteria_counts2.count(path2files, treesFolder, majorClade, mappingFile, criterion)
	puts result_counts
end

main