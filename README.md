# cine.iosh5
swift + h5

下载准备
=======
1. 安装homebrew，如果已经安装过，则跳过此步骤
```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

查看homebrew版本号，确定是否安装成功
$ brew --version
```
2. 安装cocoapods，如果已经安装过，则跳过此步骤
```
$ brew install cocoapods

查看cocoapods版本号，确定是否安装成功
$ pod --version
```

下载项目
=======
```
$ git clone https://github.com/bstcine/cine.iosh5.git
$ cd cine.iosh5
$ pod install
$ open cine.iosh5.xcworkspace
```

启动项目
=======
  
  ### 1. 安装 wechat.sdk
  
  > 1.1. 前往微信开放平台[下载SDK](https://res.wx.qq.com/op_res/ANdzDfT57ILG_m1gEt1Pw-3Mm1NCkbcwxoDnGK8MsXU6d7O_NBGLuGZ18CnXQSi9)
  >
  > 1.2. 解压缩文件，将libWeChatSDK.a 拷贝到 /cine/Vender/Payment/ 文件夹中
  >
    
  ### 2. 安装 alipay 相关SDK
  
  > 1. 前往蚂蚁金服开放平台[下载SDK](https://openhome.alipay.com/doc/sdkResPackageDownLoad.resource?code=639b8cd68566419fb01c1c45b77ab6a7)
  >
  > 2. 解压缩后，进入 WS_APP_PAY_SDK_BASE/demo 文件夹，解压iOSDemo_2.0(SDK_15.5.9).zip，
  >
  > 3. 继续进入 iOSDemo_2.0(SDK_15.5.9) 文件夹，选中 AlipaySDK.bundle，AlipaySDK.framework 两个包文件，
  >    将两个文件拖拽到 /cine/Vender/Payment/ 文件夹中。
  > 
       
  
  ### 3. 登入开发者账号
  
  > 1. 快捷键 "command+," ，打开控制面板
  >
  > 2. 点击 "account"，登入账号
  >
  
  ### 3. 运行
  
  >
  > command+r
  >

问题
=======
  ## 1. bundleId相同的问题
    ```
    由于唤醒微信SDK需要注册id，
    每个id只能注册一个iPhone项目(bundleId)，和一个iPad项目(bundleId)，
    所以为了能够正常的使用微信分享和支付功能，只能选择与cine.ios项目相同的bundleId
    ```

    
