#!/usr/bin/env Rscript
library(Homeric)

fname <- tail(commandArgs(trailingOnly=TRUE), 1)
downloads <- read.csv(fname)
downloads <- downloads[nrow(downloads):1, ]

downloads$created_at <- as.Date(substr(downloads$created_at, 0, 10), format='%Y-%m-%d')
downloads$os_with_bits <- factor(paste(downloads$os, downloads$bits))
downloads <- cbind(downloads, total_downloads=cumsum(downloads$download_count))

cumsum.by.os <- tapply(downloads$download_count, downloads$os_with_bits, cumsum)
downloads$total_downloads_by_os <- NA
for(os.name in names(cumsum.by.os)) {
    downloads$total_downloads_by_os[os.name == downloads$os_with_bits] <- cumsum.by.os[[os.name]]
}

TODAY <- Sys.Date()

COLOURS <- c('#a6cee3', '#1f78b4', '#b2df8a', '#33a02c', '#fb9a99', '#e31a1c',
              '#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928')
              COLOURS <- c('#C2E4AA', '#9FE5D9', '#D98041', '#D5DEE5', '#8CBC7B', '#9BC7D3')

png(sub('.csv', '-by-time.png', fname), width=800, height=600)
par(mar=c(3, 3, 2, 0.5), las=1)
plot(
    c(downloads$created_at, TODAY), c(downloads$total_downloads, tail(downloads$total_downloads, 1)),
    main='Cummulative installer downloads', xaxt='n',
    type='s'
)
axis.Date(
    side=1,
    at=seq(as.Date('2015-01-01'), TODAY, by='quarter'),
    format='%Y-%m-%d'
)
dev.off()

png(sub('.csv', '-by-time-by-os.png', fname), width=800, height=600)
par(mar=c(3, 3, 2, 0.5), las=1)
plot(NA, NA,
    xlim=c(min(downloads$created_at), TODAY),
    ylim=range(downloads$total_downloads_by_os),
    main='Cummulative installer downloads by OS', xaxt='n', type='n'
)

by(downloads, downloads$os_with_bits, function(rows) {
    lines(
        c(rows$created_at, TODAY),
        c(rows$total_downloads_by_os, tail(rows$total_downloads_by_os, 1)),
        col=COLOURS[as.numeric(rows$os_with_bits)], pch=19,
        type='s', lwd=2
    )
})

legend('topleft', legend=levels(downloads$os_with_bits), lwd=3, col=COLOURS)

axis.Date(
    side=1,
    at=seq(as.Date('2015-01-01'), TODAY, by='quarter'),
    format='%Y-%m-%d'
)
dev.off()

png(sub('.csv', '-by-os.png', fname), width=600, height=600)
par(mar=rep(0.5, 4), las=1)
PlotDoughnut(
    tapply(downloads$download_count, downloads$os_with_bits, sum),
    col=COLOURS
)
dev.off()
