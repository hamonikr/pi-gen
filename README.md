# pi-gen

라즈베리 파이용 OS를 만드는데 사용하는 스크립트 입니다.

기본적으로 stage0 ~ stage5 단계를 진행합니다.  
하위의 단계를 건너뛸 수 없습니다.

stage0 ~ stage2 단계를 진행할 경우 서버 버전용 OS 이미지가 생성됩니다.  
stage0 ~ stage4 단계를 진행할 경우 GUI 버전의 OS 이미지가 생성됩니다.  
stage5 단계는 third party나 추가적인 패키지를 설치하는 용도입니다.

자세한 설명은 영문버전의 문서를 참고해주세요

## 빌드 방법

1. config 파일을 생성하여 내용을 작성해야 합니다.  
내용은 상황에 맞춰 작성합니다.  
자세한 내용은 영문버전의 문서를 참고해주세요
예시 :
```
IMG_NAME="hamonikr"
RELEASE="bullseye"
TARGET_HOSTNAME="rasbian"
LOCALE_DEFAULT="en_US.UTF-8"
KEBOARD_KEYMAP="us"
KEYBOARD_LAYOUT="English (US)"
TIMEZONE_DEFAULT="Asia/Seoul"
FIRST_USER_NAME="pi"
FIRST_USER_PASS="1"
ENABLE_SSH=1
STAGE_LIST="stage0 stage1 stage2 stage3 stage4"
```

2. build.sh 실행합니다.