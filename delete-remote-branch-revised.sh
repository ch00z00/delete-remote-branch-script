#!/bin/bash

# プログレスバー表示関数
function show_progress {
    current="$1"
    total="$2"

    # プログレスバーのサイズと表示文字
    bar_size=40
    bar_char_done="#"
    bar_char_todo="-"
    bar_percentage_scale=2

    # 進捗率の計算
    if [ $total -eq 0 ]; then
        percent=0
    else
        percent=$(bc <<< "scale=$bar_percentage_scale; 100 * $current / $total" )
    fi

    # プログレスバーの作成
    done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
    todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

    # プログレスバーの表示
    tput sc
    tput el1
    echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"
    tput rc
    }

# リモートブランチを削除するスクリプト
if [ -z "$1" ]; then
  echo "Usage: $0 <grep_string>"
  exit 1
fi

grep_string="$1"

echo -e "\033[33mFetching remote branches...\033[0m"
git fetch

# 削除対象のブランチ数をカウント
branches_to_delete=$(git branch -r | grep "origin/$grep_string" | wc -l)

if [ $branches_to_delete -eq 0 ]; then
    echo "No branches found to delete."
    exit 0
fi

echo -e "\n\033[32mDeleting remote branches...\033[0m"

# 削除処理とプログレスバー表示
current_branch=0
for branch in $(git branch -r | grep "origin/$grep_string" | sed 's/origin\///'); do
  git push origin :"$branch"
  current_branch=$((current_branch + 1))
  show_progress $current_branch $branches_to_delete
done

echo -e "\n Deleted remote branch matches $grep_string ✨"
