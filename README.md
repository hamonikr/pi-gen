# pi-gen

라즈베리 파이용 OS를 만드는데 사용하는 스크립트 입니다.

기본적으로 stage0 ~ stage5 단계를 진행합니다.  
하위의 단계를 건너뛸 수 없습니다.

stage0 ~ stage2 단계를 진행할 경우 서버 버전용 OS 이미지가 생성됩니다.  
stage0 ~ stage4 단계를 진행할 경우 GUI 버전의 OS 이미지가 생성됩니다.  
stage5 단계는 third party나 추가적인 패키지를 설치하는 용도입니다.

이 프로젝트는 아래 업스트림을 포크하여 하모니카 버전을 생성할 수 있도록 수정한 버전입니다. 

upstream : https://github.com/RPi-Distro/pi-gen

## 빌드 방법

### 1. 필수 패키지 설치

빌드 전 우선 필요한 아래의 패키지를 설치해야 합니다.
```
sudo apt-get install coreutils quilt parted qemu-user-static debootstrap zerofree zip \
dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
qemu-utils kpartx gpg pigz
```


### 2. config 파일 생성

build.sh 파일이 있는 같은 경로에 config 파일을 생성합니다.

파일의 자세한 내용은 아래 링크한 영문버전의 문서를 참고해주세요.

ref : https://github.com/RPi-Distro/pi-gen

config 파일 예시 :
```
IMG_NAME="hamonikr-arm64"
RELEASE="bookworm"
DEPLOY_COMPRESSION="xz"
COMPRESSION_LEVEL="9"
LOCALE_DEFAULT="en_US.UTF-8"
TARGET_HOSTNAME="hamonikr"
KEBOARD_KEYMAP="us"
KEYBOARD_LAYOUT="Korean - Korean (101/104-key compatible)"
TIMEZONE_DEFAULT="Asia/Seoul"
FIRST_USER_NAME="pi"
DISABLE_FIRST_BOOT_USER_RENAME="0"
FIRST_USER_PASS="hamonikr"
ENABLE_SSH=1
STAGE_LIST="stage0 stage1 stage2 stage3 stage4"
```

### 3. 빌드 스크립트 실행

build.sh 실행합니다.