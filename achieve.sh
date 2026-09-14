#!/usr/bin/env bash
# Farms the GitHub profile achievements that can be earned solo, inside this
# sandbox repo only. Needs: gh (logged in), git, bash.
#
#   ./achieve.sh              # quickdraw + 16 merged co-authored PRs
#   PRS=128 ./achieve.sh      # Pull Shark silver
#   COAUTHOR="Name <id+login@users.noreply.github.com>" ./achieve.sh
#   ALT_TOKEN=ghp_xxx ./achieve.sh galaxybrain   # needs a second account
#
# Achievement -> what this script does
#   Quickdraw            open an issue, close it seconds later
#   YOLO                 merge own PR with no review (first PR does it)
#   Pull Shark           N merged PRs (2 base, 16 bronze, 128 silver, 1024 gold)
#   Pair Extraordinaire  every PR commit carries a Co-authored-by trailer
#                        (1 base, 10 bronze, 24 silver, 48 gold)
#   Galaxy Brain         ANSWERS discussions asked by ALT, answered by you,
#                        marked as answer by ALT (2 base, 8, 16, 32)
# Not scriptable: Starstruck (16 real stars), Public Sponsor (pay $1),
# Arctic Code Vault / Mars 2020 (retired), Heart On Your Sleeve /
# Open Sourcerer (unreleased as of 2026-09).
set -euo pipefail
cd "$(dirname "$0")"

REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
ME=$(gh api user --jq .login)
PRS=${PRS:-16}
ANSWERS=${ANSWERS:-2}
# Co-author is derived from ALT_TOKEN when that is set, so the second account
# never has to be typed by hand. Tested 2026-09-14: the Copilot bot account is
# parsed by GitHub as a co-author but does NOT unlock Pair Extraordinaire, so a
# real second account is required.
if [ -n "${ALT_TOKEN:-}" ]; then
  ALT=$(GH_TOKEN=$ALT_TOKEN gh api user --jq .login 2>/dev/null) || {
    echo "ALT_TOKEN was rejected by GitHub (401)." >&2
    echo "It must be a real token from a second account, not a placeholder:" >&2
    echo "  github.com/settings/tokens, Generate new token (classic), scope repo" >&2
    exit 1
  }
  [ -n "${COAUTHOR:-}" ] || COAUTHOR=$(GH_TOKEN=$ALT_TOKEN gh api user \
    --jq '"\(.name // .login) <\(.id)+\(.login)@users.noreply.github.com>"')
fi
COAUTHOR=${COAUTHOR:-"Copilot <175728472+Copilot@users.noreply.github.com>"}
DEFAULT=$(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name)

quickdraw() {
  local url
  url=$(gh issue create --title "quickdraw $(date +%s)" --body "Closed on purpose within 5 minutes.")
  gh issue close "$url" --comment "Quickdraw."
  echo "quickdraw: $url"
}

pullshark() {
  git checkout -q "$DEFAULT" && git pull -q --ff-only
  mkdir -p log
  for i in $(seq 1 "$PRS"); do
    local b="pr/$(date +%s)-$i"
    git checkout -q -b "$b"
    echo "$(date -u +%FT%TZ) pr $i" >> "log/$(date +%F).txt"
    git add log
    git commit -q -m "chore: log pr $i" -m "Co-authored-by: $COAUTHOR"
    git push -q -u origin "$b"
    local url
    url=$(gh pr create --fill --base "$DEFAULT" --head "$b")
    # ponytail: merge, not squash. Squash rewrites the message and can drop
    # the trailer unless re-added; plain merge keeps the co-authored commit.
    gh pr merge "$url" --merge --delete-branch
    git checkout -q "$DEFAULT" && git pull -q --ff-only
    echo "pr $i/$PRS merged: $url"
    sleep 3   # ponytail: secondary rate limit is on writes per minute
  done
}

# Galaxy Brain: needs ALT_TOKEN of a second account with repo access.
galaxybrain() {
  [ -n "${ALT_TOKEN:-}" ] || { echo "galaxybrain: set ALT_TOKEN (second account). skipped"; return; }
  gh repo edit --enable-discussions >/dev/null
  local alt
  alt=$(GH_TOKEN=$ALT_TOKEN gh api user --jq .login)
  gh api "repos/$REPO/collaborators/$alt" -X PUT -f permission=push >/dev/null || true
  GH_TOKEN=$ALT_TOKEN gh api "user/repository_invitations" --jq '.[] | select(.repository.full_name=="'"$REPO"'") | .id' \
    | while read -r id; do GH_TOKEN=$ALT_TOKEN gh api -X PATCH "user/repository_invitations/$id" >/dev/null; done
  local rid cid
  read -r rid cid < <(gh api graphql -f query='query($o:String!,$n:String!){repository(owner:$o,name:$n){id discussionCategories(first:20){nodes{id name isAnswerable}}}}' \
    -f o="${REPO%/*}" -f n="${REPO#*/}" \
    --jq '.data.repository | "\(.id) \(.discussionCategories.nodes[] | select(.isAnswerable) | .id)"' | head -1)
  for i in $(seq 1 "$ANSWERS"); do
    local did aid
    did=$(GH_TOKEN=$ALT_TOKEN gh api graphql -f query='mutation($r:ID!,$c:ID!,$t:String!,$b:String!){createDiscussion(input:{repositoryId:$r,categoryId:$c,title:$t,body:$b}){discussion{id}}}' \
      -f r="$rid" -f c="$cid" -f t="Question $i $(date +%s)" -f b="How do I run achieve.sh?" --jq .data.createDiscussion.discussion.id)
    aid=$(gh api graphql -f query='mutation($d:ID!,$b:String!){addDiscussionComment(input:{discussionId:$d,body:$b}){comment{id}}}' \
      -f d="$did" -f b="Run \`bash achieve.sh\` from the repo root." --jq .data.addDiscussionComment.comment.id)
    GH_TOKEN=$ALT_TOKEN gh api graphql -f query='mutation($c:ID!){markDiscussionCommentAsAnswer(input:{id:$c}){clientMutationId}}' -f c="$aid" >/dev/null
    echo "galaxybrain: answer $i/$ANSWERS marked"
    sleep 3   # ponytail: same secondary rate limit as the PR loop
  done
}

case "${1:-all}" in
  quickdraw) quickdraw ;;
  pullshark) pullshark ;;
  galaxybrain) galaxybrain ;;
  all) quickdraw; pullshark; galaxybrain ;;
  *) echo "usage: $0 [all|quickdraw|pullshark|galaxybrain]"; exit 1 ;;
esac
echo "done. badges show on https://github.com/$ME after a few minutes to hours."
