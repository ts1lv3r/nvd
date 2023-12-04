NAME       = nvd
IMAGE_NAME = $(NAME)-neovim
HOME       = /home/nvd
_SHELL     = zsh

up:
	docker compose up -d

run:
	docker compose up -d
	docker exec -it $(NAME) $(_SHELL)

down:
	docker rm -f $(NAME)

clean:
	docker rm -f $(NAME)
	docker rmi -f $(IMAGE_NAME)

prune:
	docker system prune --volumes -f

noc-up:
	docker build -t $(IMAGE_NAME) .
	docker run -d -t \
		-v ./.zshrc:$(HOME)/.zshrc \
		-v ./workspace:$(HOME)/workspace \
		-v ./.openai_key.zsh:$(HOME)/.openai_key.zsh \
		--name $(NAME) $(IMAGE_NAME)

noc-run:
	docker build -t $(IMAGE_NAME) .
	docker run -d -t \
		-v ./.zshrc:$(HOME)/.zshrc \
		-v ./workspace:$(HOME)/workspace \
		-v ./.openai_key.zsh:$(HOME)/.openai_key.zsh \
		--name $(NAME) $(IMAGE_NAME)
	docker exec -it $(NAME) $(_SHELL)
