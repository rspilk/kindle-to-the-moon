#!/bin/sh

# where the generated image should be placed - modify to suit your environment
WWWROOT="/var/www/static"

# chart URLs
BTC_CHART='http://www.bitcoincharts.com/charts/chart.png?width=600&height=163&r=1&i=30-min&t=S&i1=Vol&m=mtgoxUSD'
DEPTH_CHART='http://bitcoincharts.com/charts/mtgoxUSD/accumulated_orderbook.png'

# change cwd to this script's location so we don't make a mess elsewhere
cd "$(dirname "$0")"

# parse gox market data
GOX_TICKER=$(wget -qO- 'http://data.mtgox.com/api/2/BTCUSD/money/ticker_fast?pretty')
buy=$(echo "${GOX_TICKER}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["data"]["buy"]["display"]')
sell=$(echo "${GOX_TICKER}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["data"]["sell"]["display"]')
last=$(echo "${GOX_TICKER}" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["data"]["last"]["display"]')

# generate svg with filled-in prices
python2.7 gox.py "$last" "$buy" "$sell"

# convert svg to png
rsvg-convert --background-color=white -o after-gox.png after-gox.svg

# download Bitcoin chart and make it darker
wget -qO bitcoin.png "${BTC_CHART}"
convert bitcoin.png  -level 0%,100%,0.1 bitcoin_darkened.png

# download depth chart and make it darker
wget -qO depth.png "${DEPTH_CHART}"
convert -resize 600 -level 0%,100%,0.1 depth.png depth2.png

# combine prices and charts
composite -gravity South -geometry +0+140 bitcoin_darkened.png after-gox.png combined.png
composite -gravity South -geometry +0+20 depth2.png combined.png combined2.png

# optimize the image file size
pngcrush -c 0 -ow combined2.png done.png

# move the image where it needs to be
mv done.png ${WWWROOT}/my_kindle.png
