#!/bin/bash

# 사용자 확인
if [ "$USER" = "root" ]; then
    echo "root로 실행하지 마세요"
    exit 1
fi

# 스크립트 입력 파라미터에 따른 동작
case "$1" in
    "0")
        touch ../stage0/SKIP
        rm -f ../stage1/SKIP ../stage2/SKIP ../stage2/SKIP_IMAGES ../stage3/SKIP ../stage4/SKIP ../stage5/SKIP
        ;;
    "1")
        touch ../stage0/SKIP ../stage1/SKIP
        rm -f ../stage2/SKIP ../stage2/SKIP_IMAGES ../stage3/SKIP ../stage4/SKIP ../stage5/SKIP
        ;;
    "2")
        touch ../stage0/SKIP ../stage1/SKIP ../stage2/SKIP ../stage2/SKIP_IMAGES
        rm -f ../stage3/SKIP ../stage4/SKIP ../stage5/SKIP
        ;;
    "3")
        touch ../stage0/SKIP ../stage1/SKIP ../stage2/SKIP ../stage2/SKIP_IMAGES ../stage3/SKIP
        rm -f ../stage4/SKIP ../stage5/SKIP
        ;;
    "4")
        touch ../stage0/SKIP ../stage1/SKIP ../stage2/SKIP ../stage2/SKIP_IMAGES ../stage3/SKIP ../stage4/SKIP
        rm -f ../stage5/SKIP
        ;;
    "full")
        rm -f ../stage0/SKIP ../stage1/SKIP ../stage2/SKIP ../stage2/SKIP_IMAGES ../stage3/SKIP ../stage4/SKIP ../stage5/SKIP
        ;;
    "light")
        touch ../stage0/SKIP ../stage1/SKIP ../stage2/SKIP ../stage2/SKIP_IMAGES ../stage3/SKIP ../stage4/SKIP ../stage5/SKIP
        ;;
    "rm")
        rm -f ../stage0/SKIP ../stage1/SKIP ../stage2/SKIP ../stage2/SKIP_IMAGES ../stage3/SKIP ../stage4/SKIP ../stage5/SKIP
        ;;
    *)
        echo "Usage: $0 {0|1|2|3|4|full|light|rm}"
        exit 1
        ;;
esac
