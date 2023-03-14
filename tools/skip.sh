#!/bin/bash

if [ "$USER" = "root" ]; then
	echo "root로 실행하지 마세요"
	exit 0
fi

if [ "$1" = "0" ]; then
	touch ../stage0/SKIP
        rm ../stage1/SKIP
        rm ../stage2/SKIP
	rm ../stage2/SKIP_IMAGES
        rm ../stage3/SKIP
        rm ../stage4/SKIP
        rm ../stage5/SKIP
elif [ "$1" = "1" ]; then
        touch ../stage0/SKIP
        touch ../stage1/SKIP
        rm ../stage2/SKIP
	rm ../stage2/SKIP_IMAGES
        rm ../stage3/SKIP
        rm ../stage4/SKIP
        rm ../stage5/SKIP
elif [ "$1" = "2" ]; then
        touch ../stage0/SKIP
        touch ../stage1/SKIP
        touch ../stage2/SKIP
	touch ../stage2/SKIP_IMAGES
        rm ../stage3/SKIP
        rm ../stage4/SKIP
        rm ../stage5/SKIP

elif [ "$1" = "3" ]; then
        touch ../stage0/SKIP
        touch ../stage1/SKIP
        touch ../stage2/SKIP
	touch ../stage2/SKIP_IMAGES
        touch ../stage3/SKIP
        rm ../stage4/SKIP
        rm ../stage5/SKIP

elif [ "$1" = "4" ]; then
        touch ../stage0/SKIP
        touch ../stage1/SKIP
        touch ../stage2/SKIP
	touch ../stage2/SKIP_IMAGES
        touch ../stage3/SKIP
        touch ../stage4/SKIP
        rm ../stage5/SKIP

elif [ "$1" = "rm" ]; then
	rm ../stage0/SKIP
	rm ../stage1/SKIP
	rm ../stage2/SKIP
	rm ../stage2/SKIP_IMAGES
	rm ../stage3/SKIP
	rm ../stage4/SKIP
	rm ../stage5/SKIP
fi
