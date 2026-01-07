package main

import (
	"log"

	"github.com/rei0721/ghhook"
)

func main() {
	// 创建新的监听器
	hook, err := ghhook.New(":9901", "qwq")
	if err != nil {
		log.Fatal(err)
	}

	// 注册 push 事件钩子
	hook.On("push", func(ctx *ghhook.Context) error {
		log.Printf("📦 Rei 仓库 %s 收到推送: %s",
			ctx.Repo.FullName,
			ctx.Push.HeadCommit.Message)
		return nil
	})

	// 注册 issue 事件钩子
	hook.On("issues", func(ctx *ghhook.Context) error {
		log.Printf("📝 Rei 新 Issue: %s", ctx.Issue.Title)
		return nil
	})

	// 启动监听器
	w.Run()
}
