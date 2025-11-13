package main

import (
	"log"
	"os"
	"time"

	"github.com/kawaiirei0/ghwatcher"
)

func main() {
	w, err := ghwatcher.New(":8080", "",
		// 启用轮询模式
		ghwatcher.WithPolling(true),
		ghwatcher.WithGitHubToken(os.Getenv("GITHUB_TOKEN")),
		ghwatcher.WithRepositories("owner/repo"), // 替换为你的仓库
		ghwatcher.WithPollingInterval(30*time.Second),
	)
	if err != nil {
		log.Fatal(err)
	}

	w.On("push", func(ctx *ghwatcher.Context) error {
		log.Printf("📦 仓库 %s 收到推送: %s",
			ctx.Repo.FullName,
			ctx.Push.HeadCommit.Message)
		return nil
	})

	w.On("issues", func(ctx *ghwatcher.Context) error {
		log.Printf("📝 新 Issue: %s", ctx.Issue.Title)
		return nil
	})

	w.Run()
}
