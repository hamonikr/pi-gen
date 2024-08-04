# pi-gen

라즈베리 파이용 OS를 만드는데 사용하는 프로젝트 입니다.

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

## 빌드 프로세스 동작 방식

이미지 생성은 다음과 같은 과정으로 진행됩니다.

* 모든 단계 디렉토리를 영숫자 순서로 상호 연결

* 단계 디렉토리에 "SKIP"라는 파일이 있는 경우 단계 디렉토리를 우회합니다.

* 스크립트 실행 prerun.sh - 일반적으로 빌드 디렉터리를 단계 간에 복사하는 데만 사용됩니다.

* 각 단계 디렉터리에서 각 하위 디렉터리를 반복한 다음 포함된 각 설치 스크립트를 다시 영숫자 순서로 실행합니다. 이것들은 처음에 두 자리 숫자로 이름을 붙여야 합니다. 빌드 프로세스의 여러 부분을 제어하는 데 사용할 수 있는 다양한 파일 및 디렉토리가 있습니다.
```
00-run.sh - 셸 스크립트. 실행 권한이 있어야 합니다.

00-run-chroot.sh - 이미지 빌드 디렉터리의 chroot에서 실행되는 셸 스크립트입니다. 실행 권한이 있어야 합니다.

00-debconf - 이 파일의 내용을 debconf-set-selections에 전달하여 local 등을 구성합니다.

00-packages - 설치할 패키지 목록입니다. 한 줄에 하나 이상의 공간을 분리할 수 있습니다.

00-packages-nr - 여기 정의한 패키지는  --no-install-recommends -y apt-get 으로 설치되는 패키지 입니다.

00-patches - 퀼트를 사용하여 적용할 패치 파일이 들어 있는 디렉토리입니다. 디렉토리에 'EDIT'라는 이름의 파일이 있는 경우 빌드 프로세스가 bash 세션과 함께 중단되어 패치를 생성/수정할 수 있습니다.
```
* 스테이지 디렉토리에 "EXPORT_NOOBS" 또는 "EXPORT"라는 파일이 있는 경우IMAGE"를 생성할 이미지 목록에 이 단계를 추가합니다.

* 지정한 모든 단계에 대한 이미지 생성

## 스테이지 구성

* 스테이지 0 - 부트스트랩. 이 단계의 주요 목적은 사용 가능한 파일 시스템을 만드는 것입니다. 이는 주로 다음을 사용하여 이루어집니다. debootstrap, Debian 시스템에서 base.tgz로 사용하기에 적합한 최소 파일 시스템을 만듭니다. 이 단계에서는 적절한 설정 및 설치도 수행합니다. raspberrypi-bootloader 디부트스트랩에 의해 누락된 것입니다. 최소 코어가 설치되었지만 구성되지 않았습니다. 결과적으로 이 단계는 부팅되지 않습니다.

* 스테이지 1 - 진정으로 최소한의 시스템. 이 단계에서는 다음과 같은 시스템 파일을 설치하여 시스템을 부팅 가능하게 합니다. /etc/fstab, 부트로더를 구성하고 네트워크를 작동 가능하게 하며 raspi-config와 같은 패키지를 설치합니다. 이 단계에서는 시스템을 구성하고 설치하는 데 필요한 기본 작업을 수행할 수 있는 수단을 갖춘 로컬 콘솔로 시스템을 부팅해야 합니다.

* 스테이지 2 - 라이트 시스템. 이 단계에서는 Raspberry Pi OS Lite 이미지를 생성합니다. 2단계는 최적화된 메모리 기능을 설치하고, 시간대 및 charmap 기본값을 설정하며, fake-hwclock 및 ntp, 무선 LAN 및 블루투스 지원, dphys-swap 파일 및 하드웨어 관리를 위한 기타 기본 사항을 설치합니다. 또한 필요한 그룹을 생성하고 파이 사용자에게 sudo 및 표준 콘솔 하드웨어 권한 그룹에 대한 액세스 권한을 제공합니다.

참고: Raspberry Pi OS Lite에는 다음과 같은 다양한 개발 도구가 포함되어 있습니다. Python, Lua 그리고. build-essential 꾸러미 제품에 배포할 이미지를 생성하는 경우 배포하기 전에 관련 없는 개발 도구를 제거해야 합니다.

* 스테이지 3 - 데스크톱 시스템. X11 및 LXDE가 포함된 전체 데스크톱 시스템, 웹 브라우저, 개발용 깃, Raspberry Pi OS 사용자 정의 UI 향상 등을 얻을 수 있습니다. 이것은 기본 데스크톱 시스템이며 일부 개발 도구가 설치되어 있습니다.

* 스테이지 4 - 일반 라즈베리 파이 OS 이미지 4GB 카드에 장착할 수 있는 시스템입니다. 이것은 시스템 설명서와 같이 Raspberry Pi OS를 새로운 사용자에게 친숙하게 만드는 대부분의 것을 설치하는 단계입니다.

* 스테이지 4 하모니카 - 하모니카 OS 관련 대부분의 것을 설치하는 단계입니다.

* 스테이지 5 - 라즈베리 파이 OS 전체 이미지. 더 많은 개발 도구, 이메일 클라이언트, Scratch와 같은 학습 도구, sonic-pi와 같은 전문 패키지, 사무실 생산성 등이 있습니다.

### 스테이지 설정방법
프로젝트 루트에 `config` 파일에서 다음과 같이 정의합니다.

```
IMG_NAME="hamonikr-8-arm64"
RELEASE="bookworm"
DEPLOY_COMPRESSION="xz"
COMPRESSION_LEVEL="9"
LOCALE_DEFAULT="ko_KR.UTF-8"
TARGET_HOSTNAME="hamonikr"
KEBOARD_KEYMAP="us"
KEYBOARD_LAYOUT="Korean - Korean (101/104-key compatible)"
TIMEZONE_DEFAULT="Asia/Seoul"
FIRST_USER_NAME="pi"
DISABLE_FIRST_BOOT_USER_RENAME="0"
FIRST_USER_PASS="hamonikr"
ENABLE_SSH=1
STAGE_LIST="stage0 stage1 stage2 stage3 stage4_hamonikr"
```

기본적으로 stage0 ~ stage5 단계를 진행합니다.  
하위의 단계를 건너뛸 수 없습니다.

* stage0 ~ stage2 단계를 진행할 경우 서버 버전용 OS 이미지가 생성됩니다.  
* stage0 ~ stage4 단계를 진행할 경우 GUI 버전의 OS 이미지가 생성됩니다.  
* stage5 단계는 third party나 추가적인 패키지를 설치하는 용도입니다.

### 개발 속도를 높이기 위한 단계 건너뛰기

ref : https://github.com/RPi-Distro/pi-gen

특정 단계에서 작업하는 경우 권장되는 개발 프로세스는 다음과 같습니다.

* EXPORT_* 파일이 들어 있는 디렉토리에 SKIP_IMAGES라는 파일을 추가합니다(현재 stage2, stage4, stage5).
* 빌드하지 않을 단계에 SKIP 파일을 추가합니다. 예를 들어, 라이트 이미지를 기반으로 이미지를 구성하는 경우 3단계, 4단계 및 5단계에 추가할 수 있습니다.
* 빌드를 실행해서 모든 단계를 구축합니다.
* 이전에 성공적으로 구축된 단계에 SKIP 파일 추가
* 마지막 단계 수정
* 마지막 단계만 재구축(Rebuilding): `sudo CLEAN=1 ./build.sh`
* 이미지에 만족하면 SKIP_IMAGES 파일을 제거하고 이미지를 내보내 테스트할 수 있습니다.
