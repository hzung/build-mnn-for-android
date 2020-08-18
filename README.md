How to build the [MNN library](https://github.com/alibaba/MNN) and make the demo Android app work. I build the library using Docker so these steps should work for Windows, Linux, MacOS.

Step 1. Download [android-ndk-r21d](https://dl.google.com/android/repository/android-ndk-r21d-linux-x86_64.zip) and extract to the directory `build-mnn-for-android/android-ndk-r21d`

Step 2. Clone the repository [https://github.com/alibaba/MNN](https://github.com/alibaba/MNN) into `build-mnn-for-android/MNN`

The final folder structure should look like this:

```
├── Dockerfile
├── MNN
...
│   ├── ciscripts
│   ├── cmake
│   ├── express
│   ├── include
│   ├── package_scripts
│   ├── project
...
├── README.md
├── android-ndk-r21d
...
│   ├── ndk-build
│   ├── ndk-gdb
│   ├── ndk-stack
│   ├── ndk-which
│   ├── platforms
│   ├── sources
│   ├── sysroot
...
```

Step 3. Build the building environment image

```
cd build-mnn-for-android
docker image build -t build_mnn_env:v01 .
```

Step 4. Start the container `build_mnn`

```
docker container run \
-v $(pwd)/android-ndk-r21d:/android-ndk-r21d \
-v $(pwd)/MNN:/MNN \
-v $(pwd)/protoc-3.13.0-linux-x86_64:/protoc-3.13.0-linux-x86_64 \
--name build_mnn \
-td build_mnn_env:v01
```

Step 5. Access to the shell of container `build_mnn`

```
docker exec -it build_mnn /bin/bash
```

Inside the shell of container `build_mnn`

```
cd /MNN
./schema/generate.sh
mkdir build
cd build
cmake .. -DMNN_BUILD_CONVERTER=true && make -j4
cd /MNN
./tools/script/get_model.sh
cd project/android
mkdir build_64 && cd build_64 && ../build_64.sh
```

Step 6. Exit the shell of the container `build_mnn`

Step 7. Create the folder `MNN/demo/android/app/libs/arm64-v8a` copy the file `MNN/project/android/build_64/libMNN.so` into it.
Here is the path of the file: `MNN/demo/android/app/libs/arm64-v8a/libMNN.so`

Step 8. Update abiFilters in the build.gradle `MNN/demo/android/app/build.gradle` to `arm64-v8a`

```
...
buildTypes {
        debug {
            ndk {
                abiFilters 'arm64-v8a'
            }
        }
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
...
```

Step 9. Open the file `MNN/demo/android/app/src/main/java/com/taobao/android/mnndemo/VideoActivity.java`, added the check null code to the onResume method.

```
...
@Override
protected void onResume() {
    super.onResume();
    if (mCameraView != null) {
        mCameraView.onResume();
    }
}
...
```

Now, let's open the demo project at `MNN/demo/android` using your Android Studio and build to your device. It should work.

Cheer!
