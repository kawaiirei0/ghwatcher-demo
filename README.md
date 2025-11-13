## 1. 如果你的服务器有公网 IP
在 GitHub 仓库中配置 webhook：

进入仓库设置 → Webhooks → Add webhook
Payload URL: http://你的公网IP:8080/webhook
Content type: application/json
Secret: github.com/kawaiirei0/ghwatcher-demo
选择要接收的事件（或选择"Send me everything"） 保存

## 2. 如果你在本地测试（没有公网 IP）
你可以使用 ngrok 或类似工具来暴露本地端口：

```md
# 安装 ngrok
# 然后运行
```

ngrok http 8080
ngrok 会给你一个公网 URL，比如 https://abc123.ngrok.io，然后在 GitHub webhook 配置中使用：

Payload URL: https://abc123.ngrok.io/webhook
3. 或者使用轮询模式（不需要公网 IP）
修改你的代码使用轮询模式：