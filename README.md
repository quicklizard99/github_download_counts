# github_download_counts
Count downloads of github release assets.

## Installation
```
mkvirtualenv github_download_counts
pip install -U pip
pip install -r requirements.pip
```

## Fetch counts

Write counts to a `CSV` file.

```
./github_download_count.py NaturalHistoryMuseum inselect > inselect-downloads.csv
```

## Simple plots

Install [R](https://cran.r-project.org/).

```
Rscript -e "install.packages('Homeric')"
./plot_downloads.R inselect-downloads.csv
```

You will get three `png` files:

```
$ ls -1 *png
inselect-downloads-by-os.png
inselect-downloads-by-time-by-os.png
inselect-downloads-by-time.png
```
