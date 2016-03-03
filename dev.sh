#!/bin/bash

export RUN_ENV=development

gradle jrubyJar && java -jar ./build/libs/srv-barcode-mobile-jruby.jar -S rackup -o 0.0.0.0 -p 3000
