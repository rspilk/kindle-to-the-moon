import sys
import codecs
import time


last = sys.argv[1]
buy = sys.argv[2]
sell = sys.argv[3]

output = codecs.open('template.svg', 'r', encoding='utf-8').read()

output = output.replace("LAST_PRICE", last)
output = output.replace("BUY_PRICE", buy)
output = output.replace("SELL_PRICE", sell)

datetime = time.strftime("%a, %d %b %Y %H:%M:%S %Z", gmtime())

output = output.replace("LAST_UPDATE", datetime)

codecs.open('after-gox.svg', 'w', encoding='utf-8').write(output)
