# deploy-aliyun-oss.sh

## 说明

发布xsd前的处理，生成阿里云oss的xsd目录

当前依赖于：相对路径是需要在当前目录先../到ROOT_DIR，再回到当前使用的文件的路径，

生成目录
dist/aliyun-oss/SCHEMA

## 使用

项目根目录下使用
参数：OSS 存储桶地址

```shell
 sh deploy/ali-oss/deploy-aliyun-oss.sh --bucket-domain schema-huawei-creative.oss-cn-guangzhou.aliyuncs.com --access-key-id 1234 --access-key-secret 1234

```
