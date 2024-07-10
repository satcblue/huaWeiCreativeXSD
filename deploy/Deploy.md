# deploy-aliyun-oss.sh

## 说明

发布xsd前的处理，生成阿里云oss的xsd目录

当前依赖于：相对路径是需要在当前目录先../到ROOT_DIR，再回到当前使用的文件的路径，

生成目录
dist/aliyun-oss/SCHEMA

## 使用

项目目录下使用
参数：OSS 存储桶地址

```shell
 deploy/deploy-aliyun-oss.sh https://hua-wei-creatives-chema.oss-cn-shenzhen.aliyuncs.com

```
