# local_https_server

构建一个本地 HTTPS 服务器，用法：

1. 先把 assets/rootCA.pem 添加到本地证书信任链，设置为【始终信任】。
2. 打开 local_https_server 应用。
3. 在右上角点击【+】添加一个 Bucket，Bucket 对应的路径在 macOS 中，只能是 Downloads 文件夹下的目录，这个目录必须是已经存在的。
    - 例如 BucketKey = ppp, BucketPath = /Users/用户名/Downloads/ppp
4. 在浏览器上直接输入 URL 访问文件（使用 GET 方法）
    - 例如 https://localhost:8080/ppp/test.txt
5. 使用 PUT 文法上传文件
    - 例如 https://localhost:8080/ppp/test.txt 在 PUT BODY 中输入文件内容