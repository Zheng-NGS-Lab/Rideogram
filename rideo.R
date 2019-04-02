
# Run command:
#	 Rscript  rideo.R  /your/full/path/to/git/rideo  GUIDE-Seq_target.list.txt

rideoPath = commandArgs(TRUE)[1]
targetFile = commandArgs(TRUE)[2]

fileName = sub('.txt', '', targetFile)

cyto = read.table(paste(rideoPath, '/cytoband.txt', sep=''), header=T, stringsAsFactors=F)
	#head(cyto)
targetFileData = read.table(targetFile, sep='\t', stringsAsFactors=F, header=F)
	#head(targetFileData)
	names(targetFileData) = c('Chromosome', 'Start', 'End', 'Targetsite',  'Mismatches')

	## add 'chr' if not already
	if (substr(targetFileData$Chromosome[1], 1, 3) != 'chr') {
		targetFileData$Chromosome = paste0('chr', targetFileData$Chromosome)
	}
chrs = unique(cyto$Chromosome)
sites = unique(targetFileData$Targetsite)

dir.create('output', showWarnings = FALSE)
##==== Output one pdf file for each site
for (site in sites){
	sitei = subset(targetFileData, Targetsite == site)
	sitei = sitei[order(-sitei$Mismatches),]
    pdf(paste('output/', fileName, ".",site, '.pdf', sep=''))
	ymax = max(cyto$ChromEnd)
	plot(0, xlim=c(0,24), ylim=c(0,ymax), type='n'
		, axes=F, xlab='Chromosome', ylab=''
		, main=site)
	
	legend('topright', col=c(3,2), legend=c('on-target','off-target'), border=NA, pch='-')	
	xpos = 1

	for (chr in chrs) {
	    di = cyto[cyto$Chromosome == chr, ]
	    ymax = max(di$ChromEnd)
	    starts = ymax - di$ChromStart
	    ends = ymax - di$ChromEnd
	    x1 = rep(xpos-0.2, length(starts))
	    x2 = rep(xpos+0.2, length(starts))
	    rect(x1, starts, x2, ends, col = di$BandColor, border = NA)
	    mtext(side=1, line=0, at=xpos, sub('chr','',chr), cex=0.9)	

	    # outer
	    rect(xpos-0.2, 0, xpos+0.2, ymax, col = NA, border = 1)
	    cent = di[di$BandColor=='red',]
	    cent
	    rect(xpos-0.2, ymax - cent$ChromStart, xpos+0.2, ymax - cent$ChromEnd, col = 'white', border = 'white')
	    lines(c(xpos-0.2, xpos+0.2), c(ymax - cent$ChromStart[1], ymax - cent$ChromEnd[2]), col =1)
	    lines(c(xpos+0.2, xpos-0.2), c(ymax - cent$ChromStart[1], ymax - cent$ChromEnd[2]), col =1)

	    ## targets
	    siteichr = sitei[sitei$Chromosome==chr,]
	    siteichr$off = ymax - siteichr$Start
	    (nn = nrow(siteichr))
	    
	    points(rep(xpos, nn), siteichr$off, pch='-', col=ifelse(siteichr$Mismatches==0, 3, 2), cex=2.5)
	    xpos = xpos+1
	}
dev.off()
}
